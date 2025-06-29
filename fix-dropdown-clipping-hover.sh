#!/bin/bash

echo "🔧 Fixing dropdown clipping and hover issues..."

echo ""
echo "1️⃣ Creating a better service switcher with click-based dropdown..."

cat > "packages/ui/src/components/EnhancedNavigation.tsx" << 'EOF'
'use client'

import { useSession, signOut } from 'next-auth/react'
import Link from 'next/link'
import { useState, useEffect, useRef } from 'react'

interface EnhancedNavigationProps {
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  serviceIcon?: string
  customLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
}

// Simple ProfileAvatar component
function ProfileAvatar({ 
  src, 
  name, 
  email, 
  size = 'sm' 
}: { 
  src?: string | null
  name?: string | null
  email?: string | null
  size?: 'sm' | 'md'
}) {
  const sizeClasses = {
    sm: 'h-8 w-8 text-sm',
    md: 'h-10 w-10 text-base'
  }

  const getInitials = () => {
    if (name) {
      return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
    }
    if (email) {
      return email[0].toUpperCase()
    }
    return '?'
  }

  return (
    <div className="relative">
      {src ? (
        <img
          className={`${sizeClasses[size]} rounded-full object-cover`}
          src={src}
          alt={name || email || 'User avatar'}
        />
      ) : (
        <div className={`${sizeClasses[size]} rounded-full bg-gray-500 flex items-center justify-center text-white font-medium`}>
          {getInitials()}
        </div>
      )}
    </div>
  )
}

