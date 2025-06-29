// Replace your src/components/ProtectedRoute.tsx with this fixed version:

'use client'

import { useSession } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'

export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { data: session, status } = useSession()
  const router = useRouter()
  const [hasCheckedAuth, setHasCheckedAuth] = useState(false)

  useEffect(() => {
    console.log('🛡️ ProtectedRoute status check:', { status, hasSession: !!session })
    
    // Only redirect after we've confirmed the session status
    if (status === 'loading') {
      console.log('🛡️ ProtectedRoute: Session still loading, waiting...')
      return
    }

    // Mark that we've checked authentication
    setHasCheckedAuth(true)

    if (status === 'unauthenticated' || !session) {
      console.log('🛡️ ProtectedRoute: No session found, redirecting to sign-in')
      router.push('/auth/sign-in')
    } else {
      console.log('🛡️ ProtectedRoute: Session confirmed, allowing access')
    }
  }, [session, status, router])

  // Show loading while session is being checked
  if (status === 'loading' || !hasCheckedAuth) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Verifying authentication...</p>
        </div>
      </div>
    )
  }

  // Don't render anything if not authenticated (redirect is happening)
  if (status === 'unauthenticated' || !session) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Redirecting to sign-in...</p>
        </div>
      </div>
    )
  }

  // Render the protected content
  return <>{children}</>
}