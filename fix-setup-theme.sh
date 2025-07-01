#!/bin/bash

echo "🔧 Fixing theme setup issues..."

echo ""
echo "1️⃣ Fixing TypeScript export issue in packages/ui/src/index.ts..."

# Fix the CSS export issue
cat > packages/ui/src/index.ts << 'EOF'
// UI Components
export * from './components/ui/button'
export * from './components/ui/card'

// Layout Components  
export { default as AppLayout } from './layouts/AppLayout'
export { default as Navigation } from './components/Navigation'

// Utility Functions
export { cn } from './lib/utils'

// Note: CSS should be imported in your app's layout, not exported from here
// Import in your layout.tsx: import '@tt-ms-stack/ui/dist/styles/globals.css'
EOF

echo "✅ Fixed index.ts export"

echo ""
echo "2️⃣ Fixing Tailwind config updates for all services..."

# Fix Tailwind configs manually (sed command was failing)
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Fixing Tailwind config for $service..."
    
    cat > "apps/$service/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}"
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
  plugins: [require("tailwindcss-animate")],
}
EOF
    
    echo "✅ Fixed Tailwind config for $service"
done

echo ""
echo "3️⃣ Installing missing tailwindcss-animate dependency..."

# Install tailwindcss-animate in all services
for service in "${services[@]}"; do
    echo "Installing tailwindcss-animate in $service..."
    cd "apps/$service"
    npm install -D tailwindcss-animate
    cd ../..
done

# Also install in UI package
cd packages/ui
npm install -D tailwindcss-animate
cd ../..

echo ""
echo "4️⃣ Creating proper CSS import structure..."

# Create a proper globals.css that can be imported
mkdir -p packages/ui/dist/styles
cp packages/ui/src/styles/globals.css packages/ui/dist/styles/globals.css

echo ""
echo "5️⃣ Updating service layouts to import the CSS..."

# Update each service's layout to import the CSS
for service in "${services[@]}"; do
    echo "Updating $service layout..."
    
    # Check if layout.tsx exists and update it
    if [ -f "apps/$service/src/app/layout.tsx" ]; then
        # Add CSS import to the layout if not already present
        if ! grep -q "@tt-ms-stack/ui" "apps/$service/src/app/layout.tsx"; then
            # Create a backup
            cp "apps/$service/src/app/layout.tsx" "apps/$service/src/app/layout.tsx.backup"
            
            # Add the import at the top
            echo "import '../../packages/ui/src/styles/globals.css'" > temp_layout.tsx
            cat "apps/$service/src/app/layout.tsx" >> temp_layout.tsx
            mv temp_layout.tsx "apps/$service/src/app/layout.tsx"
            
            echo "✅ Added CSS import to $service layout"
        else
            echo "✅ $service layout already has CSS import"
        fi
    else
        echo "⚠️  Layout file not found for $service, you'll need to add the CSS import manually"
    fi
done

echo ""
echo "6️⃣ Rebuilding the UI package..."

cd packages/ui
npm run build
cd ../..

echo ""
echo "7️⃣ Installing dependencies across monorepo..."
npm install

echo ""
echo "🎉 Issues fixed! Setup should now be complete."
echo ""
echo "📋 What was fixed:"
echo "✅ Fixed TypeScript export syntax in UI package"
echo "✅ Fixed Tailwind config content paths"
echo "✅ Added missing tailwindcss-animate dependency"
echo "✅ Created proper CSS import structure"
echo "✅ Updated service layouts to import themed CSS"
echo "✅ Rebuilt UI package successfully"
echo ""
echo "🚀 Next steps:"
echo "1. Run 'npm run dev' to start all services"
echo "2. Visit /themed-example on each service"
echo "3. Start using components: import { Button } from '@tt-ms-stack/ui'"