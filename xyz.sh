# 1. Clean everything
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf packages/*/node_modules
rm -rf apps/*/.next

# 2. Create the CSS directory in UI package
mkdir -p packages/ui/src/styles

# 3. Rebuild UI package
cd packages/ui
npm install
npm run build
cd ../..

# 4. Reinstall all dependencies
npm install

# 5. Try building auth-service again
cd apps/auth-service
npm run build