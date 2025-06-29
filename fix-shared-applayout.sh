i#!/bin/bash

echo "🔧 Fixing shared AppLayout component to work across all services..."

echo ""
echo "1️⃣ First, let's copy the working Auth Service navigation to the shared UI package..."

# Extract the working navigation from Auth Service and put it in the shared package
# But first, let's fix the shared UI package structure

echo "Updating shared UI package with working components..."

# Copy your working globals.css to the UI package as well
cat > "packages/ui/src/styles/globals.css" << 'EOF'
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

mkdir -p packages/ui/src/styles

echo ""
echo "2️⃣ Creating a working Navigation component in shared UI..."

cat > "packages/ui/src/components/Navigation.tsx" << 'EOF'
'use client'

import { ReactNode } from 'react'

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

  const services = [
    { name: 'Auth Service', url: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000' },
    { name: 'User Service', url: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001' },
    { name: 'Content Service', url: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002' }
  ]

  return (
    <nav className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            {/* Service Logo/Name */}
            <a href="/" className="flex items-center space-x-2">
              <div className={`w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center text-white font-bold`}>
                {serviceName.charAt(0).toUpperCase()}
              </div>
              <span className="text-xl font-semibold text-gray-900">{serviceName}</span>
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
              className={`${colorClasses[serviceColor]} text-white px-4 py-2 rounded-md text-sm font-medium transition-colors`}
            >
              Sign Up
            </a>
          </div>
        </div>
      </div>
    </nav>
  )
}
EOF

echo ""
echo "3️⃣ Creating a working Footer component in shared UI..."

cat > "packages/ui/src/components/Footer.tsx" << 'EOF'
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
        <div className="mt-4 pt-4 border-t border-gray-100">
          <div className="text-xs text-gray-500 text-center md:text-left">
            Microservices Architecture • Built with Next.js & TypeScript
          </div>
        </div>
      </div>
    </footer>
  )
}
EOF

echo ""
echo "4️⃣ Creating the AppLayout component that combines everything..."

cat > "packages/ui/src/layouts/AppLayout.tsx" << 'EOF'
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

echo ""
echo "5️⃣ Fixing the shared UI package exports..."

cat > "packages/ui/src/index.ts" << 'EOF'
// Main exports for shared UI package
export { default as Navigation } from './components/Navigation'
export { default as AppLayout } from './layouts/AppLayout'
export { default as Footer } from './components/Footer'

// Export types
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

echo ""
echo "6️⃣ Rebuilding the shared UI package..."

cd packages/ui
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Shared UI package built successfully!"
else
    echo "❌ Build failed, checking errors..."
    npm run build
    exit 1
fi

cd ../..

echo ""
echo "7️⃣ Updating User Service to use AppLayout..."

cat > "apps/user-service/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

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
          <AppLayout
            serviceName="User Service"
            serviceColor="green"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/users', label: 'Users' },
              { href: '/roles', label: 'Roles' },
              { href: '/permissions', label: 'Permissions' }
            ]}
            showFooter={true}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo ""
echo "8️⃣ Updating Content Service to use AppLayout..."

cat > "apps/content-service/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

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
            showFooter={true}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo ""
echo "9️⃣ Updating Auth Service to also use AppLayout for consistency..."

cat > "apps/auth-service/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/Providers'
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Auth Service - TT-MS-Stack',
  description: 'Authentication microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          <AppLayout
            serviceName="Auth Service"
            serviceColor="blue"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/dashboard', label: 'Dashboard' },
              { href: '/admin', label: 'Admin Panel' }
            ]}
            showFooter={true}
          >
            {children}
          </AppLayout>
        </Providers>
      </body>
    </html>
  )
}
EOF

echo ""
echo "🔟 Clearing caches and reinstalling dependencies..."

# Clear caches
for service in "auth-service" "user-service" "content-service"; do
    echo "Clearing cache for $service..."
    rm -rf "apps/$service/.next"
done

# Reinstall UI package in services
for service in "user-service" "content-service"; do
    echo "Updating UI package in $service..."
    cd "apps/$service"
    npm uninstall @tt-ms-stack/ui 2>/dev/null
    npm install ../../packages/ui
    cd ../..
done

# Also update Auth Service
cd "apps/auth-service"
npm uninstall @tt-ms-stack/ui 2>/dev/null
npm install ../../packages/ui
cd ..

echo ""
echo "🎉 AppLayout component is now working across all services!"
echo ""
echo "✅ What was accomplished:"
echo "  - Fixed shared UI package with working components"
echo "  - Created AppLayout that combines Navigation + Footer"
echo "  - All services now use the same AppLayout component"
echo "  - Service-specific customization (colors, links) supported"
echo "  - Eliminated code duplication across services"
echo ""
echo "🚀 Restart your services:"
echo "  npm run dev"
echo ""
echo "💡 Now all services use the exact same layout code!"
echo "Any changes to the AppLayout will automatically apply everywhere."