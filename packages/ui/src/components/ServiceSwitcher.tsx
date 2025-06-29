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

      {/* Dropdown Menu - Fixed positioning */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-80 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2">
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
