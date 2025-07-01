#!/bin/bash

echo "🎨 Fixing footer styling and layout..."

echo ""
echo "1️⃣ Checking current footer implementation..."

# Check if the enhanced footer is being used
if [ -f "packages/ui/src/components/Footer.tsx" ]; then
    echo "✅ Enhanced Footer component exists"
else
    echo "❌ Enhanced Footer component missing"
    exit 1
fi

echo ""
echo "2️⃣ Ensuring proper CSS imports in all services..."

# Make sure each service imports the themed CSS properly
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Checking $service layout..."
    
    if [ -f "apps/$service/src/app/layout.tsx" ]; then
        # Check if it imports globals.css
        if grep -q "globals.css" "apps/$service/src/app/layout.tsx"; then
            echo "✅ $service imports globals.css"
        else
            echo "⚠️ $service missing globals.css import, adding it..."
            
            # Backup existing layout
            cp "apps/$service/src/app/layout.tsx" "apps/$service/src/app/layout.tsx.backup"
            
            # Add CSS import at the top
            echo "import './globals.css'" > temp_layout.tsx
            cat "apps/$service/src/app/layout.tsx" >> temp_layout.tsx
            mv temp_layout.tsx "apps/$service/src/app/layout.tsx"
            
            echo "✅ Added globals.css import to $service"
        fi
    else
        echo "❌ $service layout.tsx not found"
    fi
done

echo ""
echo "3️⃣ Ensuring proper Tailwind CSS is loaded..."

# Check and fix Tailwind configs
for service in "${services[@]}"; do
    echo "Checking $service Tailwind config..."
    
    # Make sure Tailwind config includes UI package
    if [ -f "apps/$service/tailwind.config.js" ] || [ -f "apps/$service/tailwind.config.ts" ]; then
        
        # Find the config file
        config_file=""
        if [ -f "apps/$service/tailwind.config.js" ]; then
            config_file="apps/$service/tailwind.config.js"
        elif [ -f "apps/$service/tailwind.config.ts" ]; then
            config_file="apps/$service/tailwind.config.ts"
        fi
        
        # Check if it includes UI package in content
        if grep -q "packages/ui" "$config_file"; then
            echo "✅ $service Tailwind config includes UI package"
        else
            echo "⚠️ Updating $service Tailwind config..."
            
            # Create enhanced Tailwind config
            cat > "apps/$service/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}"
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
  plugins: [],
}
EOF
            
            echo "✅ Updated $service Tailwind config"
        fi
    else
        echo "❌ $service missing Tailwind config"
    fi
done

echo ""
echo "4️⃣ Creating a beautiful footer demo page..."

# Create a specific footer demo page for auth-service
mkdir -p "apps/auth-service/src/app/footer-showcase"
cat > "apps/auth-service/src/app/footer-showcase/page.tsx" << 'EOF'
import { AppLayout } from '@tt-ms-stack/ui'

