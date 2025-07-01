export default function TailwindTest() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-5xl font-bold text-blue-600 mb-8 text-center">
          Tailwind CSS Test
        </h1>
        
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <div className="bg-white p-6 rounded-xl shadow-lg border border-gray-200 hover:shadow-xl transition-shadow">
            <h3 className="text-xl font-semibold text-gray-900 mb-3">
              Card 1
            </h3>
            <p className="text-gray-600">
              If you can see this styled card with rounded corners, shadows, and proper spacing, 
              Tailwind CSS is working correctly!
            </p>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-lg border border-gray-200 hover:shadow-xl transition-shadow">
            <h3 className="text-xl font-semibold text-gray-900 mb-3">
              Card 2
            </h3>
            <p className="text-gray-600">
              This card should have a white background, rounded corners, and a subtle shadow.
            </p>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-lg border border-gray-200 hover:shadow-xl transition-shadow">
            <h3 className="text-xl font-semibold text-gray-900 mb-3">
              Card 3
            </h3>
            <p className="text-gray-600">
              All three cards should be in a responsive grid layout.
            </p>
          </div>
        </div>
        
        <div className="mt-8 text-center">
          <button className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors">
            Test Button
          </button>
        </div>
        
        <div className="mt-8 p-6 bg-green-50 border border-green-200 rounded-lg">
          <h3 className="text-lg font-semibold text-green-800 mb-2">
            ✅ Success!
          </h3>
          <p className="text-green-700">
            If this box has a green background and border, and the button above is blue, 
            then Tailwind CSS is working properly and your footer should also be styled correctly.
          </p>
        </div>
      </div>
    </div>
  )
}
