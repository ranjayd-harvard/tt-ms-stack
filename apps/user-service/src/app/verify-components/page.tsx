'use client'

import { Button, Card, CardHeader, CardTitle, CardContent, AppLayout } from '@tt-ms-stack/ui'

export default function VerifyComponentsPage() {
  return (
    <AppLayout serviceName="user service" serviceColor="blue">
      <div className="space-y-6 max-w-4xl mx-auto">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Component Verification ✅
          </h1>
          <p className="text-xl text-gray-600">
            Testing that all shadcn/ui components are working correctly in user-service
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle>Button Components</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="flex flex-wrap gap-2">
                <Button>Default</Button>
                <Button variant="outline">Outline</Button>
                <Button variant="secondary">Secondary</Button>
                <Button variant="ghost">Ghost</Button>
                <Button variant="link">Link</Button>
              </div>
              <div className="flex flex-wrap gap-2">
                <Button size="sm">Small</Button>
                <Button size="default">Default</Button>
                <Button size="lg">Large</Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Card Components</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-gray-600 mb-4">
                This card demonstrates that Card, CardHeader, CardTitle, and CardContent 
                are all working correctly.
              </p>
              <div className="bg-green-50 p-3 rounded border border-green-200">
                <p className="text-green-800 text-sm">
                  ✅ All card components rendering successfully!
                </p>
              </div>
            </CardContent>
          </Card>

          <Card className="md:col-span-2">
            <CardHeader>
              <CardTitle>Import Test Results</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid gap-4 md:grid-cols-3">
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>Button imported</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>Card imported</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>CardHeader imported</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>CardTitle imported</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>CardContent imported</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-500">✅</span>
                  <span>AppLayout imported</span>
                </div>
              </div>
              
              <div className="mt-6 p-4 bg-blue-50 rounded">
                <h4 className="font-semibold text-blue-900 mb-2">Success!</h4>
                <p className="text-blue-800 text-sm">
                  All components from @tt-ms-stack/ui are working correctly. 
                  You can now use these components throughout your application.
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
        
        <div className="text-center space-y-4">
          <h3 className="text-lg font-semibold">Next Steps</h3>
          <div className="grid gap-4 md:grid-cols-3 text-sm">
            <div className="p-4 bg-gray-50 rounded">
              <h4 className="font-medium mb-2">Use Components</h4>
              <p className="text-gray-600">
                Import and use Button, Card, and other components in your pages
              </p>
            </div>
            <div className="p-4 bg-gray-50 rounded">
              <h4 className="font-medium mb-2">Check Footer</h4>
              <p className="text-gray-600">
                Visit /footer-demo to see the enhanced footer in action
              </p>
            </div>
            <div className="p-4 bg-gray-50 rounded">
              <h4 className="font-medium mb-2">Test Themes</h4>
              <p className="text-gray-600">
                Visit /theme-test to see service-specific color themes
              </p>
            </div>
          </div>
        </div>
      </div>
    </AppLayout>
  )
}
