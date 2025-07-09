// Copy the content from the fixed security page artifact above
// This is just a placeholder showing the pattern
'use client'

import { useState, useEffect } from 'react'
import { useSafeSession } from '@/hooks/useSafeSession'
import ProtectedRoute from '@/components/ProtectedRoute'
import SafeClientWrapper from '@/components/SafeClientWrapper'

export default function SecurityPage() {
  // ✅ SAFE: Use the safe session hook
  const { data: session, status } = useSafeSession()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  // ✅ SAFE: Don't render until mounted
  if (!mounted) {
    return (
      <ProtectedRoute>
        <div className="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
          <div className="animate-pulse space-y-6">
            <div className="h-8 bg-gray-200 rounded w-1/3"></div>
            <div className="h-4 bg-gray-200 rounded w-2/3"></div>
          </div>
        </div>
      </ProtectedRoute>
    )
  }

  return (
    <ProtectedRoute>
      <SafeClientWrapper>
        <div className="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">Account Security</h1>
          {/* Your actual component content here */}
        </div>
      </SafeClientWrapper>
    </ProtectedRoute>
  )
}
