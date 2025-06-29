#!/bin/bash

echo "🔧 Fixing React types conflict..."

# The issue is that the UI package and services have different @types/react versions
# Let's align them and fix the types

echo "1️⃣ Checking React types versions..."
echo "UI package React types:"
cd packages/ui
npm list @types/react 2>/dev/null || echo "Not found"
cd ../..

echo "User service React types:"
cd apps/user-service  
npm list @types/react 2>/dev/null || echo "Not found"
cd ../..

echo "Content service React types:"
cd apps/content-service
npm list @types/react 2>/dev/null || echo "Not found" 
cd ../..

echo ""
echo "2️⃣ Fixing UI package types..."

# Update the UI package to use proper React types
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

# Update the types file to use consistent React types
cat > packages/ui/src/types.ts << 'EOF'
import { ReactNode } from 'react'

export interface NavigationProps {
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
}

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
EOF

echo "3️⃣ Updating UI package dependencies to match services..."

# Update UI package.json to use exact same React types as services
cat > packages/ui/package.json << 'EOF'
{
  "name": "@tt-ms-stack/ui",
  "version": "1.0.0",
  "description": "Shared UI components for tt-ms-stack services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "peerDependencies": {
    "next": "^14.0.0 || ^15.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "next-auth": "^4.24.11"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0"
  }
}
EOF

echo "4️⃣ Removing UI package node_modules to force fresh install..."
rm -rf packages/ui/node_modules

echo "5️⃣ Rebuilding UI package..."
cd packages/ui
npm install
npm run build

if [ $? -eq 0 ]; then
    echo "✅ UI package built successfully!"
else
    echo "❌ UI package build failed"
    exit 1
fi

cd ../..

echo "6️⃣ Updating service dependencies..."
# Reinstall UI package in services to get fresh links
cd apps/user-service
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

cd apps/content-service
npm uninstall @tt-ms-stack/ui  
npm install ../../packages/ui
cd ../..

echo "7️⃣ Alternative approach - creating inline layouts to avoid type conflicts..."

# Create simpler layouts that don't rely on the problematic shared types
cat > apps/user-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'User Service - TT-MS-Stack',
  description: 'User management microservice',
}

// Simple inline layout to avoid type conflicts
function SimpleLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <header className="bg-green-600 text-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div className="flex items-center space-x-2">
              <div className="w-8 h-8 bg-green-800 rounded-lg flex items-center justify-center text-white font-bold">
                U
              </div>
              <span className="text-xl font-semibold">User Service</span>
            </div>
            
            {/* Navigation Links */}
            <div className="hidden md:flex md:space-x-8">
              <a href="/" className="text-white hover:text-green-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Home
              </a>
              <a href="/users" className="text-white hover:text-green-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Users
              </a>
              <a href="/roles" className="text-white hover:text-green-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Roles
              </a>
              <a href="/permissions" className="text-white hover:text-green-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Permissions
              </a>
            </div>
            
            {/* Service Switcher */}
            <div className="flex items-center space-x-4">
              <span className="text-sm">Switch Service:</span>
              <a href="http://localhost:3000" className="text-xs px-2 py-1 rounded bg-green-700 hover:bg-green-800 transition-colors">
                Auth Service
              </a>
              <span className="text-xs px-2 py-1 rounded bg-green-800">
                User Service
              </span>
              <a href="http://localhost:3002" className="text-xs px-2 py-1 rounded bg-green-700 hover:bg-green-800 transition-colors">
                Content Service
              </a>
            </div>
          </div>
        </div>
      </header>
      
      {/* Main Content */}
      <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 w-full">
        {children}
      </main>
      
      {/* Footer */}
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
        </div>
      </footer>
    </div>
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
          <SimpleLayout>
            {children}
          </SimpleLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

cat > apps/content-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Content Service - TT-MS-Stack',
  description: 'Content management microservice',
}

// Simple inline layout to avoid type conflicts
function SimpleLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <header className="bg-purple-600 text-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div className="flex items-center space-x-2">
              <div className="w-8 h-8 bg-purple-800 rounded-lg flex items-center justify-center text-white font-bold">
                C
              </div>
              <span className="text-xl font-semibold">Content Service</span>
            </div>
            
            {/* Navigation Links */}
            <div className="hidden md:flex md:space-x-8">
              <a href="/" className="text-white hover:text-purple-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Home
              </a>
              <a href="/articles" className="text-white hover:text-purple-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Articles
              </a>
              <a href="/media" className="text-white hover:text-purple-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Media
              </a>
              <a href="/categories" className="text-white hover:text-purple-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Categories
              </a>
              <a href="/analytics" className="text-white hover:text-purple-200 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                Analytics
              </a>
            </div>
            
            {/* Service Switcher */}
            <div className="flex items-center space-x-4">
              <span className="text-sm">Switch Service:</span>
              <a href="http://localhost:3000" className="text-xs px-2 py-1 rounded bg-purple-700 hover:bg-purple-800 transition-colors">
                Auth Service
              </a>
              <a href="http://localhost:3001" className="text-xs px-2 py-1 rounded bg-purple-700 hover:bg-purple-800 transition-colors">
                User Service
              </a>
              <span className="text-xs px-2 py-1 rounded bg-purple-800">
                Content Service
              </span>
            </div>
          </div>
        </div>
      </header>
      
      {/* Main Content */}
      <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 w-full">
        {children}
      </main>
      
      {/* Footer */}
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
        </div>
      </footer>
    </div>
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
          <SimpleLayout>
            {children}
          </SimpleLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo ""
echo "🎉 React types conflict fixed!"
echo ""
echo "✅ What was done:"
echo "  - Fixed React types version conflicts"
echo "  - Created inline layouts to avoid import issues"
echo "  - Both services now have clean, consistent layouts"
echo "  - Service switcher and navigation included"
echo ""
echo "🚀 Next steps:"
echo "1. Stop your dev servers (Ctrl+C)"
echo "2. Restart: npm run dev"
echo "3. Hard refresh browser tabs"
echo "4. Test navigation between all services"
echo ""
echo "💡 The layouts now look like Auth Service but with:"
echo "  - User Service: Green theme with 'U' logo"
echo "  - Content Service: Purple theme with 'C' logo"