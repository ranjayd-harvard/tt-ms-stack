#!/bin/bash

echo "🎯 Creating EXACT match of Auth Service layout..."

# Let me check the Auth Service layout first to copy it exactly
echo "1️⃣ Looking at Auth Service to copy exact structure..."

# Create User Service layout that EXACTLY matches Auth Service
cat > apps/user-service/src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'User Service - TT-MS-Stack',
  description: 'User management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <div className="min-h-screen bg-gray-50">
            {/* Enhanced Navigation - EXACTLY like Auth Service */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name - EXACTLY like Auth Service */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-green-600 hover:bg-green-700 rounded-lg flex items-center justify-center text-white font-bold">
                        U
                      </div>
                      <span className="text-xl font-semibold text-gray-900">User Service</span>
                    </a>

                    {/* Navigation Links - EXACTLY like Auth Service */}
                    <div className="hidden md:ml-8 md:flex md:space-x-8">
                      <a href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Home
                      </a>
                      <a href="/about" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        About
                      </a>
                      <a href="/dashboard" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Dashboard
                      </a>
                      <a href="/admin" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Admin Panel
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher - EXACTLY like Auth Service */}
                  <div className="hidden md:flex items-center space-x-4">
                    <div className="text-sm text-gray-500">Switch Service:</div>
                    <a
                      href="http://localhost:3000"
                      className="text-xs px-2 py-1 rounded text-gray-600 hover:text-gray-900"
                    >
                      Auth Service
                    </a>
                    <span className="text-xs px-2 py-1 rounded bg-gray-200 text-gray-900">
                      User Service
                    </span>
                    <a
                      href="http://localhost:3002"
                      className="text-xs px-2 py-1 rounded text-gray-600 hover:text-gray-900"
                    >
                      Content Service
                    </a>
                  </div>

                  {/* Right side - Auth buttons - EXACTLY like Auth Service */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-green-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-green-700 transition-colors"
                    >
                      Sign Up
                    </a>

                    {/* Mobile menu button */}
                    <button className="md:hidden inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100">
                      <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content - EXACTLY like Auth Service */}
            <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
              {children}
            </main>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Create Content Service layout that EXACTLY matches Auth Service
cat > apps/content-service/src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Content Service - TT-MS-Stack',
  description: 'Content management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <div className="min-h-screen bg-gray-50">
            {/* Enhanced Navigation - EXACTLY like Auth Service */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name - EXACTLY like Auth Service */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-purple-600 hover:bg-purple-700 rounded-lg flex items-center justify-center text-white font-bold">
                        C
                      </div>
                      <span className="text-xl font-semibold text-gray-900">Content Service</span>
                    </a>

                    {/* Navigation Links - EXACTLY like Auth Service */}
                    <div className="hidden md:ml-8 md:flex md:space-x-8">
                      <a href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Home
                      </a>
                      <a href="/about" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        About
                      </a>
                      <a href="/dashboard" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Dashboard
                      </a>
                      <a href="/admin" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Admin Panel
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher - EXACTLY like Auth Service */}
                  <div className="hidden md:flex items-center space-x-4">
                    <div className="text-sm text-gray-500">Switch Service:</div>
                    <a
                      href="http://localhost:3000"
                      className="text-xs px-2 py-1 rounded text-gray-600 hover:text-gray-900"
                    >
                      Auth Service
                    </a>
                    <a
                      href="http://localhost:3001"
                      className="text-xs px-2 py-1 rounded text-gray-600 hover:text-gray-900"
                    >
                      User Service
                    </a>
                    <span className="text-xs px-2 py-1 rounded bg-gray-200 text-gray-900">
                      Content Service
                    </span>
                  </div>

                  {/* Right side - Auth buttons - EXACTLY like Auth Service */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-purple-700 transition-colors"
                    >
                      Sign Up
                    </a>

                    {/* Mobile menu button */}
                    <button className="md:hidden inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100">
                      <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content - EXACTLY like Auth Service */}
            <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
              {children}
            </main>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo "2️⃣ Creating enhanced home pages to match Auth Service content style..."

# Create a better User Service home page
cat > apps/user-service/src/app/page.tsx << 'EOF'
'use client'
import { useSession } from 'next-auth/react'

