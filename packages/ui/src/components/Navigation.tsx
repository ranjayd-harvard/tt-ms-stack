'use client'

import { ReactNode } from 'react'
import { TopRightMenu } from './TopRightMenu'

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
    <nav className="bg-white shadow-sm border-b relative z-50">
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

          {/* Top Right Menu - Service Switcher + Auth */}
          <div className="flex items-center">
            <TopRightMenu
              serviceName={serviceName}
              serviceColor={serviceColor}
              showServiceSwitcher={showServiceSwitcher}
            />
          </div>
        </div>

        {/* Mobile Menu - Simple version for now */}
        <div className="md:hidden border-t border-gray-200 py-2">
          <div className="flex justify-between items-center">
            <TopRightMenu
              serviceName={serviceName}
              serviceColor={serviceColor}
              showServiceSwitcher={showServiceSwitcher}
            />
          </div>
        </div>
      </div>
    </nav>
  )
}
