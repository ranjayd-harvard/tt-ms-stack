#!/bin/bash

echo "🎨 Creating layouts that exactly match Auth Service..."

# First, let's copy the exact navigation structure from Auth Service
# but customize it for each service

echo "1️⃣ Creating User Service layout to match Auth Service..."

cat > apps/user-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
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
            {/* Navigation Header - matching Auth Service exactly */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-green-600 hover:bg-green-700 rounded-lg flex items-center justify-center text-white font-bold">
                        U
                      </div>
                      <span className="text-xl font-semibold text-gray-900">User Service</span>
                    </a>

                    {/* Navigation Links */}
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
                      <a href="/users" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Users
                      </a>
                      <a href="/roles" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Roles
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher */}
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

                  {/* Right side - Sign In/Sign Up */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign Up
                    </a>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content */}
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

echo "2️⃣ Creating Content Service layout to match Auth Service..."

cat > apps/content-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
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
            {/* Navigation Header - matching Auth Service exactly */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-purple-600 hover:bg-purple-700 rounded-lg flex items-center justify-center text-white font-bold">
                        C
                      </div>
                      <span className="text-xl font-semibold text-gray-900">Content Service</span>
                    </a>

                    {/* Navigation Links */}
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
                      <a href="/articles" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Articles
                      </a>
                      <a href="/media" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Media
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher */}
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

                  {/* Right side - Sign In/Sign Up */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign Up
                    </a>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content */}
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

echo "3️⃣ Adding the footer to match Auth Service exactly..."

# Update User Service to include footer
cat > apps/user-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
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
          <div className="min-h-screen bg-gray-50 flex flex-col">
            {/* Navigation Header - exactly matching Auth Service */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name - matching Auth Service style */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-green-600 hover:bg-green-700 rounded-lg flex items-center justify-center text-white font-bold">
                        U
                      </div>
                      <span className="text-xl font-semibold text-gray-900">User Service</span>
                    </a>

                    {/* Navigation Links - exactly matching Auth Service */}
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
                      <a href="/users" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Users
                      </a>
                      <a href="/roles" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Roles
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher - exactly matching Auth Service */}
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

                  {/* Right side - Sign In/Sign Up - exactly matching Auth Service */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign Up
                    </a>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content */}
            <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
              {children}
            </main>

            {/* Footer - exactly matching Auth Service */}
            <footer className="bg-white border-t border-gray-200 mt-auto">
              <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                <div className="flex flex-col md:flex-row justify-between items-center">
                  <div className="text-gray-600 text-sm">
                    © 2025 User Service. Part of TT-MS-Stack.
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
                <div className="mt-4 pt-4 border-t border-gray-100">
                  <div className="text-xs text-gray-500 text-center md:text-left">
                    Microservices Architecture • Built with Next.js & TypeScript
                  </div>
                </div>
              </div>
            </footer>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Update Content Service to include footer
cat > apps/content-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
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
          <div className="min-h-screen bg-gray-50 flex flex-col">
            {/* Navigation Header - exactly matching Auth Service */}
            <nav className="bg-white shadow-sm border-b">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16">
                  <div className="flex items-center">
                    {/* Service Logo/Name - matching Auth Service style */}
                    <a href="/" className="flex items-center space-x-2">
                      <div className="w-8 h-8 bg-purple-600 hover:bg-purple-700 rounded-lg flex items-center justify-center text-white font-bold">
                        C
                      </div>
                      <span className="text-xl font-semibold text-gray-900">Content Service</span>
                    </a>

                    {/* Navigation Links - exactly matching Auth Service */}
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
                      <a href="/articles" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Articles
                      </a>
                      <a href="/media" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        Media
                      </a>
                    </div>
                  </div>

                  {/* Service Switcher - exactly matching Auth Service */}
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

                  {/* Right side - Sign In/Sign Up - exactly matching Auth Service */}
                  <div className="flex items-center space-x-4">
                    <a
                      href="http://localhost:3000/auth/sign-in"
                      className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign In
                    </a>
                    <a
                      href="http://localhost:3000/auth/sign-up"
                      className="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors"
                    >
                      Sign Up
                    </a>
                  </div>
                </div>
              </div>
            </nav>

            {/* Main Content */}
            <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
              {children}
            </main>

            {/* Footer - exactly matching Auth Service */}
            <footer className="bg-white border-t border-gray-200 mt-auto">
              <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                <div className="flex flex-col md:flex-row justify-between items-center">
                  <div className="text-gray-600 text-sm">
                    © 2025 Content Service. Part of TT-MS-Stack.
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
                <div className="mt-4 pt-4 border-t border-gray-100">
                  <div className="text-xs text-gray-500 text-center md:text-left">
                    Microservices Architecture • Built with Next.js & TypeScript
                  </div>
                </div>
              </div>
            </footer>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo ""
echo "🎉 Layouts updated to exactly match Auth Service!"
echo ""
echo "✅ What was changed:"
echo "  - Exact same navigation structure as Auth Service"
echo "  - Proper spacing, fonts, and hover effects"
echo "  - Service switcher with correct highlighting"
echo "  - Service-specific colors (Green for User, Purple for Content)"
echo "  - Complete footer matching Auth Service"
echo "  - All Sign In/Sign Up buttons point to Auth Service"
echo ""
echo "🚀 Restart your services to see the changes:"
echo "  1. Stop dev servers (Ctrl+C)"
echo "  2. Run: npm run dev"
echo "  3. Hard refresh browser tabs"
echo ""
echo "🎨 You should now see:"
echo "  - Auth Service: Blue theme with 'A' logo"
echo "  - User Service: Green theme with 'U' logo"  
echo "  - Content Service: Purple theme with 'C' logo"
echo "  - All with identical layout and functionality!"