export default function EnhancedNavigation({ 
  serviceName = "Auth Service", 
  serviceColor = 'blue',
  serviceIcon = 'A',
  customLinks = []
}: EnhancedNavigationProps) {
  const { data: session, status } = useSession()
  const [showUserMenu, setShowUserMenu] = useState(false)
  const [showServiceMenu, setShowServiceMenu] = useState(false)
  const [showMobileMenu, setShowMobileMenu] = useState(false)
  const [authMethodsCount] = useState(1) // Simplified for now
  const menuRef = useRef<HTMLDivElement>(null)
  const serviceMenuRef = useRef<HTMLDivElement>(null)

  // Close menus when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setShowUserMenu(false)
      }
      if (serviceMenuRef.current && !serviceMenuRef.current.contains(event.target as Node)) {
        setShowServiceMenu(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const getAccountStatus = () => {
    return {
      text: `${authMethodsCount} sign-in method${authMethodsCount !== 1 ? 's' : ''}`,
      color: 'text-green-600'
    }
  }

  const colorClasses = {
    blue: 'bg-blue-600',
    green: 'bg-green-600', 
    purple: 'bg-purple-600',
    red: 'bg-red-600'
  }

  const services = [
    { 
      name: 'Auth Service', 
      url: 'http://localhost:3000', 
      icon: '🔐',
      description: 'Authentication & Authorization'
    },
    { 
      name: 'User Service', 
      url: 'http://localhost:3001', 
      icon: '👥',
      description: 'User Management'
    },
    { 
      name: 'Content Service', 
      url: 'http://localhost:3002', 
      icon: '📝',
      description: 'Content Management'
    }
  ]

  return (
    <nav className="bg-white shadow-sm border-b sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          {/* Logo & Main Nav */}
          <div className="flex items-center space-x-8">
            <Link href="/" className="flex items-center space-x-2">
              <div className={`w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center`}>
                <span className="text-white font-bold text-sm">{serviceIcon}</span>
              </div>
              <span className="text-xl font-semibold text-gray-900">{serviceName}</span>
            </Link>
            
            <div className="hidden md:flex space-x-6">
              <Link 
                href="/" 
                className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                Home
              </Link>
              <Link 
                href="/about" 
                className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                About
              </Link>
              {session && (
                <Link 
                  href="/dashboard" 
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Dashboard
                </Link>
              )}
              {customLinks.map((link) => (
                <Link 
                  key={link.href}
                  href={link.href}
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </Link>
              ))}
            </div>
          </div>

          {/* Right side */}
          <div className="flex items-center space-x-4">
            {/* Service Switcher - Click based with better positioning */}
            <div className="relative" ref={serviceMenuRef}>
              <button
                onClick={() => setShowServiceMenu(!showServiceMenu)}
                className="flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1"
              >
                <span className="text-lg">{services.find(s => s.name === serviceName)?.icon || '⚙️'}</span>
                <span className="font-medium text-gray-700">{serviceName}</span>
                <svg 
                  className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${showServiceMenu ? 'rotate-180' : ''}`}
                  fill="none" 
                  stroke="currentColor" 
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>
              
              {/* Service Switcher Dropdown - Better positioning */}
              {showServiceMenu && (
                <div className="absolute right-0 top-full mt-2 w-80 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
                  <div className="px-4 py-2 border-b border-gray-100">
                    <h3 className="text-sm font-semibold text-gray-700">Switch Service</h3>
                    <p className="text-xs text-gray-500 mt-1">Navigate between microservices</p>
                  </div>
                  
                  <div className="py-2">
                    {services.map((service) => {
                      const isCurrent = service.name === serviceName
                      return (
                        <a
                          key={service.name}
                          href={service.url}
                          className={`flex items-start space-x-3 px-4 py-3 transition-colors ${
                            isCurrent 
                              ? 'bg-blue-50 border-l-4 border-blue-500' 
                              : 'hover:bg-gray-50'
                          }`}
                          onClick={() => setShowServiceMenu(false)}
                        >
                          <span className="text-xl mt-0.5">{service.icon}</span>
                          <div className="flex-1 min-w-0">
                            <div className={`text-sm font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'}`}>
                              {service.name}
                              {isCurrent && (
                                <span className="ml-2 px-2 py-0.5 text-xs bg-white bg-opacity-50 rounded-full">
                                  Current
                                </span>
                              )}
                            </div>
                            <div className={`text-xs ${isCurrent ? 'text-blue-700' : 'text-gray-500'} mt-1`}>
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

                  <div className="border-t border-gray-100 px-4 py-2 mt-2">
                    <div className="text-xs text-gray-500 flex items-center space-x-1">
                      <span>💡</span>
                      <span>Each service runs independently with shared authentication</span>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {status === 'loading' ? (
              <div className="animate-pulse flex space-x-4">
                <div className="rounded-full bg-gray-200 h-8 w-8"></div>
              </div>
            ) : session ? (
              <div className="relative" ref={menuRef}>
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="flex items-center space-x-3 text-gray-700 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 rounded-lg p-2"
                >
                  <ProfileAvatar
                    src={session.user?.image}
                    name={session.user?.name}
                    email={session.user?.email}
                    size="sm"
                  />
                  <div className="hidden md:block text-left">
                    <div className="text-sm font-medium">{session.user?.name}</div>
                    <div className={`text-xs ${getAccountStatus().color}`}>
                      {getAccountStatus().text}
                    </div>
                  </div>
                  <svg className="w-4 h-4 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                  </svg>
                </button>

                {showUserMenu && (
                  <div className="absolute right-0 top-full mt-2 w-72 rounded-xl shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-[9999]">
                    <div className="py-2">
                      {/* User Info Header */}
                      <div className="px-4 py-3 border-b border-gray-100">
                        <div className="flex items-center space-x-3">
                          <ProfileAvatar
                            src={session.user?.image}
                            name={session.user?.name}
                            email={session.user?.email}
                            size="md"
                          />
                          <div className="flex-1">
                            <div className="font-medium text-gray-900">{session.user?.name}</div>
                            <div className="text-sm text-gray-500 truncate">{session.user?.email}</div>
                            <div className="text-xs text-blue-600 mt-1 flex items-center space-x-1">
                              <span>🔗</span>
                              <span>{authMethodsCount} sign-in method{authMethodsCount !== 1 ? 's' : ''}</span>
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Menu Items */}
                      <div className="py-1">
                        <Link 
                          href="/account/profile" 
                          className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                          onClick={() => setShowUserMenu(false)}
                        >
                          <span className="mr-3">👤</span>
                          Account Profile
                        </Link>
                        <Link 
                          href="/account/security" 
                          className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                          onClick={() => setShowUserMenu(false)}
                        >
                          <span className="mr-3">🔐</span>
                          Security Settings
                        </Link>
                        <Link 
                          href="/account/activity" 
                          className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                          onClick={() => setShowUserMenu(false)}
                        >
                          <span className="mr-3">📊</span>
                          Account Activity
                        </Link>

                        <div className="border-t border-gray-100 mt-1 pt-1">
                          <button
                            onClick={() => signOut({ callbackUrl: '/' })}
                            className="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                          >
                            <span className="mr-3">🚪</span>
                            Sign Out
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <div className="flex items-center space-x-4">
                <Link
                  href="http://localhost:3000/auth/sign-in"
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Sign In
                </Link>
                <Link
                  href="http://localhost:3000/auth/sign-up"
                  className={`${colorClasses[serviceColor]} hover:opacity-90 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors`}
                >
                  Sign Up
                </Link>
              </div>
            )}
          </div>
        </div>

        {/* Mobile menu */}
        {showMobileMenu && (
          <div className="md:hidden">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3 border-t border-gray-200">
              <Link href="/" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                Home
              </Link>
              <Link href="/about" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                About
              </Link>
              {session && (
                <>
                  <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                    Dashboard
                  </Link>
                  <Link href="/account/profile" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                    Profile
                  </Link>
                </>
              )}
            </div>
          </div>
        )}
      </div>
    </nav>
  )
}
EOF

echo ""
echo "2️⃣ Rebuilding shared UI package..."

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
echo "3️⃣ Clearing caches and updating services..."

# Clear caches and reinstall
for service in "user-service" "content-service"; do
    echo "Updating $service..."
    rm -rf "apps/$service/.next"
    
    cd "apps/$service"
    npm uninstall @tt-ms-stack/ui 2>/dev/null
    npm install ../../packages/ui
    cd ../..
done

echo ""
echo "🎉 Fixed dropdown clipping and hover issues!"
echo ""
echo "✅ What was fixed:"
echo "  - Changed from hover-based to click-based service switcher"
echo "  - Fixed dropdown positioning with proper z-index (z-[9999])"
echo "  - Added 'top-full mt-2' for proper positioning below button"
echo "  - Fixed dropdown width and made it fully visible"
echo "  - Added click outside to close functionality"
echo "  - Enhanced dropdown with better descriptions and links"
echo ""
echo "🎯 Key improvements:"
echo "  - Service switcher now works like user menu (click to open/close)"
echo "  - Dropdown is properly positioned and visible"
echo "  - Better visual hierarchy with service descriptions"
echo "  - Consistent interaction patterns"
echo ""
echo "🚀 Restart your services:"
echo "  npm run dev"
echo ""
echo "💡 Now click the service switcher button to see the dropdown!"
echo "It should be fully visible and properly positioned."