#!/bin/bash

echo "🔍 Verifying shared UI imports..."

# Test if the UI package can be imported
echo "1️⃣ Testing UI package import..."

# Create a simple test file
cat > test-import.js << 'EOF'
try {
  const ui = require('@tt-ms-stack/ui');
  console.log('✅ UI package imports successfully');
  console.log('Available exports:', Object.keys(ui));
} catch (error) {
  console.log('❌ UI package import failed:', error.message);
}
EOF

node test-import.js
rm test-import.js

# Check if the packages are linked properly in the workspace
echo ""
echo "2️⃣ Checking workspace linking..."
npm ls @tt-ms-stack/ui 2>/dev/null || echo "❌ UI package not found in workspace"

# If the above fails, let's try a different approach - direct installation
echo ""
echo "3️⃣ Alternative: Installing UI package directly..."

cd apps/user-service
echo "Installing UI in user-service..."
npm install file:../../packages/ui
cd ../..

cd apps/content-service
echo "Installing UI in content-service..."
npm install file:../../packages/ui
cd ../..

echo ""
echo "4️⃣ Final verification - checking package.json files..."

echo "User Service dependencies:"
grep -A 5 -B 5 "@tt-ms-stack/ui" apps/user-service/package.json || echo "Not found"

echo "Content Service dependencies:"
grep -A 5 -B 5 "@tt-ms-stack/ui" apps/content-service/package.json || echo "Not found"

echo ""
echo "✅ Import verification complete!"
echo ""
echo "🔄 Now restart your services with: npm run dev"