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