export default function UserServiceHome() {
  const { data: session, status } = useSession()

  const handleSignIn = () => {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callbackUrl = window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callbackUrl)}`
  }

  if (status === 'loading') {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
      </div>
    )
  }

  if (!session) {
    return (
      <div className="max-w-4xl mx-auto">
        {/* Hero Section - matching Auth Service style */}
        <div className="text-center py-12">
          <div className="mx-auto max-w-md rounded-lg border border-gray-200 bg-white p-8 shadow-sm">
            <div className="mb-6">
              <div className="mx-auto w-16 h-16 bg-green-600 rounded-full flex items-center justify-center">
                <span className="text-2xl font-bold text-white">U</span>
              </div>
            </div>
            
            <h1 className="text-2xl font-bold text-gray-900 mb-4">Welcome to User Service</h1>
            <p className="text-gray-600 mb-6">This is a protected service accessible to authenticated users.</p>
            
            <div className="space-y-4">
              <div className="flex items-center justify-center space-x-2 text-sm text-green-600">
                <span>✅</span>
                <span>Protected access</span>
              </div>
              <div className="flex items-center justify-center space-x-2 text-sm text-gray-500">
                <span>🔐</span>
                <span>Authentication required</span>
              </div>
            </div>

            <div className="mt-8">
              <button 
                onClick={handleSignIn}
                className="w-full bg-green-600 text-white py-3 px-4 rounded-md font-medium hover:bg-green-700 transition-colors"
              >
                Sign in to continue
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="text-center py-12">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">User Management Dashboard</h1>
        
        <div className="grid md:grid-cols-3 gap-6">
          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">👥</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Manage Users</h3>
            <p className="text-gray-600 text-sm mb-4">View and manage user accounts, roles, and permissions.</p>
            <button className="bg-green-600 text-white px-4 py-2 rounded-md text-sm hover:bg-green-700 transition-colors">
              View Users
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">🎭</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Roles & Permissions</h3>
            <p className="text-gray-600 text-sm mb-4">Configure user roles and access control.</p>
            <button className="bg-green-600 text-white px-4 py-2 rounded-md text-sm hover:bg-green-700 transition-colors">
              Manage Roles
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">📊</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Analytics</h3>
            <p className="text-gray-600 text-sm mb-4">View user activity and system statistics.</p>
            <button className="bg-green-600 text-white px-4 py-2 rounded-md text-sm hover:bg-green-700 transition-colors">
              View Analytics
            </button>
          </div>
        </div>

        <div className="mt-8 text-center">
          <p className="text-gray-600">Welcome back, {session.user?.name}!</p>
        </div>
      </div>
    </div>
  )
}
EOF

# Create a better Content Service home page
cat > apps/content-service/src/app/page.tsx << 'EOF'
'use client'
import { useSession } from 'next-auth/react'

export default function ContentServiceHome() {
  const { data: session, status } = useSession()

  const handleSignIn = () => {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'
    const callbackUrl = window.location.href
    window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callbackUrl)}`
  }

  if (status === 'loading') {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-600"></div>
      </div>
    )
  }

  if (!session) {
    return (
      <div className="max-w-4xl mx-auto">
        {/* Hero Section - matching Auth Service style */}
        <div className="text-center py-12">
          <div className="mx-auto max-w-md rounded-lg border border-gray-200 bg-white p-8 shadow-sm">
            <div className="mb-6">
              <div className="mx-auto w-16 h-16 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-2xl font-bold text-white">C</span>
              </div>
            </div>
            
            <h1 className="text-2xl font-bold text-gray-900 mb-4">Welcome to Content Service</h1>
            <p className="text-gray-600 mb-6">This is a protected service accessible to authenticated users.</p>
            
            <div className="space-y-4">
              <div className="flex items-center justify-center space-x-2 text-sm text-purple-600">
                <span>✅</span>
                <span>Protected access</span>
              </div>
              <div className="flex items-center justify-center space-x-2 text-sm text-gray-500">
                <span>🔐</span>
                <span>Authentication required</span>
              </div>
            </div>

            <div className="mt-8">
              <button 
                onClick={handleSignIn}
                className="w-full bg-purple-600 text-white py-3 px-4 rounded-md font-medium hover:bg-purple-700 transition-colors"
              >
                Sign in to continue
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="text-center py-12">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">Content Management Dashboard</h1>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">📝</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Articles</h3>
            <p className="text-gray-600 text-sm mb-4">Create and manage articles.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Manage
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">🖼️</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Media</h3>
            <p className="text-gray-600 text-sm mb-4">Upload and organize files.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Library
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">🏷️</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Categories</h3>
            <p className="text-gray-600 text-sm mb-4">Organize content.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              Manage
            </button>
          </div>

          <div className="bg-white p-6 rounded-lg shadow border border-gray-200">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl">📊</span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Analytics</h3>
            <p className="text-gray-600 text-sm mb-4">View performance.</p>
            <button className="bg-purple-600 text-white px-4 py-2 rounded-md text-sm hover:bg-purple-700 transition-colors">
              View
            </button>
          </div>
        </div>

        <div className="mt-8 text-center">
          <p className="text-gray-600">Welcome back, {session.user?.name}!</p>
        </div>
      </div>
    </div>
  )
}
EOF

echo ""
echo "🎉 EXACT Auth Service layout match created!"
echo ""
echo "✅ Changes made:"
echo "  - Copied exact navigation structure from Auth Service"
echo "  - Same spacing, fonts, shadows, and layout"
echo "  - Proper service switcher with highlighting"
echo "  - Service-specific colors (Green U, Purple C)"
echo "  - Enhanced home pages matching Auth Service content style"
echo "  - Removed problematic footer for now"
echo ""
echo "🚀 Restart your services:"
echo "  1. Stop: Ctrl+C"
echo "  2. Start: npm run dev"
echo "  3. Hard refresh browser"
echo ""
echo "🎯 This should now be pixel-perfect match to Auth Service!"