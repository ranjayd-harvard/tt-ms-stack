'use client'

import ProtectedRoute from '@/components/ProtectedRoute'
import { useSession } from 'next-auth/react'
import { useState, useEffect } from 'react'

export default function Dashboard() {
  // FIXED: Safe session handling for SSR
  const sessionResult = useSession()
  const session = sessionResult?.data
  const status = sessionResult?.status || 'loading'
  
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  // Single loading check that handles both mounting and session loading
  if (!mounted || status === 'loading') {
    return (
      <ProtectedRoute>
        <div className="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            <span className="ml-3 text-gray-600">Loading dashboard...</span>
          </div>
        </div>
      </ProtectedRoute>
    )
  } 

  return (
    <ProtectedRoute>
      <div className="px-4 py-6 sm:px-0">
        <div className="bg-white shadow rounded-lg p-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Dashboard</h1>
          <div className="border-l-4 border-blue-400 bg-blue-50 p-4 mb-6">
            <div className="flex">
              <div className="ml-3">
                <p className="text-sm text-blue-700">
                  🔒 This is a protected page. Only authenticated users can access it.
                </p>
              </div>
            </div>
          </div>
          {session && (
            <div className="space-y-4">
              <h2 className="text-xl font-semibold text-gray-800">
                Welcome back, {session.user?.name}!
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="bg-gray-50 p-4 rounded-lg">
                  <h3 className="font-medium text-gray-900">Total Projects</h3>
                  <p className="text-2xl font-bold text-blue-600">12</p>
                </div>
                <div className="bg-gray-50 p-4 rounded-lg">
                  <h3 className="font-medium text-gray-900">Active Tasks</h3>
                  <p className="text-2xl font-bold text-green-600">8</p>
                </div>
                <div className="bg-gray-50 p-4 rounded-lg">
                  <h3 className="font-medium text-gray-900">Completed</h3>
                  <p className="text-2xl font-bold text-purple-600">24</p>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </ProtectedRoute>
  )
}