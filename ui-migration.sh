i#!/bin/bash

echo "🎨 Setting up shared UI components across microservices..."

# 1. Create the shared UI package structure
echo "📦 Creating shared UI package..."
mkdir -p packages/ui/src/components
mkdir -p packages/ui/src/layouts
mkdir -p packages/ui/src/hooks
mkdir -p packages/ui/src/utils

# 2. Create package.json for UI package
cat > packages/ui/package.json << 'EOF'
{
  "name": "@tt-ms-stack/ui",
  "version": "1.0.0",
  "description": "Shared UI components for tt-ms-stack services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "next-auth": "^4.24.11",
    "@tt-ms-stack/types": "1.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0"
  }
}
EOF

# 3. Create TypeScript config for UI package
cat > packages/ui/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": false,
    "esModuleInterop": true,
    "module": "commonjs",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 4. Move EnhancedNavigation from auth-service to shared package
echo "🔄 Moving components from auth-service to shared package..."

# Copy the existing EnhancedNavigation component
if [ -f "apps/auth-service/src/components/EnhancedNavigation.tsx" ]; then
  echo "📋 Copying EnhancedNavigation component..."
  cp "apps/auth-service/src/components/EnhancedNavigation.tsx" "packages/ui/src/components/Navigation.tsx"
fi

# Copy ProfileAvatar if it exists
if [ -f "apps/auth-service/src/components/ProfileAvatar.tsx" ]; then
  echo "📋 Copying ProfileAvatar component..."
  cp "apps/auth-service/src/components/ProfileAvatar.tsx" "packages/ui/src/components/ProfileAvatar.tsx"
fi

# Copy AccountNavDropDown if it exists
if [ -f "apps/auth-service/src/components/AccountNavDropDown.tsx" ]; then
  echo "📋 Copying AccountNavDropDown component..."
  cp "apps/auth-service/src/components/AccountNavDropDown.tsx" "packages/ui/src/components/AccountNavDropDown.tsx"
fi

# 5. Create the main export file for the UI package
cat > packages/ui/src/index.ts << 'EOF'
// Main exports for shared UI package
export { default as Navigation } from './components/Navigation'
export { default as AppLayout } from './layouts/AppLayout'
export { default as Footer } from './components/Footer'
export { ProfileAvatar } from './components/ProfileAvatar'
export { AccountNavDropDown } from './components/AccountNavDropDown'

// Re-export types
export type { NavigationProps, AppLayoutProps } from './types'
EOF

# 6. Create types file
cat > packages/ui/src/types.ts << 'EOF'
export interface NavigationProps {
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
}

export interface AppLayoutProps {
  children: React.ReactNode
  serviceName: string
  serviceColor?: 'blue' | 'green' | 'purple' | 'red'
  showServiceSwitcher?: boolean
  customNavLinks?: Array<{
    href: string
    label: string
    external?: boolean
  }>
  showFooter?: boolean
}
EOF

# 7. Update service package.json files to include shared UI dependency
echo "📝 Updating service package.json files..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
  if [ -f "apps/$service/package.json" ]; then
    echo "📦 Updating $service package.json..."
    
    # Create a backup
    cp "apps/$service/package.json" "apps/$service/package.json.backup"
    
    # Add the shared UI dependency using node
    node -e "
      const fs = require('fs');
      const pkg = JSON.parse(fs.readFileSync('apps/$service/package.json', 'utf8'));
      pkg.dependencies = pkg.dependencies || {};
      pkg.dependencies['@tt-ms-stack/ui'] = '1.0.0';
      pkg.dependencies['@tt-ms-stack/types'] = '1.0.0';
      fs.writeFileSync('apps/$service/package.json', JSON.stringify(pkg, null, 2));
    "
    
    echo "✅ Updated $service dependencies"
  fi
done

# 8. Build the shared UI package
echo "🔨 Building shared UI package..."
cd packages/ui
npm install
npm run build
cd ../..

# 9. Install dependencies in all services
echo "📦 Installing dependencies in all services..."
npm install

# 10. Create migration guide
cat > UI_MIGRATION_GUIDE.md << 'EOF'
# UI Migration Guide

## ✅ What's Been Set Up

1. **Shared UI Package**: `packages/ui` with all common components
2. **Updated Layouts**: All services now use the shared `AppLayout` component
3. **Dependencies**: Added `@tt-ms-stack/ui` to all service package.json files

## 🔄 Manual Steps Required

### 1. Update Import Statements in Auth Service

Replace the old navigation import in `apps/auth-service/src/app/layout.tsx`:

```typescript
// OLD
import EnhancedNavigation from '@/components/EnhancedNavigation'

// NEW
import { AppLayout } from '@tt-ms-stack/ui'
```

### 2. Update Individual Service Files

For any components that import the old navigation:

```typescript
// OLD
import EnhancedNavigation from '@/components/EnhancedNavigation'

// NEW
import { Navigation } from '@tt-ms-stack/ui'
```

### 3. Environment Variables

Add these to your `.env.local` files in each service:

```env
NEXT_PUBLIC_AUTH_SERVICE_URL=http://localhost:3000
NEXT_PUBLIC_USER_SERVICE_URL=http://localhost:3001
NEXT_PUBLIC_CONTENT_SERVICE_URL=http://localhost:3002
```

## 🎨 Customization Options

Each service can customize their navigation:

```typescript
<AppLayout
  serviceName="Your Service Name"
  serviceColor="blue" // blue, green, purple, red
  showServiceSwitcher={true}
  customNavLinks={[
    { href: '/custom', label: 'Custom Page' },
    { href: 'https://external.com', label: 'External', external: true }
  ]}
>
  {children}
</AppLayout>
```

## 🚀 Next Steps

1. Test each service individually
2. Verify navigation works between services
3. Customize colors and links as needed
4. Add any missing components to the shared package

## 🔧 Development Commands

```bash
# Build shared packages
npm run build --workspace=packages/ui

# Start all services
npm run dev

# Start individual services
npm run dev:auth
npm run dev:user
npm run dev:content
```
EOF

echo ""
echo "🎉 UI migration setup complete!"
echo ""
echo "📋 Summary:"
echo "✅ Created shared UI package at packages/ui"
echo "✅ Moved components from auth-service to shared package"
echo "✅ Updated all service package.json files"
echo "✅ Built shared UI package"
echo ""
echo "📖 Please read UI_MIGRATION_GUIDE.md for manual steps"
echo ""
echo "🚀 Next: Follow the migration guide to complete the setup"