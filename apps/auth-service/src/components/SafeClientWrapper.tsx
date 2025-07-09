'use client'

import { ReactNode, useEffect, useState } from 'react'

interface SafeClientWrapperProps {
  children: ReactNode
  fallback?: ReactNode
}

export default function SafeClientWrapper({ 
  children, 
  fallback = <div>Loading...</div> 
}: SafeClientWrapperProps) {
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return <>{fallback}</>
  }

  return <>{children}</>
}
