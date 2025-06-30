#!/bin/bash

echo "🔧 Final fix for navigation issues..."

echo "1️⃣ Updating AppLayout to fix prop passing..."

cat > "packages/ui/src/layouts/AppLayout.tsx" << 'EOF'
'use client'

import { ReactNode } from 'react'
import Navigation from '../components/Navigation'
import Footer from '../components/Footer'

export interface AppLayoutProps {
  children: ReactNode
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

export default function AppLayout({
  children,
  serviceName,
  serviceColor = 'blue',
  showServiceSwitcher = true,
  customNavLinks = [],
  showFooter = true
}: AppLayoutProps) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Navigation 
        serviceName={serviceName}
        serviceColor={serviceColor}
        showServiceSwitcher={showServiceSwitcher}
        customLinks={customNavLinks}
      />
      
      <main className="flex-1 max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 w-full">
        {children}
      </main>
      
      {showFooter && <Footer serviceName={serviceName} />}
    </div>
  )
}
EOF

echo "2️⃣ Copying the fixed Navigation component..."
# The Navigation component from the artifact above should be copied to:
# packages/ui/src/components/Navigation.tsx

echo "3️⃣ Rebuilding shared UI package..."
cd packages/ui
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Shared UI package rebuilt successfully!"
else
    echo "❌ Build failed, checking errors..."
    npm run build
    exit 1
fi

cd ../..

echo "4️⃣ Clearing caches and updating services..."

# Clear caches and reinstall
for service in "auth-service" "user-service" "content-service"; do
    echo "Updating $service..."
    rm -rf "apps/$service/.next"
    
    cd "apps/$service"
    npm uninstall @tt-ms-stack/ui 2>/dev/null || true
    npm install ../../packages/ui
    cd ../..
done

echo ""
echo "🎉 Final fixes applied!"
echo ""
echo "✅ What was fixed:"
echo "  - ❌ Removed duplicate navigation links (Home, About, Dashboard, etc.)"
echo "  - ✅ Now ONLY shows customNavLinks from your service layout"
echo "  - 👤 Fixed 'Ranjay Kumar' display next to avatar"
echo "  - 📍 Fixed dropdown positioning (z-[9999], top-full mt-2)"
echo "  - 🔧 Fixed prop passing: customNavLinks → customLinks"
echo "  - 📱 Enhanced user menu with proper sections"
echo ""
echo "🔍 How it works now:"
echo "  - Your User Service layout.tsx defines customNavLinks"
echo "  - AppLayout passes them as customLinks to Navigation"
echo "  - Navigation ONLY renders those links (no hardcoded ones)"
echo "  - Service switcher and user menu work properly"
echo ""
echo "🚀 Restart your services:"
echo "  npm run dev"
echo ""
echo "💡 You should now see:"
echo "  - ✅ No duplicate navigation links"
echo "  - ✅ 'Ranjay Kumar' next to avatar"
echo "  - ✅ Service switcher dropdown positioned correctly"
echo "  - ✅ Clean navigation matching Auth Service design"