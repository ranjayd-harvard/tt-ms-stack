#!/bin/bash

echo "🔧 Fixing dropdown positioning and profile avatar issues..."

echo ""
echo "1️⃣ Fixing ServiceSwitcher dropdown positioning..."

cat > "packages/ui/src/components/ServiceSwitcher.tsx" << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'

interface Service {
  name: string
  url: string
  color: string
  description: string
  icon: string
}

interface ServiceSwitcherProps {
  currentService: string
  currentColor?: string
}

export function ServiceSwitcher({ currentService, currentColor = 'blue' }: ServiceSwitcherProps) {
  const [isOpen, setIsOpen] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)

  const services: Service[] = [
    {
      name: 'Auth Service',
      url: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000',
      color: 'blue',
      description: 'Authentication & Authorization',
      icon: '🔐'
    },
    {
      name: 'User Service',
      url: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001',
      color: 'green',
      description: 'User Management',
      icon: '👥'
    },
    {
      name: 'Content Service',
      url: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002',
      color: 'purple',
      description: 'Content Management',
      icon: '📝'
    }
  ]

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

  const colorClasses: Record<string, string> = {
    blue: 'bg-blue-100 text-blue-800 border-blue-200',
    green: 'bg-green-100 text-green-800 border-green-200',
    purple: 'bg-purple-100 text-purple-800 border-purple-200'
  }

  const currentServiceData = services.find(service => service.name === currentService)

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Dropdown Trigger Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1"
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        <span className="text-lg">{currentServiceData?.icon || '⚙️'}</span>
        <span className="font-medium text-gray-700">{currentService}</span>
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
        <div className="absolute right-0 top-full mt-2 w-80 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
          {/* Header */}
          <div className="px-4 py-2 border-b border-gray-100">
            <h3 className="text-sm font-semibold text-gray-700">Switch Service</h3>
            <p className="text-xs text-gray-500 mt-1">Navigate between microservices</p>
          </div>

          {/* Service List */}
          <div className="py-2">
            {services.map((service) => {
              const isCurrent = service.name === currentService
              return (
                <a
                  key={service.name}
                  href={service.url}
                  className={`flex items-start space-x-3 px-4 py-3 transition-colors ${
                    isCurrent
                      ? `${colorClasses[service.color]} border-l-4 border-${service.color}-500`
                      : 'hover:bg-gray-50'
                  }`}
                  onClick={() => setIsOpen(false)}
                >
                  <span className="text-xl mt-0.5">{service.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className={`text-sm font-medium ${
                      isCurrent ? `text-${service.color}-900` : 'text-gray-900'
                    }`}>
                      {service.name}
                      {isCurrent && (
                        <span className="ml-2 px-2 py-0.5 text-xs bg-white bg-opacity-50 rounded-full">
                          Current
                        </span>
                      )}
                    </div>
                    <div className={`text-xs ${
                      isCurrent ? `text-${service.color}-700` : 'text-gray-500'
                    } mt-1`}>
                      {service.description}
                    </div>
                    {!isCurrent && (
                      <div className="text-xs text-gray-400 mt-1">
                        Click to switch → {service.url.replace('http://', '')}
                      </div>
                    )}
                  </div>
                  {!isCurrent && (
                    <div className="flex-shrink-0 mt-1">
                      <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                      </svg>
                    </div>
                  )}
                </a>
              )
            })}
          </div>

          {/* Footer */}
          <div className="border-t border-gray-100 px-4 py-2 mt-2">
            <div className="text-xs text-gray-500 flex items-center space-x-1">
              <span>💡</span>
              <span>Each service runs independently with shared authentication</span>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ServiceSwitcher
EOF

echo ""
echo "2️⃣ Fixing UserMenu dropdown positioning..."

cat > "packages/ui/src/components/UserMenu.tsx" << 'EOF'
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
EOF

echo ""
echo "3️⃣ Fixing TopRightMenu dropdown positioning..."

cat > "packages/ui/src/components/TopRightMenu.tsx" << 'EOF'
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
EOF

echo ""
echo "4️⃣ Updating Navigation to ensure proper z-index stacking..."

cat > "packages/ui/src/components/Navigation.tsx" << 'EOF'
'use client'

import { ReactNode } from 'react'
import { TopRightMenu } from './TopRightMenu'

interface NavigationProps {
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
}

export default function Navigation({ 
  serviceName, 
  serviceColor = 'blue',
  showServiceSwitcher = true,
  customLinks = []
}: NavigationProps) {
  const colorClasses = {
    blue: 'bg-blue-600 hover:bg-blue-700',
    green: 'bg-green-600 hover:bg-green-700',
    purple: 'bg-purple-600 hover:bg-purple-700',
    red: 'bg-red-600 hover:bg-red-700'
  }

  return (
    <nav className="bg-white shadow-sm border-b relative z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            {/* Service Logo/Name */}
            <a href="/" className="flex items-center space-x-2">
              <div className={`w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center text-white font-bold transition-all duration-200`}>
                {serviceName.charAt(0).toUpperCase()}
              </div>
              <span className="text-xl font-semibold text-gray-900">{serviceName}</span>
            </a>

            {/* Navigation Links */}
            <div className="hidden md:ml-8 md:flex md:space-x-8">
              <a href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Home
              </a>
              {/* Custom Links */}
              {customLinks.map((link) => (
                <a 
                  key={link.href}
                  href={link.href}
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          {/* Top Right Menu - Service Switcher + Auth */}
          <div className="flex items-center">
            <TopRightMenu
              serviceName={serviceName}
              serviceColor={serviceColor}
              showServiceSwitcher={showServiceSwitcher}
            />
          </div>
        </div>

        {/* Mobile Menu - Simple version for now */}
        <div className="md:hidden border-t border-gray-200 py-2">
          <div className="flex justify-between items-center">
            <TopRightMenu
              serviceName={serviceName}
              serviceColor={serviceColor}
              showServiceSwitcher={showServiceSwitcher}
            />
          </div>
        </div>
      </div>
    </nav>
  )
}
EOF

echo ""
echo "5️⃣ Rebuilding shared UI package..."

cd packages/ui
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Shared UI package rebuilt successfully!"
else
    echo "❌ Build failed, checking errors..."
    npm run build
    exit 1
fi

cd ../..

echo ""
echo "6️⃣ Clearing caches and updating services..."

# Clear caches and reinstall
for service in "auth-service" "user-service" "content-service"; do
    echo "Updating $service..."
    rm -rf "apps/$service/.next"
    
    cd "apps/$service"
    npm uninstall @tt-ms-stack/ui 2>/dev/null
    npm install ../../packages/ui
    cd ../..
done

echo ""
echo "🎉 Fixed dropdown positioning and profile avatar!"
echo ""
echo "✅ What was fixed:"
echo "  - 🔧 Fixed z-index issues with dropdowns (now z-[9999])"
echo "  - 📍 Proper dropdown positioning with 'top-full' instead of 'mt-2'"
echo "  - 🖼️ Fixed profile avatar styling with proper borders and shadows"
echo "  - 📱 Added shadow-xl for better dropdown visibility"
echo "  - 🎯 Navigation has proper z-index stacking context"
echo ""
echo "🔍 Technical fixes:"
echo "  - Changed dropdown positioning from relative to absolute with top-full"
echo "  - Added z-[9999] to ensure dropdowns appear above all content"
echo "  - Added proper borders and shadows to profile avatars"
echo "  - Enhanced dropdown shadows for better visibility"
echo ""
echo "🚀 Restart your services to see the fixes:"
echo "  npm run dev"
echo ""
echo "💡 The dropdowns should now appear correctly positioned below the buttons"
echo "and the profile avatars should look polished and professional!"