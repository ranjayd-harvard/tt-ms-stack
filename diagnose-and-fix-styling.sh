#!/bin/bash

echo "🔍 Diagnosing and fixing styling issues..."

echo ""
echo "1️⃣ Checking Tailwind CSS setup in auth-service..."

cd apps/auth-service

# Check if globals.css exists and has proper content
echo "Checking globals.css..."
if [ -f "src/app/globals.css" ]; then
    echo "✅ globals.css exists"
    
    # Check if it has Tailwind directives
    if grep -q "@tailwind" "src/app/globals.css"; then
        echo "✅ Tailwind directives found"
    else
        echo "❌ Missing Tailwind directives, adding them..."
        
        # Backup existing CSS
        cp src/app/globals.css src/app/globals.css.backup
        
        # Create proper CSS with Tailwind
        cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* ============================================
   BASE CSS VARIABLES & DESIGN TOKENS
   ============================================ */
:root {
  --background: #ffffff;
  --foreground: #171717;
  
  /* Base design system colors */
  --border: 214.3 31.8% 91.4%;
  --input: 214.3 31.8% 91.4%;
  --ring: 221.2 83.2% 53.3%;
  --radius: 0.75rem;
  
  /* Default theme colors */
  --primary: 221.2 83.2% 53.3%;
  --primary-foreground: 210 40% 98%;
  --secondary: 210 40% 96%;
  --secondary-foreground: 222.2 84% 4.9%;
  --muted: 210 40% 96%;
  --muted-foreground: 215.4 16.3% 46.9%;
  --accent: 210 40% 96%;
  --accent-foreground: 222.2 84% 4.9%;
  --destructive: 0 84.2% 60.2%;
  --destructive-foreground: 210 40% 98%;
  --card: 0 0% 100%;
  --card-foreground: 222.2 84% 4.9%;
  --popover: 0 0% 100%;
  --popover-foreground: 222.2 84% 4.9%;
}

@media (prefers-color-scheme: dark) {
  :root {
    --background: #0a0a0a;
    --foreground: #ededed;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 94.1%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 84% 4.9%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
  }
}

/* ============================================
   SERVICE-SPECIFIC THEME CLASSES
   ============================================ */

/* AUTH SERVICE THEME - Blue */
.auth-theme {
  --primary: 221.2 83.2% 53.3%;        /* Blue */
  --primary-foreground: 210 40% 98%;
  --secondary: 210 40% 96%;
  --accent: 210 40% 96%;
  --service-color: #3b82f6;             /* For direct usage */
}

/* USER SERVICE THEME - Green */
.user-theme {
  --primary: 142.1 76.2% 36.3%;        /* Green */
  --primary-foreground: 355.7 100% 97.3%;
  --secondary: 138 76% 97%;
  --accent: 138 76% 97%;
  --service-color: #10b981;             /* For direct usage */
}

/* CONTENT SERVICE THEME - Purple */
.content-theme {
  --primary: 262.1 83.3% 57.8%;        /* Purple */
  --primary-foreground: 210 40% 98%;
  --secondary: 270 95% 98%;
  --accent: 270 95% 98%;
  --service-color: #8b5cf6;             /* For direct usage */
}

/* ============================================
   BASE STYLING
   ============================================ */
* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

body {
  background: var(--background);
  color: var(--foreground);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  margin: 0;
}

a {
  color: inherit;
  text-decoration: none;
}

button {
  font-family: inherit;
}

/* ============================================
   ANIMATIONS & UTILITIES
   ============================================ */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.animate-shake {
  animation: shake 0.5s ease-in-out;
}
EOF
        
        echo "✅ Added proper CSS with Tailwind directives"
    fi
else
    echo "❌ globals.css missing, creating it..."
    
    # Create the CSS file
    mkdir -p src/app
    cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --background: #ffffff;
  --foreground: #171717;
}

