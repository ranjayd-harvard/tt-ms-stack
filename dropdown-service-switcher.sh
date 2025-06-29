#!/bin/bash

echo "🔽 Creating dropdown Service Switcher component..."

echo ""
echo "1️⃣ Creating ServiceSwitcher dropdown component..."

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

      {/* Dropdown Menu */}
      {isOpen && (
        <div className="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 z-50 py-2">
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
echo "2️⃣ Updating Navigation component to use the dropdown..."

cat > "packages/ui/src/components/Navigation.tsx" << 'EOF'
'use client'

import { ReactNode } from 'react'
import { ServiceSwitcher } from './ServiceSwitcher'

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
    <nav className="bg-white shadow-sm border-b">
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

          <div className="flex items-center space-x-4">
            {/* Service Switcher Dropdown */}
            {showServiceSwitcher && (
              <div className="hidden md:block">
                <ServiceSwitcher 
                  currentService={serviceName}
                  currentColor={serviceColor}
                />
              </div>
            )}

            {/* Right side - Auth buttons */}
            <div className="flex items-center space-x-3">
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

        {/* Mobile Service Switcher */}
        {showServiceSwitcher && (
          <div className="md:hidden border-t border-gray-200 py-2">
            <ServiceSwitcher 
              currentService={serviceName}
              currentColor={serviceColor}
            />
          </div>
        )}
      </div>
    </nav>
  )
}
EOF

echo ""
echo "3️⃣ Updating shared UI exports..."

cat > "packages/ui/src/index.ts" << 'EOF'
// Main exports for shared UI package
export { default as Navigation } from './components/Navigation'
export { default as AppLayout } from './layouts/AppLayout'
export { default as Footer } from './components/Footer'
export { default as ServiceSwitcher } from './components/ServiceSwitcher'

// Export types
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

echo ""
echo "4️⃣ Rebuilding shared UI package..."

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
echo "5️⃣ Updating services to use the new dropdown..."

# Clear caches
for service in "auth-service" "user-service" "content-service"; do
    echo "Clearing cache for $service..."
    rm -rf "apps/$service/.next"
    
    # Reinstall UI package
    cd "apps/$service"
    npm uninstall @tt-ms-stack/ui 2>/dev/null
    npm install ../../packages/ui
    cd ../..
done

echo ""
echo "🎉 Dropdown Service Switcher created!"
echo ""
echo "✅ What was added:"
echo "  - Professional dropdown service switcher"
echo "  - Service icons and descriptions"
echo "  - Current service highlighting"
echo "  - Click outside to close functionality"
echo "  - Mobile responsive design"
echo "  - Hover effects and smooth transitions"
echo "  - Service URLs and status indicators"
echo ""
echo "🎨 Features of the dropdown:"
echo "  - 🔐 Auth Service (Blue)"
echo "  - 👥 User Service (Green)"  
echo "  - 📝 Content Service (Purple)"
echo "  - Shows current service with 'Current' badge"
echo "  - Service descriptions and URLs"
echo "  - Smooth animations and professional styling"
echo ""
echo "🚀 Restart your services to see the new dropdown:"
echo "  npm run dev"
echo ""
echo "💡 The dropdown saves space and looks much more professional!"
echo "Click the service name in the navigation to see the dropdown menu."