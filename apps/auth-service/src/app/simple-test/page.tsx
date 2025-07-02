export default function SimpleTest() {
  return (
    <div className="p-8 space-y-4">
      <h1 className="text-3xl font-bold text-blue-600 mb-6">Tailwind Test Page</h1>
      
      {/* Test Button */}
      <button className="bg-blue-500 text-white rounded px-4 py-2 hover:bg-blue-600 transition-colors">
        Test Button (Should be Blue)
      </button>
      
      {/* Test Colored Squares */}
      <div className="w-20 h-20 bg-red-500 rounded flex items-center justify-center text-white font-bold">
        Red
      </div>
      
      <div className="w-20 h-20 bg-green-500 rounded flex items-center justify-center text-white font-bold">
        Green
      </div>
      
      <div className="w-20 h-20 bg-yellow-500 rounded flex items-center justify-center text-black font-bold">
        Yellow
      </div>
      
      {/* Test Cards */}
      <div className="bg-white p-6 rounded-lg shadow-lg border border-gray-200 max-w-md">
        <h3 className="text-lg font-semibold text-gray-900 mb-2">Test Card</h3>
        <p className="text-gray-600">
          If you can see this card with proper styling, padding, shadow, and rounded corners, 
          then Tailwind CSS is working correctly!
        </p>
      </div>
      
      {/* Debug Information */}
      <div className="mt-8 p-4 bg-gray-100 rounded">
        <h2 className="text-lg font-semibold mb-2">Debug Info:</h2>
        <ul className="space-y-1 text-sm">
          <li>✅ Blue navigation bar working = Tailwind partially loaded</li>
          <li>❌ Test elements not styled = Content scanning issue</li>
          <li>🔧 Fix: Updated Tailwind config with broader content paths</li>
        </ul>
      </div>
    </div>
  )
}
