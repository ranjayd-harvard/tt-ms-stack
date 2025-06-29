interface FooterProps {
  serviceName: string
}

export default function Footer({ serviceName }: FooterProps) {
  const currentYear = new Date().getFullYear()
  
  return (
    <footer className="bg-white border-t border-gray-200 mt-auto">
      <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="text-gray-600 text-sm">
            My Stack 111
          </div>
          <div className="flex space-x-6 mt-4 md:mt-0">
            <a href="/privacy" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Privacy Policy
            </a>
            <a href="/terms" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Terms of Service
            </a>
            <a href="/support" className="text-gray-600 hover:text-gray-900 text-sm transition-colors">
              Support
            </a>
          </div>
        </div>
        <div className="mt-4 pt-4 border-t border-gray-100">
          <div className="text-xs text-gray-500 text-center md:text-left">
          © {currentYear} {serviceName}. Part of TT-MS-Stack.
          </div>
        </div>
      </div>
    </footer>
  )
}
