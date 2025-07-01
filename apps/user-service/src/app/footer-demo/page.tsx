import { AppLayout } from '@tt-ms-stack/ui'

export default function FooterDemoPage() {
  return (
    <AppLayout 
      serviceName="User Service"
      serviceColor="green"
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
