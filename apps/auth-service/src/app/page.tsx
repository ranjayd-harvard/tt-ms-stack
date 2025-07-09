export default function Home() {
  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-4 border-dashed border-gray-200 rounded-lg h-96 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Welcome to Auth Service
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Authentication and authorization microservice.
          </p>
          <div className="space-y-2">
            <p className="text-gray-500">🔐 Secure authentication</p>
            <p className="text-gray-500">👥 User management</p>
            <p className="text-gray-500">🛡️ Role-based access control</p>
          </div>
        </div>
      </div>
    </div>
  )
}
