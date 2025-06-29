#!/bin/bash

echo "🔧 Fixing User and Content Service layouts..."

# Fix User Service Layout
echo "📝 Updating User Service layout..."
cat > apps/user-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

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
          <AppLayout
            serviceName="User Service"
            serviceColor="green"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/users', label: 'Users' },
              { href: '/roles', label: 'Roles' },
              { href: '/permissions', label: 'Permissions' }
            ]}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Fix Content Service Layout
echo "📝 Updating Content Service layout..."
cat > apps/content-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

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
          <AppLayout
            serviceName="Content Service"
            serviceColor="purple"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/articles', label: 'Articles' },
              { href: '/media', label: 'Media' },
              { href: '/categories', label: 'Categories' },
              { href: '/analytics', label: 'Analytics' }
            ]}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Update User Service page content to be cleaner
echo "📝 Updating User Service page content..."
cat > apps/user-service/src/app/page.tsx << 'EOF'
'use client'
import { useSession, signIn, signOut } from 'next-auth/react'

export default function UserServiceHome() {
  const { data: session, status } = useSession()

  const handleSignIn = () => {
    // Redirect to the auth service sign-in page
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
      <div className="text-center py-12">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">User Management Service</h1>
        <p className="text-gray-600 mb-8">Sign in to access user management features.</p>
        <button 
          onClick={handleSignIn}
          className="bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors"
        >
          Sign in with Auth Service
        </button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">User Management</h1>
        <div className="flex items-center gap-4">
          <span className="text-gray-600">Welcome, {session.user?.name}</span>
          <button 
            onClick={() => signOut({ callbackUrl: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL })}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition-colors"
          >
            Sign out
          </button>
        </div>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-green-700">👥 Manage Users</h2>
          <p className="text-gray-600 mb-4">View, create, and manage user accounts</p>
          <button className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition-colors">
            View Users
          </button>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-green-700">🎭 Roles & Permissions</h2>
          <p className="text-gray-600 mb-4">Configure user roles and access levels</p>
          <button className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition-colors">
            Manage Roles
          </button>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-green-700">📊 User Analytics</h2>
          <p className="text-gray-600 mb-4">View user activity and statistics</p>
          <button className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition-colors">
            View Analytics
          </button>
        </div>
      </div>
    </div>
  )
}
EOF

# Update Content Service page content to be cleaner
echo "📝 Updating Content Service page content..."
cat > apps/content-service/src/app/page.tsx << 'EOF'
'use client'
import { useSession, signIn, signOut } from 'next-auth/react'

export default function ContentServiceHome() {
  const { data: session, status } = useSession()

  const handleSignIn = () => {
    // Redirect to the auth service sign-in page
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
      <div className="text-center py-12">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Content Management Service</h1>
        <p className="text-gray-600 mb-8">Sign in to access content management features.</p>
        <button 
          onClick={handleSignIn}
          className="bg-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-purple-700 transition-colors"
        >
          Sign in with Auth Service
        </button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Content Management</h1>
        <div className="flex items-center gap-4">
          <span className="text-gray-600">Welcome, {session.user?.name}</span>
          <button 
            onClick={() => signOut({ callbackUrl: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL })}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition-colors"
          >
            Sign out
          </button>
        </div>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-purple-700">📝 Articles</h2>
          <p className="text-gray-600 mb-4">Create and manage articles</p>
          <button className="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600 transition-colors">
            Manage Articles
          </button>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-purple-700">🖼️ Media</h2>
          <p className="text-gray-600 mb-4">Upload and organize media files</p>
          <button className="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600 transition-colors">
            Media Library
          </button>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-purple-700">🏷️ Categories</h2>
          <p className="text-gray-600 mb-4">Organize content with categories</p>
          <button className="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600 transition-colors">
            Manage Categories
          </button>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4 text-purple-700">📊 Analytics</h2>
          <p className="text-gray-600 mb-4">View content performance</p>
          <button className="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600 transition-colors">
            View Analytics
          </button>
        </div>
      </div>
    </div>
  )
}
EOF

# Make sure the shared UI package is properly installed
echo "📦 Ensuring shared UI package is properly linked..."

# Check if the UI package is in the services' package.json
echo "📝 Checking package dependencies..."

# Add UI dependency to user-service if not present
if ! grep -q "@tt-ms-stack/ui" apps/user-service/package.json 2>/dev/null; then
    echo "Adding UI dependency to user-service..."
    cd apps/user-service
    npm install @tt-ms-stack/ui@1.0.0
    cd ../..
fi

# Add UI dependency to content-service if not present
if ! grep -q "@tt-ms-stack/ui" apps/content-service/package.json 2>/dev/null; then
    echo "Adding UI dependency to content-service..."
    cd apps/content-service
    npm install @tt-ms-stack/ui@1.0.0
    cd ../..
fi

echo ""
echo "🎉 Service layouts fixed!"
echo ""
echo "✅ What was updated:"
echo "  - User Service now uses AppLayout with green theme"
echo "  - Content Service now uses AppLayout with purple theme"
echo "  - Both services have clean, professional page layouts"
echo "  - Service switcher should work between all three services"
echo ""
echo "🚀 Next steps:"
echo "1. Restart your development servers: npm run dev"
echo "2. Test navigation between services"
echo "3. Verify the consistent look and feel"
echo ""
echo "💡 If you still see issues:"
echo "1. Clear browser cache and reload"
echo "2. Check that all services are running properly"
echo "3. Verify the shared UI package built successfully"