#!/bin/bash

echo "🔧 Fixing workspace configuration issues..."

# First, let's check npm version
echo "📋 Checking npm version:"
npm --version

# Check Node version
echo "📋 Checking Node version:"
node --version

echo ""
echo "🎯 The issue is with workspace syntax compatibility."
echo "Let's fix the package.json files to use proper workspace syntax."

echo ""
echo "1️⃣ Fixing root package.json..."

# Create a compatible root package.json
cat > package.json << 'EOF'
{
  "name": "tt-ms-stack",
  "version": "1.0.0",
  "description": "TypeScript Microservices Stack",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "concurrently \"npm run dev:auth\" \"npm run dev:user\" \"npm run dev:content\"",
    "dev:auth": "cd apps/auth-service && npm run dev",
    "dev:user": "cd apps/user-service && npm run dev", 
    "dev:content": "cd apps/content-service && npm run dev",
    "build": "npm run build --workspaces --if-present",
    "build:auth": "cd apps/auth-service && npm run build",
    "build:user": "cd apps/user-service && npm run build",
    "build:content": "cd apps/content-service && npm run build",
    "test": "npm run test --workspaces --if-present",
    "lint": "npm run lint --workspaces --if-present",
    "clean": "npm run clean --workspaces --if-present && rm -rf node_modules",
    "install:all": "npm install",
    "docker:up": "cd infrastructure/docker && docker-compose up --build",
    "docker:down": "cd infrastructure/docker && docker-compose down",
    "docker:logs": "cd infrastructure/docker && docker-compose logs -f",
    "setup": "./scripts/setup.sh",
    "deploy:dev": "./scripts/deploy-dev.sh",
    "deploy:prod": "./scripts/deploy-prod.sh"
  },
  "devDependencies": {
    "concurrently": "^7.6.0",
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
EOF

echo "✅ Root package.json updated"

echo ""
echo "2️⃣ Fixing packages/types/package.json..."

# Create types package
mkdir -p packages/types/src

cat > packages/types/package.json << 'EOF'
{
  "name": "@tt-ms-stack/types",
  "version": "1.0.0",
  "description": "Shared TypeScript types for tt-ms-stack",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
EOF

cat > packages/types/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

cat > packages/types/src/index.ts << 'EOF'
// Shared types for tt-ms-stack

export interface AuthUser {
  id: string
  email?: string | null
  name?: string | null
  image?: string | null
  registerSource?: string
  groupId?: string
  hasLinkedAccounts?: boolean
  services?: any
}

export interface AuthResponse {
  authenticated: boolean
  user?: AuthUser
  error?: string
}

export interface ServiceResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  timestamp: string
}

export interface PaginatedResponse<T> {
  items: T[]
  total: number
  page: number
  limit: number
  hasMore: boolean
}

export interface MicroserviceConfig {
  name: string
  port: number
  authServiceUrl: string
  databaseUrl?: string
  requiredPermissions?: string[]
}
EOF

echo "✅ Types package created"

echo ""
echo "3️⃣ Fixing packages/auth-client/package.json..."

# Create auth-client package
mkdir -p packages/auth-client/src

cat > packages/auth-client/package.json << 'EOF'
{
  "name": "@tt-ms-stack/auth-client",
  "version": "1.0.0",
  "description": "Shared authentication client for tt-ms-stack services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "next-auth": "^4.24.11"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0"
  }
}
EOF

cat > packages/auth-client/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

cat > packages/auth-client/src/index.ts << 'EOF'
// Main exports for auth client
export { AuthClient } from './auth-client'
export type { AuthUser, AuthResponse } from './auth-client'
export { withAuth } from './middleware'
export * from './utils'
EOF

echo "✅ Auth-client package structure created"

echo ""
echo "4️⃣ Creating minimal auth-client implementation..."

cat > packages/auth-client/src/auth-client.ts << 'EOF'
import { getToken } from 'next-auth/jwt'
import { NextRequest } from 'next/server'

export interface AuthUser {
  id: string
  email?: string | null
  name?: string | null
  image?: string | null
  registerSource?: string
  groupId?: string
  hasLinkedAccounts?: boolean
  services?: any
}

export interface AuthResponse {
  authenticated: boolean
  user?: AuthUser
  error?: string
}

export class AuthClient {
  private authServiceUrl: string
  private secret: string

  constructor(authServiceUrl?: string, secret?: string) {
    this.authServiceUrl = authServiceUrl || process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
    this.secret = secret || process.env.NEXTAUTH_SECRET || ''
  }

  async verifyTokenLocal(req: NextRequest): Promise<AuthResponse> {
    try {
      const token = await getToken({
        req,
        secret: this.secret,
      })

      if (!token) {
        return { authenticated: false, error: 'No valid token' }
      }

      return {
        authenticated: true,
        user: {
          id: token.id as string,
          email: token.email,
          name: token.name,
          image: token.picture,
          registerSource: token.registerSource as string,
          groupId: token.groupId as string,
          hasLinkedAccounts: token.hasLinkedAccounts as boolean,
          services: token.services,
        }
      }
    } catch (error) {
      console.error('Local token verification failed:', error)
      return { authenticated: false, error: 'Token verification failed' }
    }
  }
}
EOF

cat > packages/auth-client/src/middleware.ts << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { AuthClient } from './auth-client'
import type { AuthUser } from './auth-client'

export async function withAuth(
  req: NextRequest, 
  callback: (req: NextRequest, user: AuthUser) => Promise<Response>
): Promise<Response> {
  const authClient = new AuthClient()
  
  try {
    const authResult = await authClient.verifyTokenLocal(req)
    
    if (!authResult.authenticated) {
      return new Response(
        JSON.stringify({ error: 'Authentication required' }),
        { 
          status: 401,
          headers: { 'Content-Type': 'application/json' }
        }
      )
    }

    return await callback(req, authResult.user!)
  } catch (error) {
    console.error('Auth middleware error:', error)
    return new Response(
      JSON.stringify({ error: 'Authentication failed' }),
      { 
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      }
    )
  }
}
EOF

cat > packages/auth-client/src/utils.ts << 'EOF'
export function useAuthRedirect() {
  const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'

  const redirectToAuth = (callbackUrl?: string) => {
    const callback = callbackUrl || window.location.href
    window.location.href = `${authServiceUrl}/auth/signin?callbackUrl=${encodeURIComponent(callback)}`
  }

  const redirectToSignOut = () => {
    window.location.href = `${authServiceUrl}/auth/signout`
  }

  return {
    redirectToAuth,
    redirectToSignOut,
  }
}

export interface ServiceResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  timestamp: string
}

export function createServiceResponse<T>(
  success: boolean, 
  data?: T, 
  error?: string
): ServiceResponse<T> {
  return {
    success,
    data,
    error,
    timestamp: new Date().toISOString(),
  }
}
EOF

echo "✅ Auth-client implementation created"

echo ""
echo "5️⃣ Now let's clean up and reinstall everything..."

# Clean up node_modules
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf packages/*/node_modules

echo "✅ Cleaned up node_modules"

echo ""
echo "📦 Installing dependencies with proper workspace syntax..."

# Install dependencies
npm install

echo ""
echo "🎉 Fixed! Now let's test the setup..."