export default function SimpleTest() {
  return (
    <div>
      <h1 className="text-4xl font-bold text-blue-600">Simple Test</h1>
      <div className="bg-red-500 text-white p-4 m-4">
        This should have a red background and white text
      </div>
      <div className="bg-green-500 text-white p-4 m-4 rounded-lg">
        This should have a green background, white text, and rounded corners
      </div>
      <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
        This should be a blue button
      </button>
    </div>
  )
}
