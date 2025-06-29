i#!/bin/bash

echo "🔧 Fixing Tailwind CSS and PostCSS configuration errors..."

# Stop all running services first
echo "1️⃣ Please stop all running services (Ctrl+C) before continuing..."
echo "Press Enter to continue after stopping services..."
read -r

echo ""
echo "2️⃣ Installing proper Tailwind CSS and PostCSS dependencies..."

# Install correct dependencies for each service
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Installing dependencies for $service..."
    cd "apps/$service"
    
    # Remove any existing problematic packages
    npm uninstall tailwindcss @tailwindcss/postcss autoprefixer postcss 2>/dev/null
    
    # Install the correct versions
    npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
    
    echo "✅ Dependencies installed for $service"
    cd ../..
done

echo ""
echo "3️⃣ Creating correct PostCSS configurations..."

# Create proper PostCSS config for each service
for service in "${services[@]}"; do
    echo "Creating PostCSS config for $service..."
    
    cat > "apps/$service/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    
    echo "✅ PostCSS config created for $service"
done

echo ""
echo "4️⃣ Creating correct Tailwind configurations..."

# Create proper Tailwind config for each service
for service in "${services[@]}"; do
    echo "Creating Tailwind config for $service..."
    
    cat > "apps/$service/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
      },
    },
  },
  plugins: [],
}
EOF
    
    # Remove any .ts version
    rm -f "apps/$service/tailwind.config.ts"
    
    echo "✅ Tailwind config created for $service"
done

echo ""
echo "5️⃣ Creating clean globals.css files..."

# Create a clean, working globals.css for each service
for service in "${services[@]}"; do
    echo "Creating globals.css for $service..."
    
    cat > "apps/$service/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --background: #ffffff;
  --foreground: #171717;
}

@media (prefers-color-scheme: dark) {
  :root {
    --background: #0a0a0a;
    --foreground: #ededed;
  }
}

body {
  color: var(--foreground);
  background: var(--background);
  font-family: Arial, Helvetica, sans-serif;
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
EOF
    
    echo "✅ globals.css created for $service"
done

echo ""
echo "6️⃣ Clearing Next.js caches..."

# Clear all caches
for service in "${services[@]}"; do
    echo "Clearing cache for $service..."
    rm -rf "apps/$service/.next"
    rm -rf "apps/$service/node_modules/.cache"
done

echo "✅ Caches cleared"

echo ""
echo "7️⃣ Reinstalling dependencies to ensure everything is fresh..."

# Reinstall dependencies in each service
for service in "${services[@]}"; do
    echo "Reinstalling dependencies for $service..."
    cd "apps/$service"
    npm install
    cd ../..
done

echo ""
echo "8️⃣ Creating a test script to verify Tailwind is working..."

cat > test-tailwind.sh << 'EOF'
#!/bin/bash

echo "🧪 Testing Tailwind CSS compilation..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Testing $service..."
    cd "apps/$service"
    
    # Test Tailwind compilation
    npx tailwindcss -i ./src/app/globals.css -o ./test-output.css --content "./src/**/*.{js,ts,jsx,tsx}" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ $service Tailwind compilation successful"
        rm -f test-output.css
    else
        echo "❌ $service Tailwind compilation failed"
    fi
    
    cd ../..
done
EOF

chmod +x test-tailwind.sh

echo ""
echo "🎉 Tailwind CSS and PostCSS configuration fixed!"
echo ""
echo "✅ What was fixed:"
echo "  - Installed latest compatible versions of tailwindcss, postcss, autoprefixer"
echo "  - Created proper PostCSS configurations"
echo "  - Fixed Tailwind configurations (using .js instead of .ts)"
echo "  - Cleaned up globals.css files with working imports"
echo "  - Cleared all Next.js caches"
echo "  - Reinstalled dependencies"
echo ""
echo "🚀 Next steps:"
echo "  1. Test Tailwind compilation: ./test-tailwind.sh"
echo "  2. Start services: npm run dev"
echo "  3. Check all three services in browser"
echo ""
echo "💡 If you still see errors:"
echo "  - Make sure no services are running when you start"
echo "  - Clear browser cache completely"
echo "  - Check terminal for any remaining error messages"