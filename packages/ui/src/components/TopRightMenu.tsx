'use client'

import { useState, useRef, useEffect } from 'react'
import { useSession } from 'next-auth/react'
import { ServiceSwitcher } from './ServiceSwitcher'
import { UserMenu } from './UserMenu'

interface TopRightMenuProps {
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
}

export function TopRightMenu({ 
  serviceName, 
  serviceColor = 'blue',
  showServiceSwitcher = true 
}: TopRightMenuProps) {
  const { data: session, status } = useSession()
  const [isOpen, setIsOpen] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)

  // Close dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const colorClasses = {
    blue: 'bg-blue-600 hover:bg-blue-700',
    green: 'bg-green-600 hover:bg-green-700',
    purple: 'bg-purple-600 hover:bg-purple-700',
    red: 'bg-red-600 hover:bg-red-700'
  }

  if (status === 'loading') {
    return (
      <div className="flex items-center space-x-3">
        <div className="animate-pulse flex space-x-4">
          <div className="rounded-full bg-gray-200 h-8 w-8"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="flex items-center space-x-3">
      {/* Service Switcher */}
      {showServiceSwitcher && (
        <ServiceSwitcher 
          currentService={serviceName}
          currentColor={serviceColor}
        />
      )}

      {/* Authentication Section */}
      {session ? (
        <UserMenu serviceColor={serviceColor} />
      ) : (
        <div className="relative" ref={dropdownRef}>
          {/* Combined Auth Button */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1"
            aria-expanded={isOpen}
            aria-haspopup="true"
          >
            <span className="text-gray-700 font-medium">Account</span>
            <svg
              className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
            </svg>
          </button>

          {/* Auth Dropdown - Fixed positioning */}
          {isOpen && (
            <div className="absolute right-0 top-full mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
              <div className="px-4 py-3 border-b border-gray-100">
                <h3 className="text-sm font-semibold text-gray-700">Get Started</h3>
                <p className="text-xs text-gray-500 mt-1">Sign in to access all features</p>
              </div>
              
              <div className="py-2 space-y-1">
                <a
                  href="http://localhost:3000/auth/sign-in"
                  className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                  onClick={() => setIsOpen(false)}
                >
                  <span className="mr-3">🔑</span>
                  Sign In
                  <span className="ml-auto text-xs text-gray-400">Existing user</span>
                </a>
                <a
                  href="http://localhost:3000/auth/sign-up"
                  className={`flex items-center px-4 py-2 text-sm text-white ${colorClasses[serviceColor]} rounded-md mx-2 transition-colors`}
                  onClick={() => setIsOpen(false)}
                >
                  <span className="mr-3">✨</span>
                  Create Account
                  <span className="ml-auto text-xs opacity-75">Free</span>
                </a>
              </div>

              <div className="border-t border-gray-100 px-4 py-2 mt-2">
                <div className="text-xs text-gray-500">
                  🔐 Secure authentication across all services
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default TopRightMenu
