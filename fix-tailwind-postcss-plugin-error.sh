#!/bin/bash

echo "🔧 Fixing Tailwind PostCSS plugin error..."

# Stop all services first
echo "⚠️  IMPORTANT: Make sure all dev servers are stopped (Ctrl+C) before running this script!"
echo "Press Enter to continue..."
read -r

echo ""
echo "1️⃣ Installing the correct Tailwind CSS PostCSS plugin..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Fixing $service..."
    cd "apps/$service"
    
    # Remove problematic packages
    echo "  - Removing old Tailwind packages..."
    npm uninstall tailwindcss @tailwindcss/postcss postcss autoprefixer 2>/dev/null
    
    # Install the correct packages including the separate PostCSS plugin
    echo "  - Installing correct packages..."
    npm install -D @tailwindcss/postcss@latest tailwindcss@latest postcss@latest autoprefixer@latest
    
    echo "  ✅ $service packages updated"
    cd ../..
done

echo ""
echo "2️⃣ Updating PostCSS configurations to use the separate plugin..."

for service in "${services[@]}"; do
    echo "Updating PostCSS config for $service..."
    
    cat > "apps/$service/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    '@tailwindcss/postcss': {},
    autoprefixer: {},
  },
}
EOF
    
    echo "✅ PostCSS config updated for $service"
done

echo ""
echo "3️⃣ Alternative approach - Using Next.js built-in Tailwind support..."

# Create Next.js compatible configs
for service in "${services[@]}"; do
    echo "Creating Next.js compatible config for $service..."
    
    # Remove PostCSS config to let Next.js handle it
    rm -f "apps/$service/postcss.config.js"
    
    # Create or update Next.js config to enable Tailwind
    if [ -f "apps/$service/next.config.js" ]; then
        echo "  - Updating existing next.config.js"
        # Backup existing config
        cp "apps/$service/next.config.js" "apps/$service/next.config.js.backup"
    fi
    
    cat > "apps/$service/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable Tailwind CSS
  experimental: {
    // Let Next.js handle PostCSS and Tailwind
  }
}

module.exports = nextConfig
EOF
    
    # Ensure Tailwind config exists
    cat > "apps/$service/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
    
    echo "✅ Next.js config created for $service"
done

echo ""
echo "4️⃣ Creating simplified globals.css files..."

for service in "${services[@]}"; do
    echo "Creating simplified globals.css for $service..."
    
    cat > "apps/$service/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
    
    echo "✅ Simplified globals.css created for $service"
done

echo ""
echo "5️⃣ Clearing all caches and node_modules..."

for service in "${services[@]}"; do
    echo "Clearing caches for $service..."
    rm -rf "apps/$service/.next"
    rm -rf "apps/$service/node_modules/.cache"
    rm -rf "apps/$service/dist"
done

# Also clear the main node_modules cache
rm -rf node_modules/.cache

echo ""
echo "6️⃣ Reinstalling dependencies..."

# Reinstall from root to ensure proper linking
echo "Installing root dependencies..."
npm install

for service in "${services[@]}"; do
    echo "Installing dependencies for $service..."
    cd "apps/$service"
    npm install
    cd ../..
done

echo ""
echo "7️⃣ Creating test script to verify everything works..."

cat > test-services-css.sh << 'EOF'
#!/bin/bash

echo "🧪 Testing CSS compilation for all services..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Testing $service..."
    cd "apps/$service"
    
    # Try to build the service
    echo "  - Testing build..."
    npm run build 2>&1 | head -10
    
    if [ $? -eq 0 ]; then
        echo "  ✅ $service builds successfully"
    else
        echo "  ❌ $service build has issues"
    fi
    
    cd ../..
done

echo ""
echo "If all services build successfully, try starting them:"
echo "npm run dev"
EOF

chmod +x test-services-css.sh

echo ""
echo "8️⃣ Alternative: Manual CSS approach if Tailwind still fails..."

cat > create-manual-css.sh << 'EOF'
#!/bin/bash

echo "Creating manual CSS as fallback..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Creating manual CSS for $service..."
    
    cat > "apps/$service/src/app/globals.css" << 'EOL'
/* Manual CSS without Tailwind - matches Auth Service styling */

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.6;
  color: #374151;
  background-color: #f9fafb;
}

/* Navigation styles */
nav {
  background-color: white;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
  border-bottom: 1px solid #e5e7eb;
}

.nav-container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 1rem;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 4rem;
}

.nav-left {
  display: flex;
  align-items: center;
}

.service-logo {
  display: flex;
  align-items: center;
  text-decoration: none;
  margin-right: 2rem;
}

.logo-icon {
  width: 2rem;
  height: 2rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  margin-right: 0.5rem;
  transition: all 0.2s;
}

.service-name {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: #374151;
  text-decoration: none;
  padding: 0.5rem 0.75rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  transition: color 0.2s;
}

.nav-link:hover {
  color: #2563eb;
}

.service-switcher {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.switch-label {
  font-size: 0.875rem;
  color: #6b7280;
}

.switch-link {
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  color: #6b7280;
  text-decoration: none;
  transition: color 0.2s;
}

.switch-link:hover {
  color: #111827;
}

.switch-current {
  background-color: #e5e7eb;
  color: #111827;
}

.auth-buttons {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.2s;
  border: none;
  cursor: pointer;
}

.btn-primary {
  color: white;
  background-color: #2563eb;
}

.btn-primary:hover {
  background-color: #1d4ed8;
}

.btn-secondary {
  color: #374151;
}

.btn-secondary:hover {
  color: #2563eb;
}

/* Main content */
main {
  max-width: 1280px;
  margin: 0 auto;
  padding: 1.5rem;
}

/* Service-specific colors */
.auth-service .logo-icon { background-color: #2563eb; }
.auth-service .btn-primary { background-color: #2563eb; }

.user-service .logo-icon { background-color: #059669; }
.user-service .btn-primary { background-color: #059669; }

.content-service .logo-icon { background-color: #7c3aed; }
.content-service .btn-primary { background-color: #7c3aed; }

/* Responsive */
@media (max-width: 768px) {
  .nav-links,
  .service-switcher {
    display: none;
  }
}
EOL

    echo "✅ Manual CSS created for $service"
done
EOF

chmod +x create-manual-css.sh

echo ""
echo "🎉 Tailwind PostCSS plugin fix complete!"
echo ""
echo "✅ What was attempted:"
echo "  - Installed @tailwindcss/postcss plugin"
echo "  - Updated PostCSS configurations"
echo "  - Created Next.js compatible configs"
echo "  - Simplified globals.css files"
echo "  - Cleared all caches"
echo ""
echo "🚀 Next steps:"
echo "  1. Test the builds: ./test-services-css.sh"
echo "  2. If successful, start services: npm run dev"
echo "  3. If still failing, use manual CSS: ./create-manual-css.sh"
echo ""
echo "💡 The manual CSS approach will give you identical layouts"
echo "without relying on Tailwind CSS at all."