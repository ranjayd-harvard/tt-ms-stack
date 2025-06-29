'use client'
import { useSession } from 'next-auth/react'

export default function ContentServiceHome() {
  const { data: session, status } = useSession()

  const handleSignIn = () => {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callbackUrl = window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callbackUrl)}`
  }

  if (status === 'loading') {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-600"></div>
      </div>
    )
  }

  if (!session) {
    return (
      <div className="max-w-4xl mx-auto">
        {/* Hero Section - matching Auth Service style */}
        <div className="text-center py-12">
          <div className="mx-auto max-w-md rounded-lg border border-gray-200 bg-white p-8 shadow-sm">
            <div className="mb-6">
              <div className="mx-auto w-16 h-16 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-2xl font-bold text-white">C</span>
              </div>
            </div>
            
            <h1 className="text-2xl font-bold text-gray-900 mb-4">Welcome to Content Service</h1>
            <p className="text-gray-600 mb-6">This is a protected service accessible to authenticated users.</p>
            
            <div className="space-y-4">
              <div className="flex items-center justify-center space-x-2 text-sm text-purple-600">
                <span>✅</span>
                <span>Protected access</span>
              </div>
              <div className="flex items-center justify-center space-x-2 text-sm text-gray-500">
                <span>🔐</span>
                <span>Authentication required</span>
              </div>
            </div>

            <div className="mt-8">
              <button 
                onClick={handleSignIn}
                className="w-full bg-purple-600 text-white py-3 px-4 rounded-md font-medium hover:bg-purple-700 transition-colors"
              >
                Sign in to continue
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="text-center py-12">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">Content Management Dashboard</h1>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">📝</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Articles</h3>
            <p className="text-gray-600 text-sm mb-4">Create and manage articles.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Manage
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">🖼️</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Media</h3>
            <p className="text-gray-600 text-sm mb-4">Upload and organize files.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Library
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">🏷️</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Categories</h3>
            <p className="text-gray-600 text-sm mb-4">Organize content.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Manage
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">📊</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Analytics</h3>
            <p className="text-gray-600 text-sm mb-4">View performance.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              View
            </button>
          </div>
        </div>

        <div className="mt-8 text-center">
          <p className="text-gray-600">Welcome back, {session.user?.name}!</p>
        </div>
      </div>
    </div>
  )
}
