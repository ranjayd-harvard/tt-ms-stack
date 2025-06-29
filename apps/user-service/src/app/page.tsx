'use client'
import { useSession, signIn, signOut } from 'next-auth/react'
import { useEffect, useState } from 'react'

export default function UserServiceHome() {
  const { data: session, status } = useSession()
  const [users, setUsers] = useState([])

  useEffect(() => {
    if (session) {
      fetchUsers()
    }
  }, [session])

  const fetchUsers = async () => {
    try {
      const response = await fetch('/api/users')
      const data = await response.json()
      setUsers(data.users || [])
    } catch (error) {
      console.error('Failed to fetch users:', error)
    }
  }

  const handleSignIn = () => {
    // Redirect to the auth service sign-in page
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callbackUrl = window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callbackUrl)}`
  }

  if (status === 'loading') {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (!session) {
    return (
      <div className="text-center py-12">
        <h1 className="text-2xl mb-4">User Management Service</h1>
        <p className="text-gray-600 mb-8">Sign in to access user management features.</p>
        <button 
          onClick={handleSignIn}
          className="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
        >
          Sign in with Auth Service
        </button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">User Management</h1>
        <div className="flex items-center gap-4">
          <span className="text-gray-600">Welcome, {session.user?.name}</span>
          <button 
            onClick={() => signOut({ callbackUrl: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL })}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition-colors"
          >
            Sign out
          </button>
        </div>
      </div>

      {/* Your existing user management UI */}
      <div className="grid md:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">Current User</h2>
          <div className="space-y-3">
            <div>
              <label className="font-medium text-gray-700">Name:</label>
              <p className="text-gray-900">{session.user?.name}</p>
            </div>
            <div>
              <label className="font-medium text-gray-700">Email:</label>
              <p className="text-gray-900">{session.user?.email}</p>
            </div>
            <div>
              <label className="font-medium text-gray-700">User ID:</label>
              <p className="text-gray-900 font-mono text-sm">{session.user?.id}</p>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">Quick Actions</h2>
          <div className="space-y-3">
            <button 
              onClick={fetchUsers}
              className="w-full bg-blue-500 text-white p-3 rounded hover:bg-blue-600 transition-colors"
            >
              Refresh User List
            </button>
            <button className="w-full bg-green-500 text-white p-3 rounded hover:bg-green-600 transition-colors">
              Update Profile
            </button>
            <button className="w-full bg-yellow-500 text-white p-3 rounded hover:bg-yellow-600 transition-colors">
              Manage Settings
            </button>
          </div>
        </div>
      </div>

      {/* Users list */}
      {users.length > 0 && (
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">Users</h2>
          <div className="space-y-2">
            {users.map((user: any) => (
              <div key={user.id} className="p-3 border rounded">
                <p><strong>Name:</strong> {user.name}</p>
                <p><strong>Email:</strong> {user.email}</p>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