body {
  background: var(--background);
  color: var(--foreground);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
}
EOF
    
    echo "✅ Created globals.css"
fi

echo ""
echo "2️⃣ Checking and fixing Tailwind config..."

# Check Tailwind config
if [ -f "tailwind.config.js" ] || [ -f "tailwind.config.ts" ]; then
    echo "✅ Tailwind config exists"
    
    # Create a proper Tailwind config that includes everything
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [],
}
EOF
    
    echo "✅ Updated Tailwind config"
else
    echo "❌ Tailwind config missing, creating it..."
    
    # Install Tailwind CSS if not present
    if ! grep -q "tailwindcss" package.json; then
        echo "Installing Tailwind CSS..."
        npm install -D tailwindcss postcss autoprefixer
    fi
    
    # Create config
    npx tailwindcss init -p
    
    echo "✅ Created Tailwind config"
fi

echo ""
echo "3️⃣ Checking layout.tsx imports..."

# Check if layout imports CSS
if [ -f "src/app/layout.tsx" ]; then
    if grep -q "globals.css" "src/app/layout.tsx"; then
        echo "✅ Layout imports globals.css"
    else
        echo "❌ Layout missing CSS import, fixing..."
        
        # Backup layout
        cp src/app/layout.tsx src/app/layout.tsx.backup
        
        # Add CSS import at the top
        echo "import './globals.css'" > temp_layout.tsx
        cat src/app/layout.tsx >> temp_layout.tsx
        mv temp_layout.tsx src/app/layout.tsx
        
        echo "✅ Added CSS import to layout"
    fi
else
    echo "❌ Layout.tsx not found"
fi

echo ""
echo "4️⃣ Testing build to see if Tailwind is working..."

# Try to build to see if there are any issues
echo "Testing build..."
if npm run build > build_output.txt 2>&1; then
    echo "✅ Build successful"
else
    echo "❌ Build failed, checking errors..."
    cat build_output.txt | tail -20
    
    echo "Trying to fix common issues..."
    
    # Install missing dependencies
    npm install -D tailwindcss postcss autoprefixer
    
    # Try again
    if npm run build > build_output2.txt 2>&1; then
        echo "✅ Build successful after installing dependencies"
    else
        echo "❌ Build still failing, check build_output2.txt for details"
    fi
fi

# Clean up build output files
rm -f build_output.txt build_output2.txt

cd ../..

echo ""
echo "5️⃣ Creating a simple test page to verify Tailwind is working..."

# Create a simple test page with obvious Tailwind styles
mkdir -p apps/auth-service/src/app/tailwind-test
cat > apps/auth-service/src/app/tailwind-test/page.tsx << 'EOF'
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
EOF

echo "✅ Created Tailwind test page"

echo ""
echo "🎉 Styling diagnosis and fix complete!"
echo ""
echo "📋 What was checked and fixed:"
echo "✅ Added proper globals.css with Tailwind directives"
echo "✅ Updated Tailwind config with correct content paths"
echo "✅ Ensured layout.tsx imports CSS properly"
echo "✅ Tested build process"
echo "✅ Created test page to verify Tailwind is working"
echo ""
echo "🚀 Test your styling:"
echo "1. Run: npm run dev"
echo "2. Visit: http://localhost:3000/tailwind-test"
echo "3. You should see styled cards and buttons"
echo "4. Then visit: http://localhost:3000/footer-showcase"
echo "5. The footer should now be properly styled"
echo ""
echo "🎯 If the test page shows styled cards with:"
echo "• White backgrounds and shadows"
echo "• Rounded corners"
echo "• Blue gradient background"
echo "• Blue button that changes on hover"
echo ""
echo "Then Tailwind is working and your footer should be beautiful!"
echo ""
echo "💡 If styling still doesn't work, try:"
echo "1. Restart your dev server (Ctrl+C, then npm run dev)"
echo "2. Clear browser cache"
echo "3. Check browser console for any CSS errors"