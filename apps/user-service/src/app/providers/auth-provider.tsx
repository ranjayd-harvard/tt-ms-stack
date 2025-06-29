'use client'
import { SessionProvider } from 'next-auth/react'

export function AuthProvider({ children }: { children: React.ReactNode }) {
  return (
    <SessionProvider 
      baseUrl={process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'}
      basePath="/api/auth"
    >
      {children}
    </SessionProvider>
  )
}