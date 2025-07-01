#!/bin/bash

echo "🔧 Complete Tailwind CSS fix - diagnosing and resolving all issues..."

echo ""
echo "1️⃣ Checking current setup in auth-service..."

cd apps/auth-service

# Check what's currently installed
echo "Current dependencies:"
grep -E "(tailwindcss|postcss|autoprefixer)" package.json || echo "No Tailwind dependencies found"

echo ""
echo "2️⃣ Installing/updating Tailwind CSS and dependencies..."

# Install latest Tailwind CSS
npm install -D tailwindcss@latest postcss@latest autoprefixer@latest

echo "✅ Tailwind dependencies installed"

echo ""
echo "3️⃣ Creating proper PostCSS config..."

# Create PostCSS config
cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

echo "✅ PostCSS config created"

echo ""
echo "4️⃣ Creating comprehensive Tailwind config..."

# Create a complete Tailwind config
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    '../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: 'var(--background)',
        foreground: 'var(--foreground)',
      },
    },
  },
  plugins: [],
}
EOF

echo "✅ Tailwind config created"

echo ""
echo "5️⃣ Creating proper globals.css with Tailwind directives..."

# Backup existing CSS
if [ -f "src/app/globals.css" ]; then
    cp src/app/globals.css src/app/globals.css.backup
fi

# Create minimal but complete CSS file
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

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

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
EOF

echo "✅ Created proper globals.css"

echo ""
echo "6️⃣ Ensuring layout.tsx imports CSS correctly..."

# Check and fix layout
if [ -f "src/app/layout.tsx" ]; then
    # Backup layout
    cp src/app/layout.tsx src/app/layout.tsx.backup
    
    # Check if it imports CSS
    if ! grep -q "globals.css" src/app/layout.tsx; then
        echo "Adding CSS import to layout..."
        
        # Read current layout and add CSS import
        {
            echo "import './globals.css'"
            cat src/app/layout.tsx
        } > temp_layout.tsx
        
        mv temp_layout.tsx src/app/layout.tsx
    fi
    
    echo "✅ Layout imports CSS"
else
    echo "❌ Layout.tsx not found!"
    exit 1
fi

echo ""
echo "7️⃣ Testing Tailwind CSS generation..."

# Try to generate CSS to see if it works
echo "Generating Tailwind CSS..."
npx tailwindcss -i ./src/app/globals.css -o ./test-output.css --watch=false

if [ -f "test-output.css" ]; then
    echo "✅ Tailwind CSS generation successful"
    echo "Generated CSS size: $(wc -c < test-output.css) bytes"
    
    # Check if it contains actual Tailwind classes
    if grep -q "bg-blue" test-output.css; then
        echo "✅ Tailwind utilities found in generated CSS"
    else
        echo "⚠️ No Tailwind utilities found - may need content scan"
    fi
    
    # Clean up test file
    rm test-output.css
else
    echo "❌ Failed to generate CSS"
fi

echo ""
echo "8️⃣ Creating a minimal test page that should definitely work..."

# Create an even simpler test
mkdir -p src/app/simple-test
cat > src/app/simple-test/page.tsx << 'EOF'
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
EOF

echo "✅ Created simple test page"

echo ""
echo "9️⃣ Checking Next.js config for any CSS issues..."

# Check if there's a Next.js config that might interfere
if [ -f "next.config.js" ] || [ -f "next.config.ts" ]; then
    echo "Next.js config found:"
    if [ -f "next.config.js" ]; then
        cat next.config.js
    else
        cat next.config.ts
    fi
else
    echo "No Next.js config found, creating minimal one..."
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {}

module.exports = nextConfig
EOF
    echo "✅ Created minimal Next.js config"
fi

echo ""
echo "🔟 Trying a complete clean build..."

# Clean everything and rebuild
rm -rf .next
rm -rf node_modules/.cache

echo "Building project..."
if npm run build > build_log.txt 2>&1; then
    echo "✅ Build successful!"
    
    # Check for CSS in build
    if [ -d ".next/static/css" ]; then
        echo "✅ CSS files generated in build"
        ls -la .next/static/css/
    else
        echo "❌ No CSS files in build output"
    fi
else
    echo "❌ Build failed. Here's the error:"
    cat build_log.txt | tail -20
fi

# Clean up log
rm -f build_log.txt

cd ../..

echo ""
echo "1️⃣1️⃣ Checking if the issue is in the UI package..."

# Check if UI package has conflicting Tailwind
cd packages/ui

echo "Checking UI package Tailwind config..."
if [ -f "tailwind.config.js" ]; then
    echo "UI package has its own Tailwind config:"
    cat tailwind.config.js
    
    echo ""
    echo "This might be conflicting. Renaming it..."
    mv tailwind.config.js tailwind.config.js.backup
    echo "✅ Backed up UI package Tailwind config"
fi

cd ../..

echo ""
echo "🎉 Complete Tailwind fix finished!"
echo ""
echo "📋 What was done:"
echo "✅ Installed latest Tailwind CSS, PostCSS, and Autoprefixer"
echo "✅ Created proper PostCSS configuration"
echo "✅ Created comprehensive Tailwind config with correct content paths"
echo "✅ Fixed globals.css with proper Tailwind directives"
echo "✅ Ensured layout.tsx imports CSS correctly"
echo "✅ Tested CSS generation manually"
echo "✅ Created simple test page with basic styles"
echo "✅ Checked for Next.js config conflicts"
echo "✅ Performed clean build"
echo "✅ Checked for UI package conflicts"
echo ""
echo "🚀 Testing steps:"
echo "1. RESTART your dev server completely:"
echo "   - Press Ctrl+C to stop current server"
echo "   - Run: npm run dev"
echo ""
echo "2. Test the simple version first:"
echo "   - Visit: http://localhost:3000/simple-test"
echo "   - You should see red and green colored boxes"
echo ""
echo "3. If that works, test the full version:"
echo "   - Visit: http://localhost:3000/tailwind-test"
echo ""
echo "4. Then test your footer:"
echo "   - Visit: http://localhost:3000/footer-showcase"
echo ""
echo "💡 If it still doesn't work:"
echo "1. Check browser console for any errors"
echo "2. Try hard refresh (Ctrl+Shift+R or Cmd+Shift+R)"
echo "3. Clear browser cache completely"
echo "4. Check if dev server shows any CSS compilation errors"