i#!/bin/bash

echo "🔍 Debugging User Service dropdown positioning issues..."

echo "1️⃣ First, let's fix the User Service globals.css..."

# Replace the problematic @import "tailwindcss" with standard directives
cat > "apps/user-service/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --background: #ffffff;
  --foreground: #171717;
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

/* Ensure dropdowns appear above everything */
.dropdown-menu {
  position: absolute !important;
  top: 100% !important;
  z-index: 9999 !important;
  margin-top: 0.5rem !important;
}

/* Debug styles to see what's happening */
.debug-dropdown {
  border: 2px solid red !important;
  background: yellow !important;
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

echo "✅ Fixed User Service globals.css with proper Tailwind directives"

echo "2️⃣ Creating a debug version of Navigation with explicit positioning..."

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

  // Explicit dropdown styles to override any conflicts
  const dropdownStyle: React.CSSProperties = {
    position: 'absolute',
    top: '100%',
    right: 0,
    marginTop: '8px',
    zIndex: 9999,
    backgroundColor: 'white',
    borderRadius: '8px',
    boxShadow: '0 10px 25px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
    border: '1px solid #e5e7eb',
    minWidth: '320px'
  }

  const userDropdownStyle: React.CSSProperties = {
    position: 'absolute',
    top: '100%',
    right: 0,
    marginTop: '8px',
    zIndex: 9999,
    backgroundColor: 'white',
    borderRadius: '8px',
    boxShadow: '0 10px 25px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
    border: '1px solid #e5e7eb',
    minWidth: '288px'
  }

  return (
    <nav style={{ backgroundColor: 'white', boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1)', borderBottom: '1px solid #e5e7eb', position: 'relative' }}>
      <div style={{ maxWidth: '1280px', margin: '0 auto', padding: '0 1rem' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', height: '4rem' }}>
          {/* Left side - Logo and Navigation */}
          <div style={{ display: 'flex', alignItems: 'center' }}>
            {/* Service Logo/Name */}
            <a href="/" style={{ display: 'flex', alignItems: 'center', textDecoration: 'none', marginRight: '2rem' }}>
              <div 
                className={currentService?.color} 
                style={{ 
                  width: '32px', 
                  height: '32px', 
                  borderRadius: '8px', 
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'center', 
                  color: 'white', 
                  fontWeight: 'bold',
                  marginRight: '8px'
                }}
              >
                {currentService?.icon}
              </div>
              <span style={{ fontSize: '1.25rem', fontWeight: '600', color: '#111827' }}>{serviceName}</span>
            </a>

            {/* Navigation Links */}
            <div style={{ display: 'flex', gap: '2rem', alignItems: 'center' }}>
              {customLinks.map((link, index) => (
                <a
                  key={index}
                  href={link.href}
                  style={{
                    color: '#374151',
                    textDecoration: 'none',
                    padding: '8px 12px',
                    borderRadius: '6px',
                    fontSize: '14px',
                    fontWeight: '500',
                    transition: 'color 0.2s'
                  }}
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          {/* Right side - Service Switcher and User Menu */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
            {/* Service Switcher */}
            {showServiceSwitcher && (
              <div style={{ position: 'relative' }} ref={serviceMenuRef}>
                <button
                  onClick={() => setShowServiceMenu(!showServiceMenu)}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px',
                    padding: '8px 12px',
                    fontSize: '14px',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    backgroundColor: showServiceMenu ? '#f9fafb' : 'white',
                    cursor: 'pointer',
                    transition: 'background-color 0.2s'
                  }}
                >
                  <div 
                    className={currentService?.color}
                    style={{
                      width: '24px',
                      height: '24px',
                      borderRadius: '4px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      color: 'white',
                      fontSize: '12px',
                      fontWeight: 'bold'
                    }}
                  >
                    {currentService?.icon}
                  </div>
                  <span style={{ fontSize: '14px', fontWeight: '500', color: '#111827' }}>{serviceName}</span>
                  <svg 
                    style={{ 
                      width: '16px', 
                      height: '16px', 
                      color: '#6b7280', 
                      transform: showServiceMenu ? 'rotate(180deg)' : 'rotate(0deg)',
                      transition: 'transform 0.2s'
                    }} 
                    fill="none" 
                    stroke="currentColor" 
                    viewBox="0 0 24 24"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {/* Service Switcher Dropdown - EXPLICIT POSITIONING */}
                {showServiceMenu && (
                  <div style={dropdownStyle}>
                    <div style={{ padding: '16px', borderBottom: '1px solid #f3f4f6' }}>
                      <h3 style={{ fontSize: '14px', fontWeight: '600', color: '#374151', margin: 0 }}>Switch Service</h3>
                      <p style={{ fontSize: '12px', color: '#6b7280', margin: '4px 0 0 0' }}>Navigate between microservices</p>
                    </div>
                    
                    <div style={{ padding: '8px 0' }}>
                      {services.map((service) => {
                        const isCurrent = service.name === serviceName
                        return (
                          <a
                            key={service.name}
                            href={service.url}
                            style={{
                              display: 'flex',
                              alignItems: 'center',
                              gap: '12px',
                              padding: '12px 16px',
                              textDecoration: 'none',
                              backgroundColor: isCurrent ? '#eff6ff' : 'transparent',
                              borderLeft: isCurrent ? '4px solid #3b82f6' : '4px solid transparent',
                              transition: 'background-color 0.2s'
                            }}
                            onClick={() => setShowServiceMenu(false)}
                            onMouseEnter={(e) => {
                              if (!isCurrent) e.currentTarget.style.backgroundColor = '#f9fafb'
                            }}
                            onMouseLeave={(e) => {
                              if (!isCurrent) e.currentTarget.style.backgroundColor = 'transparent'
                            }}
                          >
                            <div 
                              className={service.color}
                              style={{
                                width: '24px',
                                height: '24px',
                                borderRadius: '4px',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                color: 'white',
                                fontSize: '12px',
                                fontWeight: 'bold'
                              }}
                            >
                              {service.icon}
                            </div>
                            <div style={{ flex: 1 }}>
                              <div style={{ fontSize: '14px', fontWeight: '500', color: isCurrent ? '#1d4ed8' : '#111827', margin: 0 }}>
                                {service.name}
                                {isCurrent && <span style={{ marginLeft: '8px', fontSize: '12px', color: '#3b82f6', fontWeight: '500' }}>Current</span>}
                              </div>
                              <div style={{ fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0' }}>{service.description}</div>
                            </div>
                          </a>
                        )
                      })}
                    </div>

                    <div style={{ borderTop: '1px solid #f3f4f6', padding: '8px 16px' }}>
                      <div style={{ fontSize: '12px', color: '#6b7280' }}>
                        Each service runs independently with shared authentication
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* User Menu */}
            <div style={{ position: 'relative' }} ref={userMenuRef}>
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  backgroundColor: 'transparent',
                  border: 'none',
                  cursor: 'pointer',
                  padding: '4px'
                }}
              >
                <div style={{ 
                  width: '32px', 
                  height: '32px', 
                  backgroundColor: '#d1d5db', 
                  borderRadius: '50%', 
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'center' 
                }}>
                  <span style={{ fontSize: '14px', fontWeight: '500', color: '#6b7280' }}>RK</span>
                </div>
                <span style={{ fontSize: '14px', fontWeight: '500', color: '#111827' }}>Ranjay Kumar</span>
                <svg 
                  style={{ 
                    width: '16px', 
                    height: '16px', 
                    color: '#9ca3af',
                    transform: showUserMenu ? 'rotate(180deg)' : 'rotate(0deg)',
                    transition: 'transform 0.2s'
                  }} 
                  fill="none" 
                  stroke="currentColor" 
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {/* User Dropdown */}
              {showUserMenu && (
                <div style={userDropdownStyle}>
                  <div style={{ padding: '12px 16px', borderBottom: '1px solid #f3f4f6' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ 
                        width: '40px', 
                        height: '40px', 
                        backgroundColor: '#d1d5db', 
                        borderRadius: '50%', 
                        display: 'flex', 
                        alignItems: 'center', 
                        justifyContent: 'center' 
                      }}>
                        <span style={{ fontSize: '14px', fontWeight: '500', color: '#6b7280' }}>RK</span>
                      </div>
                      <div>
                        <div style={{ fontSize: '14px', fontWeight: '600', color: '#111827', margin: 0 }}>Ranjay Kumar</div>
                        <div style={{ fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0' }}>ranjay@example.com</div>
                      </div>
                    </div>
                  </div>

                  <div style={{ padding: '8px 0' }}>
                    <a 
                      href="/profile" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '8px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f3f4f6'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px' }}>👤</span>
                      Profile Settings
                    </a>
                    <a 
                      href="/account" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '8px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f3f4f6'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px' }}>⚙️</span>
                      Account Settings
                    </a>
                    <div style={{ height: '1px', backgroundColor: '#f3f4f6', margin: '8px 0' }}></div>
                    <button 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        width: '100%',
                        padding: '8px 16px', 
                        fontSize: '14px', 
                        color: '#dc2626', 
                        backgroundColor: 'transparent',
                        border: 'none',
                        textAlign: 'left',
                        cursor: 'pointer',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#fef2f2'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px' }}>🚪</span>
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

echo "✅ Created explicit inline-styled Navigation component"

echo "3️⃣ Rebuilding shared UI package..."
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

echo "4️⃣ Force updating User Service..."
cd apps/user-service
rm -rf .next
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

echo ""
echo "🎉 Applied explicit positioning fix!"
echo ""
echo "✅ What was fixed:"
echo "  - 🔧 Fixed User Service globals.css (removed @import 'tailwindcss')"
echo "  - 📍 Added explicit inline styles for dropdown positioning"
echo "  - 🎯 Used React.CSSProperties for type safety"
echo "  - 💪 Removed dependency on Tailwind classes for positioning"
echo "  - 🎨 Added explicit zIndex: 9999 and position: 'absolute'"
echo ""
echo "🔍 Key technical changes:"
echo "  - position: 'absolute', top: '100%', right: 0"
echo "  - zIndex: 9999 to ensure dropdown appears above everything"
echo "  - Explicit marginTop: '8px' for spacing"
echo "  - Inline styles bypass any CSS conflicts"
echo ""
echo "🚀 Restart User Service:"
echo "  npm run dev"
echo ""
echo "💡 This approach completely bypasses any CSS class conflicts!"
echo "The dropdowns MUST appear below the buttons now."