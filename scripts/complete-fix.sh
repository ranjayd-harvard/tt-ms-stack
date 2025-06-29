#!/bin/bash

echo "🔍 Finding and fixing all workspace:* references..."

# Find all package.json files that contain workspace: syntax
echo "📋 Files with workspace references:"
find . -name "package.json" -exec grep -l "workspace:" {} \; 2>/dev/null

echo ""
echo "🔧 Removing workspace dependencies from all files..."

# Remove workspace dependencies from all package.json files
find . -name "package.json" -exec sed -i.bak '/workspace:/d' {} \;
find . -name "package.json" -exec sed -i.bak 's/"@tt-ms-stack\/[^"]*": "workspace:\*",\?//g' {} \;

# Remove backup files
find . -name "*.bak" -delete

echo "✅ Removed all workspace: references"

# Clean everything
echo "🧹 Cleaning up..."
rm -rf node_modules apps/*/node_modules packages/*/node_modules
rm -f package-lock.json apps/*/package-lock.json packages/*/package-lock.json

# Install fresh
echo "📦 Installing fresh dependencies..."
npm install

echo "✅ Setup complete! No more workspace errors."
