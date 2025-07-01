#!/bin/bash

echo "🎨 Implementing enhanced footer from shadcn/blocks style..."

echo ""
echo "1️⃣ Installing required Lucide React icons..."

# Install lucide-react icons if not already installed
cd packages/ui
if ! grep -q "lucide-react" package.json; then
    npm install lucide-react
    echo "✅ Lucide React icons installed"
else
    echo "✅ Lucide React icons already installed"
fi
cd ../..

echo ""
echo "2️⃣ Creating enhanced Footer component..."

# Create the enhanced Footer component
cat > packages/ui/src/components/Footer.tsx << 'EOF'
import React from 'react'
import Link from 'next/link'
import { Github, Twitter, Linkedin, Mail, Heart, ExternalLink } from 'lucide-react'

interface FooterProps {
  serviceName: string
  showServiceLinks?: boolean
  companyName?: string
  companyLogo?: string
}

export default function Footer({ 
  serviceName, 
  showServiceLinks = true,
  companyName = "TT-MS-Stack",
  companyLogo 
}: FooterProps) {
  const currentYear = new Date().getFullYear()
  
  const services = [
    { name: 'Auth Service', href: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000', icon: '🔐' },
    { name: 'User Service', href: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001', icon: '👥' },
    { name: 'Content Service', href: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002', icon: '📝' }
  ]

  const productLinks = [
    { name: 'Features', href: '/features' },
    { name: 'Pricing', href: '/pricing' },
    { name: 'Documentation', href: '/docs' },
    { name: 'API Reference', href: '/api-docs' }
  ]

  const companyLinks = [
    { name: 'About Us', href: '/about' },
    { name: 'Careers', href: '/careers' },
    { name: 'Contact', href: '/contact' },
    { name: 'Blog', href: '/blog' }
  ]

  const legalLinks = [
    { name: 'Privacy Policy', href: '/privacy' },
    { name: 'Terms of Service', href: '/terms' },
    { name: 'Cookie Policy', href: '/cookies' },
    { name: 'Security', href: '/security' }
  ]

  const socialLinks = [
    { name: 'GitHub', href: 'https://github.com', icon: Github },
    { name: 'Twitter', href: 'https://twitter.com', icon: Twitter },
    { name: 'LinkedIn', href: 'https://linkedin.com', icon: Linkedin },
    { name: 'Email', href: 'mailto:contact@company.com', icon: Mail }
  ]

  return (
    <footer className="bg-white border-t border-gray-200 mt-auto">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Main Footer Content */}
        <div className="py-12 lg:py-16">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 lg:gap-12">
            
            {/* Company Section */}
            <div className="lg:col-span-2">
              <div className="flex items-center space-x-2 mb-4">
                {companyLogo ? (
                  <img src={companyLogo} alt={companyName} className="h-8 w-8" />
                ) : (
                  <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                    <span className="text-white font-bold text-sm">T</span>
                  </div>
                )}
                <span className="text-xl font-bold text-gray-900">{companyName}</span>
              </div>
              <p className="text-gray-600 text-sm leading-relaxed mb-6 max-w-md">
                A modern microservices architecture built with Next.js, NextAuth, and TypeScript. 
                Scalable, secure, and developer-friendly solutions for modern web applications.
              </p>
              
              {/* Social Links */}
              <div className="flex space-x-4">
                {socialLinks.map((social) => {
                  const IconComponent = social.icon
                  return (
                    <Link
                      key={social.name}
                      href={social.href}
                      className="text-gray-400 hover:text-gray-600 transition-colors duration-200"
                      aria-label={social.name}
                      target={social.href.startsWith('http') ? '_blank' : undefined}
                      rel={social.href.startsWith('http') ? 'noopener noreferrer' : undefined}
                    >
                      <IconComponent className="h-5 w-5" />
                    </Link>
                  )
                })}
              </div>
            </div>

            {/* Services Section */}
            {showServiceLinks && (
              <div>
                <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4">
                  Services
                </h3>
                <ul className="space-y-3">
                  {services.map((service) => (
                    <li key={service.name}>
                      <Link
                        href={service.href}
                        className="text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200 flex items-center space-x-2 group"
                        target={service.href.startsWith('http') ? '_blank' : undefined}
                        rel={service.href.startsWith('http') ? 'noopener noreferrer' : undefined}
                      >
                        <span>{service.icon}</span>
                        <span>{service.name}</span>
                        {service.href.startsWith('http') && (
                          <ExternalLink className="h-3 w-3 opacity-0 group-hover:opacity-100 transition-opacity duration-200" />
                        )}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {/* Product Section */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4">
                Product
              </h3>
              <ul className="space-y-3">
                {productLinks.map((link) => (
                  <li key={link.name}>
                    <Link
                      href={link.href}
                      className="text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200"
                    >
                      {link.name}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>

            {/* Company Section */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4">
                Company
              </h3>
              <ul className="space-y-3">
                {companyLinks.map((link) => (
                  <li key={link.name}>
                    <Link
                      href={link.href}
                      className="text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200"
                    >
                      {link.name}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>

        {/* Divider */}
        <div className="border-t border-gray-200"></div>

        {/* Bottom Section */}
        <div className="py-6">
          <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
            {/* Copyright */}
            <div className="flex items-center space-x-4 text-sm text-gray-600">
              <span>© {currentYear} {companyName}. All rights reserved.</span>
              <span className="hidden md:block">•</span>
              <span className="flex items-center space-x-1">
                <span>Made with</span>
                <Heart className="h-4 w-4 text-red-500 fill-current" />
                <span>by the {serviceName} team</span>
              </span>
            </div>

            {/* Legal Links */}
            <div className="flex items-center space-x-6">
              {legalLinks.map((link, index) => (
                <React.Fragment key={link.name}>
                  <Link
                    href={link.href}
                    className="text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200"
                  >
                    {link.name}
                  </Link>
                  {index < legalLinks.length - 1 && (
                    <span className="text-gray-300">•</span>
                  )}
                </React.Fragment>
              ))}
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}
EOF

echo "✅ Enhanced Footer component created"

echo ""
echo "3️⃣ Updating AppLayout component..."

# Update the AppLayout component
cat > packages/ui/src/layouts/AppLayout.tsx << 'EOF'
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
EOF

echo "✅ AppLayout component updated"

echo ""
echo "4️⃣ Updating exports in index.ts..."

# Update the main index.ts to export the new Footer
cat > packages/ui/src/index.ts << 'EOF'
// Main exports for shared UI package
export { default as Navigation } from './components/Navigation'
export { default as AppLayout } from './layouts/AppLayout'
export { default as Footer } from './components/Footer'

// Export types
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

echo "✅ Exports updated"

echo ""
echo "5️⃣ Building the shared UI package..."

cd packages/ui
npm run build

if [ $? -eq 0 ]; then
    echo "✅ UI package built successfully"
else
    echo "❌ Build failed. Check errors above."
    cd ../..
    exit 1
fi

cd ../..

echo ""
echo "6️⃣ Creating example pages to test the footer..."

# Create footer demo pages for each service
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    case $service in
        "auth-service")
            theme_name="Auth"
            color="blue"
            ;;
        "user-service") 
            theme_name="User"
            color="green"
            ;;
        "content-service")
            theme_name="Content"
            color="purple"
            ;;
    esac
    
    # Create footer demo page
    mkdir -p "apps/$service/src/app/footer-demo"
    cat > "apps/$service/src/app/footer-demo/page.tsx" << EOF
import { AppLayout } from '@tt-ms-stack/ui'

export default function FooterDemoPage() {
  return (
    <AppLayout 
      serviceName="$theme_name Service"
      serviceColor="$color"
      companyName="TT-MS-Stack"
      showServiceLinksInFooter={true}
    >
      <div className="space-y-8">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Enhanced Footer Demo
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            This page demonstrates the new enhanced footer component with social links,
            service navigation, and company information.
          </p>
        </div>

        <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h3 className="text-lg font-semibold text-gray-900 mb-3">Footer Features</h3>
            <ul className="space-y-2 text-sm text-gray-600">
              <li>• Company branding and logo</li>
              <li>• Social media links</li>
              <li>• Service navigation</li>
              <li>• Product links</li>
              <li>• Legal pages</li>
            </ul>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h3 className="text-lg font-semibold text-gray-900 mb-3">Responsive Design</h3>
            <ul className="space-y-2 text-sm text-gray-600">
              <li>• Mobile-first approach</li>
              <li>• Flexible grid layout</li>
              <li>• Accessible navigation</li>
              <li>• Smooth animations</li>
              <li>• SEO optimized</li>
            </ul>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h3 className="text-lg font-semibold text-gray-900 mb-3">Customizable</h3>
            <ul className="space-y-2 text-sm text-gray-600">
              <li>• Company name & logo</li>
              <li>• Show/hide sections</li>
              <li>• Custom link groups</li>
              <li>• Theme integration</li>
              <li>• Environment URLs</li>
            </ul>
          </div>
        </div>

        <div className="bg-blue-50 p-6 rounded-lg">
          <h3 className="text-lg font-semibold text-blue-900 mb-2">
            Scroll down to see the footer!
          </h3>
          <p className="text-blue-700">
            The footer is automatically included in the AppLayout component and will 
            appear at the bottom of every page that uses it.
          </p>
        </div>

        {/* Add some content to make scrolling necessary */}
        <div className="space-y-4">
          {Array.from({ length: 10 }, (_, i) => (
            <div key={i} className="bg-white p-4 rounded border">
              <h4 className="font-medium text-gray-900">Content Section {i + 1}</h4>
              <p className="text-gray-600 text-sm mt-2">
                This is placeholder content to demonstrate how the footer appears 
                at the bottom of the page layout. The footer will stick to the 
                bottom regardless of content length.
              </p>
            </div>
          ))}
        </div>
      </div>
    </AppLayout>
  )
}
EOF
    
    echo "✅ Created footer demo page for $service"
done

echo ""
echo "7️⃣ Installing dependencies..."
npm install

echo ""
echo "🎉 Enhanced footer implementation complete!"
echo ""
echo "📋 Summary:"
echo "✅ Created beautiful footer component inspired by shadcn/blocks"
echo "✅ Added social media icons with Lucide React"
echo "✅ Integrated footer into AppLayout component"
echo "✅ Added customization options for company branding"
echo "✅ Created demo pages for each service"
echo ""
echo "🎨 Footer features:"
echo "• Company logo and branding section"
echo "• Social media links (GitHub, Twitter, LinkedIn, Email)"
echo "• Service navigation with icons"
echo "• Product and company link sections"
echo "• Legal links (Privacy, Terms, etc.)"
echo "• Responsive design with mobile optimization"
echo "• Accessible with proper ARIA labels"
echo "• Smooth hover animations"
echo ""
echo "🚀 Test the footer:"
echo "1. Run 'npm run dev' to start all services"
echo "2. Visit footer demo pages:"
echo "   • Auth: http://localhost:3000/footer-demo"
echo "   • User: http://localhost:3001/footer-demo"
echo "   • Content: http://localhost:3002/footer-demo"
echo ""
echo "⚙️ Customization options:"
echo "• companyName: Change the company name"
echo "• companyLogo: Add a custom logo URL"
echo "• showServiceLinksInFooter: Show/hide service links"
echo "• showFooter: Show/hide entire footer"
echo ""
echo "📝 Usage example:"
echo "import { AppLayout } from '@tt-ms-stack/ui'"
echo ""
echo "export default function MyPage() {"
echo "  return ("
echo "    <AppLayout"
echo "      serviceName='My Service'"
echo "      serviceColor='blue'"
echo "      companyName='Your Company'"
echo "      companyLogo='/logo.png'"
echo "      showServiceLinksInFooter={true}"
echo "    >"
echo "      {/* Your page content */}"
echo "    </AppLayout>"
echo "  )"
echo "}"
echo ""
echo "🔧 Environment variables to set:"
echo "Add these to your .env.local files for proper service links:"
echo ""
echo "NEXT_PUBLIC_AUTH_SERVICE_URL=http://localhost:3000"
echo "NEXT_PUBLIC_USER_SERVICE_URL=http://localhost:3001"
echo "NEXT_PUBLIC_CONTENT_SERVICE_URL=http://localhost:3002"
echo ""
echo "💡 Pro tip: Update the social links in Footer.tsx to point to your actual accounts!"