// packages/ui/src/components/Navigation.tsx
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

// Enhanced ProfileAvatar component with proper image handling
function ProfileAvatar({ 
  src, 
  name, 
  email, 
  size = 'sm',
  avatarType = 'oauth' // Add avatarType support
}: { 
  src?: string | null
  name?: string | null
  email?: string | null
  size?: 'sm' | 'md' | 'lg'
  avatarType?: string
}) {
  const sizeClasses = {
    sm: 'h-8 w-8 text-sm border-10',
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
    return 'U'
  }

  // Enhanced image handling - check if image is available and valid
  const [imageError, setImageError] = useState(false)
  const [imageLoaded, setImageLoaded] = useState(false)

  // Reset error state when src changes
  useEffect(() => {
    setImageError(false)
    setImageLoaded(false)
  }, [src])

  const shouldShowImage = src && !imageError && (avatarType === 'oauth' || avatarType === 'uploaded')

  return (
    <div className="relative">
      {shouldShowImage ? (
        <img
          className={`${sizeClasses[size]} rounded-full object-cover border-2 border-gray-200 shadow-sm`}
          src={src}
          alt={name || email || 'User avatar'}
          onError={() => {
            console.log('Avatar image failed to load:', src)
            setImageError(true)
          }}
          onLoad={() => {
            console.log('Avatar image loaded successfully:', src)
            setImageLoaded(true)
          }}
          style={{ display: imageError ? 'none' : 'block' }}
        />
      ) : (
        <div className={`${sizeClasses[size]} rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white font-medium border-2 border-white shadow-sm`}>
          {getInitials()}
        </div>
      )}
      
      {/* Debug indicator - remove in production */}
      {process.env.NODE_ENV === 'development' && (
        <div className="absolute -bottom-1 -right-1 text-xs">
          {shouldShowImage && !imageError ? '🖼️' : '👤'}
        </div>
      )}
    </div>
  )
}

