#!/bin/bash

echo "🔧 Fixing UI Package Resolution in Monorepo"
echo "==========================================="

# 1. Fix the UI package.json to have proper exports and dependencies
echo "1️⃣ Fixing UI package configuration..."

cat > "packages/ui/package.json" << 'EOF'
{
  "name": "@tt-ms-stack/ui",
  "version": "1.0.0",
  "description": "Shared UI components for tt-ms-stack services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "require": "./dist/index.js",
      "import": "./dist/index.js"
    }
  },
  "files": ["dist", "src"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "peerDependencies": {
    "next": ">=15.0.0",
    "react": ">=19.0.0",
    "react-dom": ">=19.0.0",
    "next-auth": "^4.24.11"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.1.11",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "postcss": "^8.5.6",
    "tailwindcss": "^4.1.11",
    "typescript": "^5"
  }
}
EOF

echo "✅ UI package.json updated"

# 2. Create a proper index.ts that exports what your components need
echo "2️⃣ Creating proper exports for UI package..."

cat > "packages/ui/src/index.ts" << 'EOF'
// Main exports for shared UI package
export { default as AppLayout } from './layouts/AppLayout'
export { default as Navigation } from './components/Navigation'
export { default as Footer } from './components/Footer'
export { default as ServiceSwitcher } from './components/ServiceSwitcher'
export { default as UserMenu } from './components/UserMenu'
export { default as TopRightMenu } from './components/TopRightMenu'
export { default as EnhancedNavigation } from './components/EnhancedNavigation'

// Export types if they exist
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

echo "✅ UI package exports created"

# 3. Update service package.json files to reference UI package correctly
echo "3️⃣ Updating service package.json files..."

# Auth Service - update dependency reference
echo "Updating auth-service package.json..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('apps/auth-service/package.json', 'utf8'));
pkg.dependencies = pkg.dependencies || {};
pkg.dependencies['@tt-ms-stack/ui'] = 'file:../../packages/ui';
pkg.dependencies['@tt-ms-stack/types'] = 'file:../../packages/types';
fs.writeFileSync('apps/auth-service/package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Auth service package.json updated');
"

# User Service
echo "Updating user-service package.json..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('apps/user-service/package.json', 'utf8'));
pkg.dependencies = pkg.dependencies || {};
pkg.dependencies['@tt-ms-stack/ui'] = 'file:../../packages/ui';
pkg.dependencies['@tt-ms-stack/types'] = 'file:../../packages/types';
fs.writeFileSync('apps/user-service/package.json', JSON.stringify(pkg, null, 2));
console.log('✅ User service package.json updated');
"

# Content Service
echo "Updating content-service package.json..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('apps/content-service/package.json', 'utf8'));
pkg.dependencies = pkg.dependencies || {};
pkg.dependencies['@tt-ms-stack/ui'] = 'file:../../packages/ui';
pkg.dependencies['@tt-ms-stack/types'] = 'file:../../packages/types';
fs.writeFileSync('apps/content-service/package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Content service package.json updated');
"

echo "✅ All service package.json files updated"

# 4. Build the UI package
echo "4️⃣ Building UI package..."

cd packages/ui

# Install dependencies in UI package
echo "Installing UI package dependencies..."
npm install

# Build the UI package
echo "Building UI package..."
npm run build

cd ../..

echo "✅ UI package built"

# 5. Install dependencies in all services
echo "5️⃣ Installing dependencies in all services..."

# Clean and reinstall everything
rm -rf node_modules
rm -rf apps/*/node_modules  
rm -rf packages/*/node_modules

# Install from root (this will handle the workspace dependencies)
npm install

echo "✅ Dependencies installed"

# 6. Clear build caches
echo "6️⃣ Clearing build caches..."

rm -rf apps/*/.next
rm -rf packages/*/dist/.next

echo "✅ Caches cleared"

echo ""
echo "🎉 UI Package Resolution Fixed!"
echo "==============================="
echo ""
echo "What was fixed:"
echo "✅ UI package.json with proper exports"
echo "✅ Services now reference UI package correctly" 
echo "✅ Dependencies installed properly"
echo "✅ UI package built with latest code"
echo "✅ All caches cleared"
echo ""
echo "🚀 Next steps:"
echo "1. Run: npm run build"
echo "2. If successful, run: npm run dev"
echo ""
echo "💡 The services should now find @tt-ms-stack/ui correctly!"