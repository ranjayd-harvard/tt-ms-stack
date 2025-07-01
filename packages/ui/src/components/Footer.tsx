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
