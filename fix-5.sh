#!/bin/bash

echo "🔧 Fixing dropdown positioning to show below navigation..."

echo "1️⃣ Updating Navigation component with proper dropdown positioning..."

# The key changes made in the Navigation component:
# - Changed nav from "relative z-50" to just "relative"
# - Added inline style { top: '100%', zIndex: 50 } to dropdowns
# - Removed z-[9999] class and used inline zIndex instead
# - Ensured dropdowns use "absolute right-0 mt-2"

echo "2️⃣ Rebuilding shared UI package..."
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

echo "3️⃣ Force updating User Service..."
cd apps/user-service
rm -rf .next
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

echo "4️⃣ Also updating Content Service..."
cd apps/content-service  
rm -rf .next
npm uninstall @tt-ms-stack/ui
npm install ../../packages/ui
cd ../..

echo ""
echo "🎉 Dropdown positioning fixed!"
echo ""
echo "✅ What was fixed:"
echo "  - 📍 Dropdowns now use inline style positioning"
echo "  - 🔽 top: '100%' ensures dropdowns appear below buttons"
echo "  - 🎯 zIndex: 50 ensures proper stacking"
echo "  - 📱 Removed conflicting CSS classes"
echo ""
echo "🔍 Technical changes:"
echo "  - Navigation: className='relative' (simplified)"
echo "  - Dropdowns: style={{ top: '100%', zIndex: 50 }}"
echo "  - Removed z-[9999] class conflicts"
echo "  - Maintained 'absolute right-0 mt-2' positioning"
echo ""
echo "🚀 Restart your services:"
echo "  npm run dev"
echo ""
echo "💡 The dropdowns should now appear properly below the buttons!"
echo "Both Service Switcher and User Menu dropdowns should be fully visible."