'use client'

import { useSession as useNextAuthSession } from 'next-auth/react'
import { useEffect, useState } from 'react'

export function useSafeSession() {
  const [mounted, setMounted] = useState(false)
  const sessionResult = useNextAuthSession()

  useEffect(() => {
    setMounted(true)
  }, [])

  // Return safe defaults until mounted
  if (!mounted) {
    return {
      data: null,
      status: 'loading' as const,
      update: sessionResult?.update || (() => Promise.resolve(null)),
    }
  }

  // Return actual session data after mounting
  return {
    data: sessionResult?.data || null,
    status: sessionResult?.status || 'loading',
    update: sessionResult?.update || (() => Promise.resolve(null)),
  }
}
