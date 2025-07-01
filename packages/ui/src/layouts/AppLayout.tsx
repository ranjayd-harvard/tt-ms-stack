import React from 'react'
import Navigation from '../components/Navigation'
import Footer from '../components/Footer'

export interface AppLayoutProps {
  children: React.ReactNode
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customNavLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
  showFooter?: boolean
  companyName?: string
  companyLogo?: string
  showServiceLinksInFooter?: boolean
}

export default function AppLayout({
  children,
  serviceName,
  serviceColor = 'blue',
  showServiceSwitcher = true,
  customNavLinks = [],
  showFooter = true,
  companyName = "TT-MS-Stack",
  companyLogo,
  showServiceLinksInFooter = true
}: AppLayoutProps) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Navigation */}
      <Navigation 
        serviceName={serviceName}
        serviceColor={serviceColor}
        showServiceSwitcher={showServiceSwitcher}
        customLinks={customNavLinks}
      />
      
      {/* Main Content */}
      <main className="flex-1">
        <div className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          {children}
        </div>
      </main>
      
      {/* Footer */}
      {showFooter && (
        <Footer 
          serviceName={serviceName}
          showServiceLinks={showServiceLinksInFooter}
          companyName={companyName}
          companyLogo={companyLogo}
        />
      )}
    </div>
  )
}
