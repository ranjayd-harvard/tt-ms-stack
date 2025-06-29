#!/bin/bash

echo "🚀 Setting up tt-ms-stack development environment..."

# Check current directory
echo "📍 Current directory: $(pwd)"
echo "📁 Directory contents:"
ls -la

# Install root dependencies
echo ""
echo "📦 Installing root dependencies..."
if [ -f "package.json" ]; then
    npm install
    echo "✅ Root dependencies installed"
else
    echo "❌ Root package.json not found"
    exit 1
fi

# Build shared packages
echo ""
echo "🔨 Building shared packages..."

# Build types package
if [ -d "packages/types" ]; then
    echo "📦 Building types package..."
    cd packages/types
    if [ -f "package.json" ]; then
        npm install
        if [ -f "tsconfig.json" ]; then
            npm run build
            echo "✅ Types package built successfully"
        else
            echo "⚠️  No tsconfig.json found for types package"
        fi
    else
        echo "⚠️  No package.json found for types package"
    fi
    cd ../..
else
    echo "⚠️  Types package not found at packages/types"
fi

# Build auth-client package
if [ -d "packages/auth-client" ]; then
    echo "📦 Building auth-client package..."
    cd packages/auth-client
    if [ -f "package.json" ]; then
        npm install
        if [ -f "tsconfig.json" ]; then
            npm run build
            echo "✅ Auth-client package built successfully"
        else
            echo "⚠️  No tsconfig.json found for auth-client package"
        fi
    else
        echo "⚠️  No package.json found for auth-client package"
    fi
    cd ../..
else
    echo "⚠️  Auth-client package not found at packages/auth-client"
fi

# Install service dependencies
echo ""
echo "📦 Installing service dependencies..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    if [ -d "apps/$service" ]; then
        echo "📦 Installing $service dependencies..."
        cd "apps/$service"
        if [ -f "package.json" ]; then
            npm install
            echo "✅ $service dependencies installed"
        else
            echo "❌ No package.json found for $service"
        fi
        cd ../..
    else
        echo "⚠️  Service $service not found at apps/$service"
    fi
done

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Summary:"
echo "✅ Root dependencies installed"
echo "✅ Shared packages built (if they exist)"
echo "✅ Service dependencies installed (if services exist)"
echo ""
echo "🚀 Next steps:"
echo "1. Run 'npm run dev' to start all services"
echo "2. If services don't exist yet, follow the migration guide"
echo "3. Create shared packages if they don't exist yet"