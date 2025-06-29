'use client'
import { useSession, signIn, signOut } from 'next-auth/react'
import { useEffect, useState } from 'react'

export default function ContentServiceHome() {
  const { data: session, status } = useSession()
  const [content, setContent] = useState([])

  const handleSignIn = () => {
    // Redirect to the auth service sign-in page
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callbackUrl = window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callbackUrl)}`
  }

  if (status === 'loading') {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
      </div>
    )
  }

  if (!session) {
    return (
      <div className="text-center py-12">
        <h1 className="text-2xl mb-4">Content Management Service</h1>
        <p className="text-gray-600 mb-8">Sign in to access content management features.</p>
        <button 
          onClick={handleSignIn}
          className="bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors"
        >
          Sign in with Auth Service
        </button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Content Management</h1>
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

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-xl font-semibold mb-4">Content Actions</h2>
        <div className="grid md:grid-cols-3 gap-4">
          <button className="bg-blue-500 text-white p-4 rounded">
            Create Article
          </button>
          <button className="bg-green-500 text-white p-4 rounded">
            Manage Posts
          </button>
          <button className="bg-purple-500 text-white p-4 rounded">
            View Analytics
          </button>
        </div>
      </div>
    </div>
  )
}

