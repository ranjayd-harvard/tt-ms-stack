'use client'

import { useState, useRef, useEffect } from 'react'
import { useSession, signOut } from 'next-auth/react'

interface UserMenuProps {
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
}

export function UserMenu({ serviceColor = 'blue' }: UserMenuProps) {
  const { data: session } = useSession()
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

  if (!session) return null

  const getInitials = () => {
    if (session.user?.name) {
      return session.user.name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
    }
    if (session.user?.email) {
      return session.user.email[0].toUpperCase()
    }
    return 'U'
  }

  const colorClasses = {
    blue: 'bg-blue-600',
    green: 'bg-green-600',
    purple: 'bg-purple-600',
    red: 'bg-red-600'
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* User Avatar Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 p-1 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1"
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        {session.user?.image ? (
          <img
            className="h-8 w-8 rounded-full object-cover border-2 border-gray-200"
            src={session.user.image}
            alt={session.user.name || 'User avatar'}
          />
        ) : (
          <div className={`h-8 w-8 ${colorClasses[serviceColor]} rounded-full flex items-center justify-center text-white text-sm font-medium border-2 border-white shadow-sm`}>
            {getInitials()}
          </div>
        )}
        <div className="hidden md:block text-left">
          <div className="text-sm font-medium text-gray-700 truncate max-w-32">
            {session.user?.name || session.user?.email}
          </div>
        </div>
        <svg
          className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* Dropdown Menu - Fixed positioning */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-72 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
          {/* User Info Header */}
          <div className="px-4 py-3 border-b border-gray-100">
            <div className="flex items-center space-x-3">
              {session.user?.image ? (
                <img
                  className="h-10 w-10 rounded-full object-cover border-2 border-gray-200"
                  src={session.user.image}
                  alt={session.user.name || 'User avatar'}
                />
              ) : (
                <div className={`h-10 w-10 ${colorClasses[serviceColor]} rounded-full flex items-center justify-center text-white font-medium border-2 border-white shadow-sm`}>
                  {getInitials()}
                </div>
              )}
              <div className="flex-1 min-w-0">
                <div className="font-medium text-gray-900 truncate">
                  {session.user?.name || 'User'}
                </div>
                <div className="text-sm text-gray-500 truncate">
                  {session.user?.email}
                </div>
              </div>
            </div>
          </div>

          {/* Menu Items */}
          <div className="py-1">
            <a
              href="/account/profile"
              className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              onClick={() => setIsOpen(false)}
            >
              <span className="mr-3">👤</span>
              Account Profile
            </a>
            <a
              href="/account/security"
              className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              onClick={() => setIsOpen(false)}
            >
              <span className="mr-3">🔐</span>
              Security Settings
            </a>
            <a
              href="/account/activity"
              className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              onClick={() => setIsOpen(false)}
            >
              <span className="mr-3">📊</span>
              Account Activity
            </a>
            <a
              href="/help"
              className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              onClick={() => setIsOpen(false)}
            >
              <span className="mr-3">❓</span>
              Help & Support
            </a>
            
            <div className="border-t border-gray-100 mt-1 pt-1">
              <button
                onClick={() => {
                  setIsOpen(false)
                  signOut({ callbackUrl: '/' })
                }}
                className="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
              >
                <span className="mr-3">🚪</span>
                Sign Out
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default UserMenu
