// apps/auth-service/src/app/profile/page.tsx
'use client'

import { useEffect, useState } from 'react'
import ProtectedRoute from '@/components/ProtectedRoute'
import { useSession } from 'next-auth/react'

export default function Profile() {
  // FIXED: Safe session handling for SSR
  const sessionResult = useSession()
  const session = sessionResult?.data
  const status = sessionResult?.status || 'loading'
  
  const [mounted, setMounted] = useState(false)

  // Ensure component is mounted before accessing session
  useEffect(() => {
    setMounted(true)
  }, [])

  // Single loading check that handles both mounting and session loading
  if (!mounted || status === 'loading') {
    return (
      <ProtectedRoute>
        <div className="px-4 py-6 sm:px-0">
          <div className="bg-white shadow rounded-lg p-6">
            <div className="animate-pulse">
              <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
              <div className="h-4 bg-gray-200 rounded w-3/4 mb-4"></div>
              <div className="h-4 bg-gray-200 rounded w-1/2"></div>
            </div>
          </div>
        </div>
      </ProtectedRoute>
    )
  }

  return (
    <ProtectedRoute>
      <div className="px-4 py-6 sm:px-0">
        <div className="bg-white shadow rounded-lg p-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-6">User Profile</h1>
          <div className="border-l-4 border-green-400 bg-green-50 p-4 mb-6">
            <div className="flex">
              <div className="ml-3">
                <p className="text-sm text-green-700">
                  🔐 Another protected page - authentication required!
                </p>
              </div>
            </div>
          </div>

          {session?.user ? (
            <div className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 className="text-lg font-medium text-gray-900 mb-4">
                    Account Information
                  </h3>
                  <dl className="space-y-3">
                    <div>
                      <dt className="text-sm font-medium text-gray-500">Name</dt>
                      <dd className="text-sm text-gray-900">
                        {session.user.name || 'Not provided'}
                      </dd>
                    </div>
                    <div>
                      <dt className="text-sm font-medium text-gray-500">Email</dt>
                      <dd className="text-sm text-gray-900">
                        {session.user.email || 'Not provided'}
                      </dd>
                    </div>
                    <div>
                      <dt className="text-sm font-medium text-gray-500">User ID</dt>
                      <dd className="text-sm text-gray-900 font-mono">
                        {session.user.id || 'Not available'}
                      </dd>
                    </div>
                  </dl>
                </div>

                <div>
                  <h3 className="text-lg font-medium text-gray-900 mb-4">
                    Session Details
                  </h3>
                  <dl className="space-y-3">
                    <div>
                      <dt className="text-sm font-medium text-gray-500">Status</dt>
                      <dd className="text-sm text-green-600 font-medium">
                        ✅ Authenticated
                      </dd>
                    </div>
                    <div>
                      <dt className="text-sm font-medium text-gray-500">Register Source</dt>
                      <dd className="text-sm text-gray-900">
                        {(session.user as any).registerSource || 'Not available'}
                      </dd>
                    </div>
                    <div>
                      <dt className="text-sm font-medium text-gray-500">Avatar Type</dt>
                      <dd className="text-sm text-gray-900">
                        {(session.user as any).avatarType || 'default'}
                      </dd>
                    </div>
                  </dl>
                </div>
              </div>

              <div className="mt-8 pt-8 border-t border-gray-200">
                <h3 className="text-lg font-medium text-gray-900 mb-4">
                  Quick Actions
                </h3>
                <div className="flex space-x-4">
                  <button className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition-colors">
                    Edit Profile
                  </button>
                  <button className="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition-colors">
                    Account Settings
                  </button>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-8">
              <p className="text-gray-500">Please sign in to view your profile.</p>
            </div>
          )}
        </div>
      </div>
    </ProtectedRoute>
  )
}