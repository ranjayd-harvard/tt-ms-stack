export default function Home() {
  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-4 border-dashed border-purple-200 rounded-lg h-96 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Content Management Dashboard
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Create and manage articles, media, and content.
          </p>
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4 mt-8">
            <div className="p-4 bg-purple-50 rounded-lg">
              <h3 className="font-semibold text-purple-900">📝 Articles</h3>
              <p className="text-purple-700 text-sm">Create and manage articles</p>
            </div>
            <div className="p-4 bg-purple-50 rounded-lg">
              <h3 className="font-semibold text-purple-900">🖼️ Media</h3>
              <p className="text-purple-700 text-sm">Upload and organize files</p>
            </div>
            <div className="p-4 bg-purple-50 rounded-lg">
              <h3 className="font-semibold text-purple-900">📁 Categories</h3>
              <p className="text-purple-700 text-sm">Organize content</p>
            </div>
            <div className="p-4 bg-purple-50 rounded-lg">
              <h3 className="font-semibold text-purple-900">📊 Analytics</h3>
              <p className="text-purple-700 text-sm">View performance</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
