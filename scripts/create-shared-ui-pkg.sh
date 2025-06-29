#!/bin/bash

# Create shared UI package structure
mkdir -p packages/ui/src/components
mkdir -p packages/ui/src/layouts
mkdir -p packages/ui/src/hooks
mkdir -p packages/ui/src/utils

# Create package.json for UI package
cat > packages/ui/package.json << 'EOF'
{
  "name": "@tt-ms-stack/ui",
  "version": "1.0.0",
  "description": "Shared UI components for tt-ms-stack services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "next-auth": "^4.24.11",
    "@tt-ms-stack/types": "1.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0"
  }
}
EOF

# Create TypeScript config
cat > packages/ui/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": false,
    "esModuleInterop": true,
    "module": "commonjs",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

echo "✅ Shared UI package structure created!"
echo "📁 Next: Move your components from auth-service to packages/ui/src/components"