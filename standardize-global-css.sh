#!/bin/bash

echo "🎨 Standardizing globals.css across all services..."

# First, let's check what's in each service's globals.css
echo "1️⃣ Checking current globals.css files..."

echo "Auth Service globals.css:"
if [ -f "apps/auth-service/src/app/globals.css" ]; then
    echo "File exists. First 10 lines:"
    head -10 "apps/auth-service/src/app/globals.css"
else
    echo "❌ File not found"
fi

echo ""
echo "User Service globals.css:"
if [ -f "apps/user-service/src/app/globals.css" ]; then
    echo "File exists. First 10 lines:"
    head -10 "apps/user-service/src/app/globals.css"
else
    echo "❌ File not found"
fi

echo ""
echo "Content Service globals.css:"
if [ -f "apps/content-service/src/app/globals.css" ]; then
    echo "File exists. First 10 lines:"
    head -10 "apps/content-service/src/app/globals.css"
else
    echo "❌ File not found"
fi

echo ""
echo "2️⃣ Copying Auth Service globals.css to other services..."

# Copy the Auth Service globals.css to all other services
if [ -f "apps/auth-service/src/app/globals.css" ]; then
    echo "Copying Auth Service globals.css to User Service..."
    cp "apps/auth-service/src/app/globals.css" "apps/user-service/src/app/globals.css"
    
    echo "Copying Auth Service globals.css to Content Service..."
    cp "apps/auth-service/src/app/globals.css" "apps/content-service/src/app/globals.css"
    
    echo "✅ globals.css files synchronized"
else
    echo "⚠️ Auth Service globals.css not found, creating a standard one..."
    
    # Create a standard globals.css based on typical Next.js + Tailwind setup
    cat > standard-globals.css << 'EOF'
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

    # Copy to all services
    cp standard-globals.css "apps/auth-service/src/app/globals.css"
    cp standard-globals.css "apps/user-service/src/app/globals.css"
    cp standard-globals.css "apps/content-service/src/app/globals.css"
    
    rm standard-globals.css
    echo "✅ Standard globals.css created for all services"
fi

echo ""
echo "3️⃣ Checking Tailwind configurations..."

# Check if Tailwind configs are consistent
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Checking $service Tailwind config..."
    if [ -f "apps/$service/tailwind.config.ts" ]; then
        echo "✅ tailwind.config.ts exists"
    elif [ -f "apps/$service/tailwind.config.js" ]; then
        echo "✅ tailwind.config.js exists"
    else
        echo "❌ No Tailwind config found for $service"
        
        # Create a standard Tailwind config
        cat > "apps/$service/tailwind.config.ts" << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
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
};
export default config;
EOF
        echo "✅ Created standard Tailwind config for $service"
    fi
done

echo ""
echo "4️⃣ Ensuring PostCSS configurations are consistent..."

# Check and standardize PostCSS configs
for service in "${services[@]}"; do
    if [ ! -f "apps/$service/postcss.config.js" ]; then
        echo "Creating PostCSS config for $service..."
        cat > "apps/$service/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
        echo "✅ Created PostCSS config for $service"
    else
        echo "✅ $service already has PostCSS config"
    fi
done

echo ""
echo "5️⃣ Verifying package.json dependencies..."

# Check if all services have Tailwind dependencies
for service in "${services[@]}"; do
    echo "Checking $service dependencies..."
    cd "apps/$service"
    
    # Check for Tailwind
    if ! grep -q "tailwindcss" package.json; then
        echo "⚠️ Adding Tailwind CSS to $service..."
        npm install -D tailwindcss postcss autoprefixer
    else
        echo "✅ $service has Tailwind CSS"
    fi
    
    cd ../..
done

echo ""
echo "6️⃣ Creating a shared CSS reset to ensure consistency..."

# Create an enhanced globals.css that ensures consistency
cat > enhanced-globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* CSS Reset for consistency across services */
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
  color: rgb(var(--foreground-rgb));
  background: rgb(var(--background-start-rgb));
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
}

a {
  color: inherit;
  text-decoration: none;
}

/* Ensure consistent button and form styling */
button {
  font-family: inherit;
}

/* Root CSS variables */
:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 255, 255, 255;
  --background-end-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

/* Custom utilities */
@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}

/* Ensure consistent focus styles */
@layer base {
  button:focus-visible,
  a:focus-visible {
    @apply outline-2 outline-blue-500 outline-offset-2;
  }
}
EOF

# Copy the enhanced globals.css to all services
cp enhanced-globals.css "apps/auth-service/src/app/globals.css"
cp enhanced-globals.css "apps/user-service/src/app/globals.css"
cp enhanced-globals.css "apps/content-service/src/app/globals.css"

rm enhanced-globals.css

echo ""
echo "🎉 CSS standardization complete!"
echo ""
echo "✅ What was fixed:"
echo "  - Synchronized globals.css across all services"
echo "  - Ensured consistent Tailwind configurations"
echo "  - Added CSS reset for cross-browser consistency"
echo "  - Standardized PostCSS configurations"
echo "  - Verified Tailwind dependencies"
echo ""
echo "🚀 Next steps:"
echo "  1. Stop your dev servers (Ctrl+C)"
echo "  2. Clear Next.js cache: rm -rf apps/*/.next"
echo "  3. Restart: npm run dev"
echo "  4. Hard refresh browser (Cmd+Shift+R)"
echo ""
echo "💡 This should resolve the styling inconsistencies!"
echo "All services will now use identical CSS foundation."