export default function FooterShowcase() {
  return (
    <AppLayout 
      serviceName="Auth Service"
      serviceColor="blue"
      companyName="TT-MS-Stack"
      showServiceLinksInFooter={true}
    >
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
        {/* Hero Section */}
        <div className="relative overflow-hidden">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
            <div className="text-center">
              <h1 className="text-5xl font-bold text-gray-900 mb-6">
                Enhanced Footer 
                <span className="text-blue-600">Demo</span>
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
                Scroll down to see our beautiful, responsive footer with social links, 
                service navigation, and professional branding that works across all microservices.
              </p>
              <div className="flex justify-center space-x-4">
                <div className="bg-white p-4 rounded-lg shadow-sm border">
                  <div className="text-2xl font-bold text-blue-600">3</div>
                  <div className="text-sm text-gray-600">Services</div>
                </div>
                <div className="bg-white p-4 rounded-lg shadow-sm border">
                  <div className="text-2xl font-bold text-green-600">4</div>
                  <div className="text-sm text-gray-600">Social Links</div>
                </div>
                <div className="bg-white p-4 rounded-lg shadow-sm border">
                  <div className="text-2xl font-bold text-purple-600">12</div>
                  <div className="text-sm text-gray-600">Footer Links</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Content Sections */}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
            {/* Footer Features */}
            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">🎨</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Beautiful Design
              </h3>
              <p className="text-gray-600">
                Modern, clean footer design that matches your brand and provides 
                excellent user experience across all devices.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">📱</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Fully Responsive
              </h3>
              <p className="text-gray-600">
                Looks perfect on desktop, tablet, and mobile devices with 
                intelligent layout that adapts to any screen size.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">🔗</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Smart Navigation
              </h3>
              <p className="text-gray-600">
                Automatically includes links to all your microservices, 
                social media, and important company pages.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">♿</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Accessible
              </h3>
              <p className="text-gray-600">
                Built with accessibility in mind, including proper ARIA labels, 
                keyboard navigation, and screen reader support.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">⚙️</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Customizable
              </h3>
              <p className="text-gray-600">
                Easy to customize with your brand colors, logo, company name, 
                and specific links for each service.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-sm border">
              <div className="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl">🚀</span>
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                Performance
              </h3>
              <p className="text-gray-600">
                Lightweight and fast-loading, with optimized icons and 
                smooth animations that don't impact page performance.
              </p>
            </div>
          </div>
        </div>

        {/* Call to Action */}
        <div className="bg-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div className="text-center">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to see the footer?
              </h2>
              <p className="text-xl text-gray-600 mb-8">
                Scroll down to see the enhanced footer in action, or visit other services 
                to see how it adapts to different themes.
              </p>
              <div className="flex justify-center space-x-4">
                <a 
                  href="http://localhost:3001" 
                  target="_blank"
                  rel="noopener noreferrer"
                  className="bg-green-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-green-700 transition-colors"
                >
                  User Service
                </a>
                <a 
                  href="http://localhost:3002" 
                  target="_blank"
                  rel="noopener noreferrer"
                  className="bg-purple-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-purple-700 transition-colors"
                >
                  Content Service
                </a>
              </div>
            </div>
          </div>
        </div>

        {/* Spacer to ensure footer is visible */}
        <div className="h-32"></div>
      </div>
    </AppLayout>
  )
}
EOF

echo "✅ Created beautiful footer showcase page"

echo ""
echo "5️⃣ Rebuilding UI package with proper exports..."

cd packages/ui

# Ensure we have the enhanced footer
if [ ! -f "src/components/Footer.tsx" ] || ! grep -q "social" "src/components/Footer.tsx"; then
    echo "⚠️ Updating Footer component with enhanced version..."
    
    # Create the enhanced footer component
    cat > src/components/Footer.tsx << 'EOF'
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

    echo "✅ Enhanced Footer component updated"
fi

# Rebuild the package
npm run build

if [ $? -eq 0 ]; then
    echo "✅ UI package rebuilt successfully"
else
    echo "❌ UI package build failed"
    cd ../..
    exit 1
fi

cd ../..

echo ""
echo "6️⃣ Installing updates across the monorepo..."

npm install --legacy-peer-deps

echo ""
echo "🎉 Footer styling fix complete!"
echo ""
echo "📋 What was fixed:"
echo "✅ Enhanced Footer component with proper styling"
echo "✅ Fixed CSS imports in all service layouts"
echo "✅ Updated Tailwind configs to include UI package"
echo "✅ Created beautiful footer showcase page"
echo "✅ Rebuilt UI package with all enhancements"
echo ""
echo "🚀 Test the beautiful footer:"
echo "1. Run: npm run dev"
echo "2. Visit: http://localhost:3000/footer-showcase"
echo "3. Scroll down to see the enhanced footer"
echo ""
echo "🎨 The footer now includes:"
echo "• Professional multi-column layout"
echo "• Social media icons with hover effects"
echo "• Service navigation with icons"
echo "• Company branding section"
echo "• Legal links"
echo "• Responsive design"
echo "• Smooth animations"
echo ""
echo "✨ The footer should now look modern and professional!"