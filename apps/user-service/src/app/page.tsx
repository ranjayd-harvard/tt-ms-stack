export default function Home() {
  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-4 border-dashed border-green-200 rounded-lg h-96 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            User Management Dashboard
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Manage users, roles, and permissions.
          </p>
          <div className="grid gap-4 md:grid-cols-3 mt-8">
            <div className="p-4 bg-green-50 rounded-lg">
              <h3 className="font-semibold text-green-900">👥 Manage Users</h3>
              <p className="text-green-700 text-sm">View and manage user accounts</p>
            </div>
            <div className="p-4 bg-green-50 rounded-lg">
              <h3 className="font-semibold text-green-900">🔐 Roles & Permissions</h3>
              <p className="text-green-700 text-sm">Configure access control</p>
            </div>
            <div className="p-4 bg-green-50 rounded-lg">
              <h3 className="font-semibold text-green-900">📊 Analytics</h3>
              <p className="text-green-700 text-sm">View user activity statistics</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
