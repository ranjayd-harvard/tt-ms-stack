#!/bin/bash
echo "🚀 Deploying tt-ms-stack to development..."

# Build all packages
npm run build

# Deploy with Docker Compose
npm run docker:up

echo "✅ Development deployment complete!"
echo "🌐 Services available at:"
echo "   Auth Service: http://localhost:3000"
echo "   User Service: http://localhost:3001"
echo "   Content Service: http://localhost:3002"