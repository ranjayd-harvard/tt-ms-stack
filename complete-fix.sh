#!/bin/bash

echo "🔧 Complete fix for UI migration errors..."
echo ""

# Save this script and run it from your tt-ms-stack root directory

# Step 1: Clean up any broken files
echo "🧹 Cleaning up..."
rm -rf packages/ui/dist
rm -rf packages/ui/node_modules

# Step 2: Create the correct Navigation component
echo "📝 Creating fixed Navigation component..."
cat > packages/ui/src/components/Navigation.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'
import { useSession, signOut } from 'next-auth/react'
import Link from 'next/link'
import { ProfileAvatar } from './ProfileAvatar'
import { AccountNavDropDown } from './AccountNavDropDown'

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
  const { data: session, status } = useSession()
  const [showMobileMenu, setShowMobileMenu] = useState(false)
  const [showUserMenu, setShowUserMenu] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  // Close menu when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setShowUserMenu(false)
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

  const services = [
    { name: 'Auth Service', url: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000' },
    { name: 'User Service', url: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001' },
    { name: 'Content Service', url: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002' }
  ]

  const getAccountStatus = () => {
    if (!session) return { text: '', color: '' }
    
    // Simple auth method count - can be enhanced based on your user data structure
    const authMethodsCount = 1
    return {
      text: `${authMethodsCount} auth method${authMethodsCount !== 1 ? 's' : ''}`,
      color: 'text-green-600'
    }
  }

  return (
    <nav className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            {/* Service Logo/Name */}
            <Link href="/" className="flex items-center space-x-2">
              <div className={`w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center text-white font-bold`}>
                {serviceName.charAt(0).toUpperCase()}
              </div>
              <span className="text-xl font-semibold text-gray-900">{serviceName}</span>
            </Link>

            {/* Navigation Links */}
            <div className="hidden md:ml-8 md:flex md:space-x-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Home
              </Link>
              <Link href="/about" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                About
              </Link>
              {session && (
                <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                  Dashboard
                </Link>
              )}
              {/* Custom Links */}
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

          {/* Service Switcher */}
          {showServiceSwitcher && (
            <div className="hidden md:flex items-center space-x-4">
              <div className="text-sm text-gray-500">Switch Service:</div>
              {services.map((service) => (
                <a
                  key={service.name}
                  href={service.url}
                  className={`text-xs px-2 py-1 rounded ${
                    service.name === serviceName 
                      ? 'bg-gray-200 text-gray-900' 
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  {service.name}
                </a>
              ))}
            </div>
          )}

          {/* Right side - Auth */}
          <div className="flex items-center space-x-4">
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
                    showBadge={false}
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
                  <div className="absolute right-0 mt-2 w-72 rounded-xl shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-50">
                    <div className="py-2">
                      {/* User Info Header */}
                      <div className="px-4 py-3 border-b border-gray-100">
                        <div className="flex items-center space-x-3">
                          <ProfileAvatar
                            src={session.user?.image}
                            name={session.user?.name}
                            email={session.user?.email}
                            size="md"
                            showBadge={false}
                          />
                          <div className="flex-1">
                            <div className="font-medium text-gray-900">{session.user?.name}</div>
                            <div className="text-sm text-gray-500 truncate">{session.user?.email}</div>
                            <div className="text-xs text-blue-600 mt-1 flex items-center space-x-1">
                              <span>🔗</span>
                              <span>{getAccountStatus().text}</span>
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
                        <div className="px-4 py-2">
                          <AccountNavDropDown />
                        </div>
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
                  href="/auth/sign-in"
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Sign In
                </Link>
                <Link
                  href="/auth/sign-up"
                  className={`${colorClasses[serviceColor]} text-white px-4 py-2 rounded-md text-sm font-medium transition-colors`}
                >
                  Sign Up
                </Link>
              </div>
            )}

            {/* Mobile menu button */}
            <button
              onClick={() => setShowMobileMenu(!showMobileMenu)}
              className="md:hidden inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100"
            >
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
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
                  <Link href="/account/security" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                    Security
                  </Link>
                  <button
                    onClick={() => signOut({ callbackUrl: '/' })}
                    className="text-red-600 hover:text-red-700 block px-3 py-2 text-base font-medium w-full text-left"
                  >
                    Sign Out
                  </button>
                </>
              )}
              {!session && (
                <>
                  <Link href="/auth/sign-in" className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium">
                    Sign In
                  </Link>
                  <Link href="/auth/sign-up" className={`${colorClasses[serviceColor]} text-white block px-3 py-2 text-base font-medium rounded-md`}>
                    Sign Up
                  </Link>
                </>
              )}
              {/* Custom mobile links */}
              {customLinks.map((link) => (
                <Link 
                  key={link.href}
                  href={link.href}
                  className="text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium"
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </nav>
  )
}
EOF

# Step 3: Create the remaining components
echo "📝 Creating remaining components..."

# ProfileAvatar component
cat > packages/ui/src/components/ProfileAvatar.tsx << 'EOF'
interface ProfileAvatarProps {
  src?: string | null
  name?: string | null
  email?: string | null
  size?: 'sm' | 'md' | 'lg'
  showBadge?: boolean
}

export function ProfileAvatar({ 
  src, 
  name, 
  email, 
  size = 'md', 
  showBadge = false
}: ProfileAvatarProps) {
  const sizeClasses = {
    sm: 'h-8 w-8 text-sm',
    md: 'h-10 w-10 text-base',
    lg: 'h-12 w-12 text-lg'
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
      {showBadge && (
        <div className="absolute -bottom-1 -right-1 h-3 w-3 bg-green-400 border-2 border-white rounded-full"></div>
      )}
    </div>
  )
}
EOF

# AccountNavDropDown component
cat > packages/ui/src/components/AccountNavDropDown.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'
import Link from 'next/link'

interface NavItem {
  id: string
  label: string
  description: string
  href: string
  icon: string
}

export function AccountNavDropDown() {
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

  const navigationItems: NavItem[] = [
    {
      id: 'export',
      label: 'Export Data',
      description: 'Download your account data',
      href: '/account/export',
      icon: '📤'
    },
    {
      id: 'help',
      label: 'Help & Support',
      description: 'Get help with your account',
      href: '/help',
      icon: '❓'
    }
  ]

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors w-full"
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        <span>⚙️</span>
        <span>Quick Actions</span>
        <svg
          className={`w-4 h-4 transition-transform duration-200 ml-auto ${isOpen ? 'rotate-180' : ''}`}
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 z-50 py-2">
          <div className="px-3 py-2">
            <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
              Quick Actions
            </h3>
            <div className="space-y-1">
              {navigationItems.map((item) => (
                <Link
                  key={item.id}
                  href={item.href}
                  className="flex items-start space-x-3 p-2 rounded-lg transition-colors hover:bg-gray-50"
                  onClick={() => setIsOpen(false)}
                >
                  <span className="text-lg">{item.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-medium text-gray-900">
                      {item.label}
                    </div>
                    <div className="text-xs text-gray-500 mt-1">
                      {item.description}
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

# AppLayout component
cat > packages/ui/src/layouts/AppLayout.tsx << 'EOF'
'use client'

import { ReactNode } from 'react'
import Navigation from '../components/Navigation'
import Footer from '../components/Footer'

export interface AppLayoutProps {
  children: ReactNode
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customNavLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
  showFooter?: boolean
}

export default function AppLayout({
  children,
  serviceName,
  serviceColor = 'blue',
  showServiceSwitcher = true,
  customNavLinks = [],
  showFooter = true
}: AppLayoutProps) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Navigation 
        serviceName={serviceName}
        serviceColor={serviceColor}
        showServiceSwitcher={showServiceSwitcher}
        customLinks={customNavLinks}
      />
      
      <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 w-full">
        {children}
      </main>
      
      {showFooter && <Footer serviceName={serviceName} />}
    </div>
  )
}
EOF

# Footer component
cat > packages/ui/src/components/Footer.tsx << 'EOF'
import React from 'react'

interface FooterProps {
  serviceName: string
}

export default function Footer({ serviceName }: FooterProps) {
  const currentYear = new Date().getFullYear()
  
  return (
    <footer className="bg-white border-t border-gray-200 mt-auto">
      <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="text-gray-600 text-sm">
            © {currentYear} {serviceName}. Part of TT-MS-Stack.
          </div>
          <div className="flex space-x-6 mt-4 md:mt-0">
            <a href="/privacy" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Privacy Policy
            </a>
            <a href="/terms" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Terms of Service
            </a>
            <a href="/support" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Support
            </a>
          </div>
        </div>
      </div>
    </footer>
  )
}
EOF

# Fix the main index file
cat > packages/ui/src/index.ts << 'EOF'
// Main exports for shared UI package
export { default as Navigation } from './components/Navigation'
export { default as AppLayout } from './layouts/AppLayout'
export { default as Footer } from './components/Footer'
export { ProfileAvatar } from './components/ProfileAvatar'
export { AccountNavDropDown } from './components/AccountNavDropDown'

// Types
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

# Step 4: Install dependencies and build
echo "📦 Installing dependencies and building..."
cd packages/ui
npm install
echo "🔨 Building shared UI package..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Check errors above."
    exit 1
fi

cd ../..

# Step 5: Install in services
echo "📦 Installing shared UI in services..."
npm install

echo ""
echo "🎉 All fixes applied successfully!"
echo ""
echo "✅ What was fixed:"
echo "  - Import path errors in Navigation component"
echo "  - Missing type definitions"
echo "  - Export/import mismatches"
echo "  - Component interface issues"
echo ""
echo "🚀 Next steps:"
echo "1. Update your service layouts to use AppLayout"
echo "2. Test the navigation between services"
echo "3. Customize colors and links as needed"
echo ""
echo "📁 Test the build with:"
echo "  cd packages/ui && npm run build"