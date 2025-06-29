#!/bin/bash

echo "🔧 Using your working globals.css and fixing NextAuth issues..."

# Stop services first
echo "⚠️  Stop all services (Ctrl+C) before continuing!"
echo "Press Enter to continue..."
read -r

echo ""
echo "1️⃣ Copying your working globals.css to all services..."

# Copy the working globals.css to all services
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Copying working globals.css to $service..."
    
    # Copy the uploaded globals.css content
    cat > "apps/$service/src/app/globals.css" << 'EOF'
@import "tailwindcss";

:root {
  --background: #ffffff;
  --foreground: #171717;
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --font-sans: var(--font-geist-sans);
  --font-mono: var(--font-geist-mono);
}

@media (prefers-color-scheme: dark) {
  :root {
    --background: #0a0a0a;
    --foreground: #ededed;
  }
}

body {
  background: var(--background);
  color: var(--foreground);
  font-family: Arial, Helvetica, sans-serif;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.animate-shake {
  animation: shake 0.5s ease-in-out;
}
EOF
    
    echo "✅ globals.css updated for $service"
done

echo ""
echo "2️⃣ Fixing NextAuth configuration issues in User and Content services..."

# The error shows that NextAuth is trying to fetch from API routes that don't exist
# Let's configure it to use the Auth Service instead

# Fix User Service NextAuth
echo "Configuring User Service NextAuth..."

# Check if AuthProvider exists, if not create a simple one
if [ ! -f "apps/user-service/src/app/providers/auth-provider.tsx" ]; then
    mkdir -p "apps/user-service/src/app/providers"
    
    cat > "apps/user-service/src/app/providers/auth-provider.tsx" << 'EOF'
'use client'

import { SessionProvider } from 'next-auth/react'
import { ReactNode } from 'react'

interface AuthProviderProps {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  return (
    <SessionProvider 
      basePath="/api/auth"
      refetchInterval={5 * 60}
      refetchOnWindowFocus={true}
    >
      {children}
    </SessionProvider>
  )
}
EOF
fi

# Create NextAuth API route for User Service that proxies to Auth Service
mkdir -p "apps/user-service/src/app/api/auth/[...nextauth]"

cat > "apps/user-service/src/app/api/auth/[...nextauth]/route.ts" << 'EOF'
import { NextRequest, NextResponse } from 'next/server'

// Proxy all auth requests to the main Auth Service
export async function GET(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  
  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}

export async function POST(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  const body = await request.text()
  
  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
      body,
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}
EOF

# Fix Content Service NextAuth (same approach)
echo "Configuring Content Service NextAuth..."

if [ ! -f "apps/content-service/src/app/providers/auth-provider.tsx" ]; then
    mkdir -p "apps/content-service/src/app/providers"
    
    cat > "apps/content-service/src/app/providers/auth-provider.tsx" << 'EOF'
'use client'

import { SessionProvider } from 'next-auth/react'
import { ReactNode } from 'react'

interface AuthProviderProps {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  return (
    <SessionProvider 
      basePath="/api/auth"
      refetchInterval={5 * 60}
      refetchOnWindowFocus={true}
    >
      {children}
    </SessionProvider>
  )
}
EOF
fi

mkdir -p "apps/content-service/src/app/api/auth/[...nextauth]"

cat > "apps/content-service/src/app/api/auth/[...nextauth]/route.ts" << 'EOF'
import { NextRequest, NextResponse } from 'next/server'

// Proxy all auth requests to the main Auth Service
export async function GET(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  
  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}

export async function POST(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  const body = await request.text()
  
  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
      body,
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}
EOF

echo ""
echo "3️⃣ Updating environment variables..."

# Update environment variables for User Service
cat > "apps/user-service/.env.local" << 'EOF'
# User Service Environment Variables
NEXTAUTH_URL=http://localhost:3001
NEXTAUTH_SECRET=your-secret-key-here

# Auth Service URL for proxying
AUTH_SERVICE_URL=http://localhost:3000

# Service URLs for navigation
NEXT_PUBLIC_AUTH_SERVICE_URL=http://localhost:3000
NEXT_PUBLIC_USER_SERVICE_URL=http://localhost:3001
NEXT_PUBLIC_CONTENT_SERVICE_URL=http://localhost:3002
EOF

# Update environment variables for Content Service
cat > "apps/content-service/.env.local" << 'EOF'
# Content Service Environment Variables
NEXTAUTH_URL=http://localhost:3002
NEXTAUTH_SECRET=your-secret-key-here

# Auth Service URL for proxying
AUTH_SERVICE_URL=http://localhost:3000

# Service URLs for navigation
NEXT_PUBLIC_AUTH_SERVICE_URL=http://localhost:3000
NEXT_PUBLIC_USER_SERVICE_URL=http://localhost:3001
NEXT_PUBLIC_CONTENT_SERVICE_URL=http://localhost:3002
EOF

echo ""
echo "4️⃣ Updating layouts to match Auth Service exactly..."

# Create the exact same navigation structure but with service-specific changes
# Copy the Navigation component from Auth Service and adapt it

# User Service Layout
cat > "apps/user-service/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'User Service - TT-MS-Stack',
  description: 'User management microservice',
}

// Import the enhanced navigation from Auth Service and adapt it
function UserServiceNavigation() {
  return (
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
              <a href="/admin" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Admin Panel
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

          {/* Right side - Auth buttons */}
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
          </div>
        </div>
      </div>
    </nav>
  )
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
            <UserServiceNavigation />
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

# Content Service Layout  
cat > "apps/content-service/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Content Service - TT-MS-Stack',
  description: 'Content management microservice',
}

// Import the enhanced navigation from Auth Service and adapt it
function ContentServiceNavigation() {
  return (
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
              <a href="/admin" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Admin Panel
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

          {/* Right side - Auth buttons */}
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
          </div>
        </div>
      </div>
    </nav>
  )
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
            <ContentServiceNavigation />
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

echo ""
echo "5️⃣ Clearing caches..."

for service in "${services[@]}"; do
    echo "Clearing cache for $service..."
    rm -rf "apps/$service/.next"
done

echo ""
echo "🎉 Fixed with your working globals.css and proper NextAuth setup!"
echo ""
echo "✅ What was done:"
echo "  - Used your working globals.css across all services"
echo "  - Fixed NextAuth configuration with proxy to Auth Service"
echo "  - Created identical navigation layouts"
echo "  - Set up proper environment variables"
echo "  - Cleared all caches"
echo ""
echo "🚀 Start your services:"
echo "  npm run dev"
echo ""
echo "💡 All services should now look identical to your Auth Service!"
echo "The NextAuth errors should be gone as requests will proxy to Auth Service."