const services = [
  {
    name: 'Auth Service',
    url: 'http://localhost:3000',
    color: '#2563eb',
    icon: 'A',
    description: 'Authentication & Authorization'
  },
  {
    name: 'User Service', 
    url: 'http://localhost:3001',
    color: '#059669',
    icon: 'U',
    description: 'User Management'
  },
  {
    name: 'Content Service',
    url: 'http://localhost:3002', 
    color: '#7c3aed',
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

  // Enhanced session data - using the same structure as Auth Service
  const session = {
    user: {
      name: 'Ranjay Kumar',
      email: 'ranjay@example.com',
      // Using the same image that works in the dropdown
      image: null, // Temporarily set to null to force initials
      avatarType: 'default', // Can be 'default', 'oauth', or 'uploaded'
      provider: 'credentials'
    }
  }

  const authMethodsCount: number = 3

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

  const getAccountStatus = () => {
    if (authMethodsCount > 1) return { text: `${authMethodsCount} linked methods`, color: '#059669' }
    if (authMethodsCount === 1) return { text: 'Single method', color: '#eab308' }
    return { text: 'No methods', color: '#dc2626' }
  }

  // Dropdown styles
  const dropdownStyle: React.CSSProperties = {
    position: 'absolute',
    top: '100%',
    right: 0,
    marginTop: '8px',
    zIndex: 50,
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
    border: '1px solid #e5e7eb',
    minWidth: '320px'
  }

  const userDropdownStyle: React.CSSProperties = {
    position: 'absolute',
    top: '100%',
    right: 0,
    marginTop: '8px',
    zIndex: 50,
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
    border: '1px solid #e5e7eb',
    minWidth: '288px'
  }

  // Debug logging
  useEffect(() => {
    console.log('Navigation Debug:', {
      sessionImage: session?.user?.image,
      avatarType: session?.user?.avatarType,
      userName: session?.user?.name
    })
  }, [session])

  return (
    <nav style={{ backgroundColor: 'white', boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1)', borderBottom: '1px solid #e5e7eb', position: 'relative' }}>
      <div style={{ maxWidth: '1280px', margin: '0 auto', padding: '0 1rem' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', height: '4rem' }}>
          {/* Left side - Logo and Navigation */}
          <div style={{ display: 'flex', alignItems: 'center' }}>
            {/* Service Logo/Name */}
            <a href="/" style={{ display: 'flex', alignItems: 'center', textDecoration: 'none', marginRight: '2rem' }}>
              <div 
                style={{ 
                  width: '32px', 
                  height: '32px', 
                  backgroundColor: currentService?.color || '#6b7280',
                  borderRadius: '8px', 
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'center', 
                  color: 'white', 
                  fontWeight: 'bold',
                  fontSize: '14px',
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
                  onMouseEnter={(e) => e.currentTarget.style.color = '#2563eb'}
                  onMouseLeave={(e) => e.currentTarget.style.color = '#374151'}
                  {...(link.external && { target: "_blank", rel: "noopener noreferrer" })}
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          {/* Right side - Service Switcher and Enhanced User Menu */}
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
                  onMouseEnter={(e) => {
                    if (!showServiceMenu) e.currentTarget.style.backgroundColor = '#f9fafb'
                  }}
                  onMouseLeave={(e) => {
                    if (!showServiceMenu) e.currentTarget.style.backgroundColor = 'white'
                  }}
                >
                  <div 
                    style={{
                      width: '24px',
                      height: '24px',
                      backgroundColor: currentService?.color || '#6b7280',
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

                {/* Service Switcher Dropdown */}
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
                              style={{
                                width: '24px',
                                height: '24px',
                                backgroundColor: service.color,
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

            {/* Enhanced User Menu with Consistent Avatar */}
            <div style={{ position: 'relative' }} ref={userMenuRef}>
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  backgroundColor: 'transparent',
                  border: 'none',
                  cursor: 'pointer',
                  padding: '8px',
                  borderRadius: '8px',
                  borderColor: 'red',
                  transition: 'background-color 0.2s'
                }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f9fafb'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
              >
                <ProfileAvatar
                  src={session?.user?.image}
                  name={session?.user?.name}
                  email={session?.user?.email}
                  size="sm"
                  avatarType={session?.user?.avatarType}
                />
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start', textAlign: 'left' }}>
                  <div style={{ fontSize: '14px', fontWeight: '500', color: '#111827', margin: 0 }}>
                    {session?.user?.name}
                  </div>
                  <div style={{ fontSize: '11px', color: getAccountStatus().color, margin: 0 }}>
                    {getAccountStatus().text}
                  </div>
                </div>
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

              {/* Enhanced User Dropdown with Consistent Avatar */}
              {showUserMenu && (
                <div style={userDropdownStyle}>
                  <div style={{ padding: '16px', borderBottom: '1px solid #f3f4f6' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <ProfileAvatar
                        src={session?.user?.image}
                        name={session?.user?.name}
                        email={session?.user?.email}
                        size="md"
                        avatarType={session?.user?.avatarType}
                      />
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: '14px', fontWeight: '600', color: '#111827', margin: 0 }}>{session?.user?.name}</div>
                        <div style={{ fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0', wordBreak: 'break-all' }}>{session?.user?.email}</div>
                        <div style={{ fontSize: '11px', color: '#3b82f6', margin: '4px 0 0 0', display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <span>🔗</span>
                          <span>{getAccountStatus().text}</span>
                        </div>
                      </div>
                    </div>
                    
                    {/* Debug info - remove in production */}
                    {process.env.NODE_ENV === 'development' && (
                      <div style={{ fontSize: '10px', color: '#6b7280', marginTop: '8px', padding: '4px', backgroundColor: '#f9fafb', borderRadius: '4px' }}>
                        Debug: avatarType={session?.user?.avatarType}, hasImage={!!session?.user?.image}
                      </div>
                    )}
                  </div>

                  {/* Menu Items */}
                  <div style={{ padding: '8px 0' }}>
                    <a 
                      href="/account/profile" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '12px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f9fafb'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px', fontSize: '16px' }}>👤</span>
                      <div>
                        <div style={{ fontWeight: '500' }}>Account Profile</div>
                        <div style={{ fontSize: '12px', color: '#6b7280' }}>Manage your personal information</div>
                      </div>
                    </a>

                    <a 
                      href="/account/security" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '12px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f9fafb'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px', fontSize: '16px' }}>🔐</span>
                      <div>
                        <div style={{ fontWeight: '500' }}>Security Settings</div>
                        <div style={{ fontSize: '12px', color: '#6b7280' }}>Password, 2FA, and sign-in methods</div>
                      </div>
                    </a>

                    <a 
                      href="/account/activity" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '12px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f9fafb'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px', fontSize: '16px' }}>📊</span>
                      <div>
                        <div style={{ fontWeight: '500' }}>Account Activity</div>
                        <div style={{ fontSize: '12px', color: '#6b7280' }}>View recent account activity</div>
                      </div>
                    </a>

                    <div style={{ height: '1px', backgroundColor: '#f3f4f6', margin: '8px 0' }}></div>

                    <a 
                      href="/help" 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        padding: '12px 16px', 
                        fontSize: '14px', 
                        color: '#374151', 
                        textDecoration: 'none',
                        transition: 'background-color 0.2s'
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f9fafb'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <span style={{ marginRight: '12px', fontSize: '16px' }}>❓</span>
                      <div>
                        <div style={{ fontWeight: '500' }}>Help & Support</div>
                        <div style={{ fontSize: '12px', color: '#6b7280' }}>Get help and contact support</div>
                      </div>
                    </a>

                    <button 
                      style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        width: '100%',
                        padding: '12px 16px', 
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
                      <span style={{ marginRight: '12px', fontSize: '16px' }}>🚪</span>
                      <div>
                        <div style={{ fontWeight: '500' }}>Sign Out</div>
                        <div style={{ fontSize: '12px', color: '#9ca3af' }}>Sign out of your account</div>
                      </div>
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