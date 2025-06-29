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
