#!/bin/bash
echo "🔧 Fixing Tailwind content scanning issue..."

cd apps/auth-service

echo "1️⃣ Creating a completely new, working Tailwind config..."

# Create a simple, working Tailwind config without presets
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    // Include all possible paths
    "./**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

echo "✅ Created new Tailwind config"

echo "2️⃣ Updating your simple-test page with better test content..."

# Create a comprehensive test page
cat > src/app/simple-test/page.tsx << 'EOF'
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
EOF

echo "✅ Updated test page"

echo "3️⃣ Ensuring globals.css has proper Tailwind directives..."

# Make sure globals.css is correct
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Root variables */
:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

body {
  color: rgb(var(--foreground-rgb));
  background: linear-gradient(
      to bottom,
      transparent,
      rgb(var(--background-end-rgb))
    )
    rgb(var(--background-start-rgb));
}
EOF

echo "✅ Fixed globals.css"

echo "4️⃣ Cleaning and rebuilding..."

# Clean everything
rm -rf .next
rm -rf node_modules/.cache

echo "✅ Cleaned cache"
echo ""
echo "🚀 Now restart your dev server:"
echo "1. Stop current server (Ctrl+C)"
echo "2. Run: npm run dev"
echo "3. Visit: http://localhost:3000/simple-test"
echo "4. Hard refresh browser (Ctrl+Shift+R)"
echo ""
echo "You should now see:"
echo "✅ Blue button with proper styling"
echo "✅ Colored squares (red, green, yellow)"
echo "✅ Styled card with shadow and padding"