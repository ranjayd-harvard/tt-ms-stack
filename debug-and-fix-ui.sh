#!/bin/bash

echo "🔍 Debugging UI issues..."

# First, let's check if the shared UI package is actually built and accessible
echo "1️⃣ Checking shared UI package status..."

if [ -d "packages/ui/dist" ]; then
    echo "✅ UI package dist folder exists"
    ls -la packages/ui/dist/
else
    echo "❌ UI package not built! Building now..."
    cd packages/ui
    npm run build
    cd ../..
fi

# Check if services have the dependency installed
echo ""
echo "2️⃣ Checking service dependencies..."

for service in "user-service" "content-service"; do
    echo "Checking $service..."
    if [ -f "apps/$service/package.json" ]; then
        if grep -q "@tt-ms-stack/ui" "apps/$service/package.json"; then
            echo "✅ $service has UI dependency"
        else
            echo "❌ $service missing UI dependency - adding it"
            cd "apps/$service"
            npm install ../../packages/ui
            cd ../..
        fi
    fi
done

# Check current layout files
echo ""
echo "3️⃣ Checking current layout files..."

echo "User Service layout:"
if [ -f "apps/user-service/src/app/layout.tsx" ]; then
    echo "File exists. First 10 lines:"
    head -10 "apps/user-service/src/app/layout.tsx"
else
    echo "❌ Layout file not found"
fi

echo ""
echo "Content Service layout:"
if [ -f "apps/content-service/src/app/layout.tsx" ]; then
    echo "File exists. First 10 lines:"
    head -10 "apps/content-service/src/app/layout.tsx"
else
    echo "❌ Layout file not found"
fi

# Now let's completely replace the layout files
echo ""
echo "4️⃣ Completely replacing layout files..."

# BACKUP existing files
cp apps/user-service/src/app/layout.tsx apps/user-service/src/app/layout.tsx.backup 2>/dev/null
cp apps/content-service/src/app/layout.tsx apps/content-service/src/app/layout.tsx.backup 2>/dev/null

# Create new User Service layout
cat > apps/user-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

// Import the shared UI components
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'User Service - TT-MS-Stack',
  description: 'User management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <AppLayout
            serviceName="User Service"
            serviceColor="green"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/users', label: 'Users' },
              { href: '/roles', label: 'Roles' },
              { href: '/permissions', label: 'Permissions' }
            ]}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Create new Content Service layout
cat > apps/content-service/src/app/layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

// Import the shared UI components
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Content Service - TT-MS-Stack',
  description: 'Content management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <AppLayout
            serviceName="Content Service"
            serviceColor="purple"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/articles', label: 'Articles' },
              { href: '/media', label: 'Media' },
              { href: '/categories', label: 'Categories' },
              { href: '/analytics', label: 'Analytics' }
            ]}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo "✅ Layout files updated"

# Install dependencies to make sure everything is linked
echo ""
echo "5️⃣ Installing/updating dependencies..."
npm install

# Try building the services to check for errors
echo ""
echo "6️⃣ Testing builds..."

cd apps/user-service
echo "Testing User Service build..."
npm run build 2>&1 | head -20
cd ../..

cd apps/content-service  
echo "Testing Content Service build..."
npm run build 2>&1 | head -20
cd ../..

echo ""
echo "🎉 Debug and fix complete!"
echo ""
echo "🚀 Next steps:"
echo "1. Stop all running services (Ctrl+C in terminal)"
echo "2. Restart with: npm run dev"
echo "3. Hard refresh browser (Cmd+Shift+R or Ctrl+Shift+R)"
echo "4. Check all three services"
echo ""
echo "If still not working, run this debug command:"
echo "node -e \"console.log(require.resolve('@tt-ms-stack/ui'))\""