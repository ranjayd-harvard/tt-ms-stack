#!/bin/bash

echo "🧪 Testing Tailwind CSS compilation..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Testing $service..."
    cd "apps/$service"
    
    # Test Tailwind compilation
    npx tailwindcss -i ./src/app/globals.css -o ./test-output.css --content "./src/**/*.{js,ts,jsx,tsx}" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ $service Tailwind compilation successful"
        rm -f test-output.css
    else
        echo "❌ $service Tailwind compilation failed"
    fi
    
    cd ../..
done
