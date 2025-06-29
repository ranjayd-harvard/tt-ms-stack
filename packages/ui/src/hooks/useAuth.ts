// packages/ui/src/hooks/useAuth.ts
'use client'

import { useSession } from 'next-auth/react'

export function useAuth() {
  const { data: session, status } = useSession()

  const redirectToAuth = (callbackUrl?: string) => {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callback = callbackUrl || window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callback)}`
  }

  const redirectToSignOut = () => {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    window.location.href = `${authServiceUrl}/auth/sign-out`
  }

  return {
    session,
    status,
    isLoading: status === 'loading',
    isAuthenticated: status === 'authenticated',
    user: session?.user,
    redirectToAuth,
    redirectToSignOut
  }
}
