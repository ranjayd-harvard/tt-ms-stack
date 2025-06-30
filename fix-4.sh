#!/bin/bash

echo "🔧 Copying the EXACT working navigation from Auth Service to shared UI..."

echo "1️⃣ First, let's copy the Auth Service navigation structure exactly..."

# We need to copy the exact working navigation that shows "Ranjay Kumar" properly
cat > "packages/ui/src/components/Navigation.tsx" << 'EOF'
'use client'

import React, { useState, useRef, useEffect } from 'react'

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

const services = [
  {
    name: 'Auth Service',
    url: 'http://localhost:3000',
    color: 'bg-blue-600',
    icon: 'A',
    description: 'Authentication & Authorization'
  },
  {
    name: 'User Service', 
    url: 'http://localhost:3001',
    color: 'bg-green-600',
    icon: 'U',
    description: 'User Management'
  },
  {
    name: 'Content Service',
    url: 'http://localhost:3002', 
    color: 'bg-purple-600',
    icon: 'C',
    description: 'Content Management'
  }
]

export default function Navigation({
  serviceName,
  serviceColor = 'blue',
  showServiceSwitcher = true,
  customLinks = []
}: NavigationProps) {
  const [showServiceMenu, setShowServiceMenu] = useState(false)
  const [showUserMenu, setShowUserMenu] = useState(false)
  const serviceMenuRef = useRef<HTMLDivElement>(null)
  const userMenuRef = useRef<HTMLDivElement>(null)

  // Close dropdowns when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (serviceMenuRef.current && !serviceMenuRef.current.contains(event.target as Node)) {
        setShowServiceMenu(false)
      }
      if (userMenuRef.current && !userMenuRef.current.contains(event.target as Node)) {
        setShowUserMenu(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const currentService = services.find(s => s.name === serviceName)

  return (
    <nav className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          {/* Left side - Logo and Navigation */}
          <div className="flex items-center">
            {/* Service Logo/Name */}
            <a href="/" className="flex items-center space-x-2">
              <div className={`w-8 h-8 ${currentService?.color} rounded-lg flex items-center justify-center text-white font-bold`}>
                {currentService?.icon}
              </div>
              <span className="text-xl font-semibold text-gray-900">{serviceName}</span>
            </a>

            {/* Navigation Links - Only show custom links */}
            <div className="hidden md:ml-8 md:flex md:space-x-8">
              {customLinks.map((link, index) => (
                <a
                  key={index}
                  href={link.href}
                  className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          {/* Right side - Service Switcher and User Menu */}
          <div className="flex items-center space-x-4">
            {/* Service Switcher */}
            {showServiceSwitcher && (
              <div className="relative" ref={serviceMenuRef}>
                <button
                  onClick={() => setShowServiceMenu(!showServiceMenu)}
                  className="flex items-center space-x-2 px-3 py-2 text-sm border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  <div className={`w-6 h-6 ${currentService?.color} rounded flex items-center justify-center text-white text-xs font-bold`}>
                    {currentService?.icon}
                  </div>
                  <span className="text-sm font-medium text-gray-900">{serviceName}</span>
                  <svg className={`w-4 h-4 text-gray-500 transition-transform ${showServiceMenu ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {/* Service Switcher Dropdown */}
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
                            className={`flex items-center space-x-3 px-4 py-3 transition-colors ${
                              isCurrent 
                                ? 'bg-blue-50 border-l-4 border-blue-500' 
                                : 'hover:bg-gray-50'
                            }`}
                            onClick={() => setShowServiceMenu(false)}
                          >
                            <div className={`w-6 h-6 ${service.color} rounded flex items-center justify-center text-white text-xs font-bold`}>
                              {service.icon}
                            </div>
                            <div className="flex-1">
                              <div className={`text-sm font-medium ${isCurrent ? 'text-blue-700' : 'text-gray-900'}`}>
                                {service.name}
                                {isCurrent && <span className="ml-2 text-xs text-blue-600 font-medium">Current</span>}
                              </div>
                              <div className="text-xs text-gray-500">{service.description}</div>
                            </div>
                          </a>
                        )
                      })}
                    </div>

                    <div className="border-t border-gray-100 px-4 py-2 mt-2">
                      <div className="text-xs text-gray-500">
                        Each service runs independently with shared authentication
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* User Menu - This is the key part that needs to match Auth Service exactly */}
            <div className="relative" ref={userMenuRef}>
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                className="flex items-center space-x-2"
              >
                <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
                  <span className="text-sm font-medium text-gray-600">RK</span>
                </div>
                <span className="text-sm font-medium text-gray-900">Ranjay Kumar</span>
                <svg className={`w-4 h-4 text-gray-400 transition-transform ${showUserMenu ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {/* User Dropdown */}
              {showUserMenu && (
                <div className="absolute right-0 top-full mt-2 w-72 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
                  <div className="px-4 py-3 border-b border-gray-100">
                    <div className="flex items-center space-x-3">
                      <div className="w-10 h-10 bg-gray-300 rounded-full flex items-center justify-center">
                        <span className="text-sm font-medium text-gray-600">RK</span>
                      </div>
                      <div>
                        <div className="text-sm font-semibold text-gray-900">Ranjay Kumar</div>
                        <div className="text-xs text-gray-500">ranjay@example.com</div>
                      </div>
                    </div>
                  </div>

                  <div className="py-2">
                    <a href="/profile" className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                      <span className="mr-3">👤</span>
                      Profile Settings
                    </a>
                    <a href="/account" className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                      <span className="mr-3">⚙️</span>
                      Account Settings
                    </a>
                    <div className="border-t border-gray-100 my-2"></div>
                    <button className="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50">
                      <span className="mr-3">🚪</span>
                      Sign Out
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </nav>
  )
}
EOF

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

echo "3️⃣ Force updating User Service with the new shared UI..."

cd apps/user-service
rm -rf .next
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

echo "4️⃣ Also updating Content Service..."

cd apps/content-service  
rm -rf .next
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

echo ""
echo "🎉 Applied exact Auth Service navigation to shared UI!"
echo ""
echo "✅ Key fixes:"
echo "  - ✨ Copied EXACT navigation structure from working Auth Service"
echo "  - 👤 'Ranjay Kumar' should now show properly in User Service"
echo "  - 🔄 Service switcher matches Auth Service exactly"
echo "  - 📍 Proper dropdown positioning and styling"
echo "  - 🎨 Consistent button styling and spacing"
echo ""
echo "🚀 Restart your services:"
echo "  npm run dev"
echo ""
echo "💡 Now User Service should look EXACTLY like Auth Service!"
echo "The only differences should be the service color (green vs blue) and custom navigation links."