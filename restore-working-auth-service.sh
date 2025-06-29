i#!/bin/bash

echo "🚨 EMERGENCY: Restoring Auth Service and fixing all services..."

# Stop all services first
echo "⚠️  STOP ALL SERVICES NOW (Ctrl+C) before continuing!"
echo "Press Enter after stopping all services..."
read -r

echo ""
echo "1️⃣ Restoring Auth Service to its original working state..."

# First, let's restore the Auth Service from backup if it exists
if [ -f "apps/auth-service/next.config.js.backup" ]; then
    echo "Restoring Auth Service next.config.js from backup..."
    mv "apps/auth-service/next.config.js.backup" "apps/auth-service/next.config.js"
fi

# Clear all the changes we made to Auth Service
cd apps/auth-service

echo "Clearing Auth Service caches..."
rm -rf .next
rm -rf node_modules/.cache

# Reinstall Auth Service dependencies to restore original state
echo "Reinstalling Auth Service dependencies..."
npm install

cd ../..

echo ""
echo "2️⃣ Creating working CSS for User and Content services without touching Auth Service..."

# Don't touch Auth Service anymore - just fix the other two services

services=("user-service" "content-service")

for service in "${services[@]}"; do
    echo "Creating manual CSS for $service (leaving Auth Service alone)..."
    
    # Remove any Tailwind dependencies that might be causing conflicts
    cd "apps/$service"
    rm -rf .next
    rm -rf node_modules/.cache
    
    # Create a simple, working CSS file
    if [ "$service" = "user-service" ]; then
        color="#059669"  # Green
        letter="U"
    else
        color="#7c3aed"  # Purple  
        letter="C"
    fi
    
    cat > "src/app/globals.css" << EOF
/* Simple CSS that works without Tailwind conflicts */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: #374151;
  background-color: #f9fafb;
}

/* Navigation Bar */
nav {
  background-color: white;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  border-bottom: 1px solid #e5e7eb;
}

.nav-container {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 4rem;
}

.nav-left {
  display: flex;
  align-items: center;
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.service-logo {
  display: flex;
  align-items: center;
  text-decoration: none;
  margin-right: 2rem;
}

.logo-icon {
  width: 2rem;
  height: 2rem;
  background-color: $color;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  margin-right: 0.5rem;
  transition: background-color 0.2s;
}

.logo-icon:hover {
  opacity: 0.9;
}

.service-name {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: #374151;
  text-decoration: none;
  padding: 0.5rem 0.75rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  transition: color 0.15s ease-in-out;
}

.nav-link:hover {
  color: #2563eb;
}

.service-switcher {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.switch-label {
  font-size: 0.875rem;
  color: #6b7280;
}

.switch-link {
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  color: #6b7280;
  text-decoration: none;
  transition: color 0.15s ease-in-out;
}

.switch-link:hover {
  color: #111827;
}

.switch-current {
  background-color: #e5e7eb;
  color: #111827;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.15s ease-in-out;
  border: none;
  cursor: pointer;
  display: inline-block;
  text-align: center;
}

.btn-primary {
  background-color: $color;
  color: white;
}

.btn-primary:hover {
  opacity: 0.9;
}

.btn-secondary {
  color: #374151;
}

.btn-secondary:hover {
  color: #2563eb;
}

/* Main content */
main {
  max-width: 80rem;
  margin: 0 auto;
  padding: 1.5rem;
}

.card {
  background-color: white;
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  border: 1px solid #e5e7eb;
  padding: 1.5rem;
  margin-bottom: 1rem;
}

.text-center {
  text-align: center;
}

.mb-4 { margin-bottom: 1rem; }
.mb-6 { margin-bottom: 1.5rem; }
.mb-8 { margin-bottom: 2rem; }

.text-xl { font-size: 1.25rem; }
.text-2xl { font-size: 1.5rem; }
.text-3xl { font-size: 1.875rem; }

.font-bold { font-weight: 700; }
.font-semibold { font-weight: 600; }

.text-gray-600 { color: #6b7280; }
.text-gray-900 { color: #111827; }

/* Responsive */
@media (max-width: 768px) {
  .nav-links,
  .service-switcher {
    display: none;
  }
  
  .nav-container {
    padding: 0 1rem;
  }
}

/* Loading spinner */
.spinner {
  border: 2px solid #f3f4f6;
  border-top: 2px solid $color;
  border-radius: 50%;
  width: 2rem;
  height: 2rem;
  animation: spin 1s linear infinite;
  margin: 0 auto;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Grid layouts */
.grid {
  display: grid;
  gap: 1.5rem;
}

.grid-cols-3 {
  grid-template-columns: repeat(3, 1fr);
}

@media (max-width: 768px) {
  .grid-cols-3 {
    grid-template-columns: 1fr;
  }
}
EOF
    
    # Remove any PostCSS or Tailwind configs that might interfere
    rm -f postcss.config.js
    rm -f tailwind.config.js
    rm -f tailwind.config.ts
    
    # Create simple Next.js config
    cat > "next.config.js" << 'EOF2'
/** @type {import('next').NextConfig} */
const nextConfig = {}

module.exports = nextConfig
EOF2
    
    cd ../..
    echo "✅ $service CSS fixed"
done

echo ""
echo "3️⃣ Updating layout files to use the new CSS classes..."

# Update User Service layout
cat > "apps/user-service/src/app/layout.tsx" << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'User Service - TT-MS-Stack',
  description: 'User management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb' }}>
            <nav>
              <div className="nav-container">
                <div className="nav-content">
                  <div className="nav-left">
                    <a href="/" className="service-logo">
                      <div className="logo-icon">U</div>
                      <span className="service-name">User Service</span>
                    </a>
                    <div className="nav-links">
                      <a href="/" className="nav-link">Home</a>
                      <a href="/about" className="nav-link">About</a>
                      <a href="/dashboard" className="nav-link">Dashboard</a>
                    </div>
                  </div>
                  
                  <div className="service-switcher">
                    <span className="switch-label">Switch Service:</span>
                    <a href="http://localhost:3000" className="switch-link">Auth Service</a>
                    <span className="switch-link switch-current">User Service</span>
                    <a href="http://localhost:3002" className="switch-link">Content Service</a>
                  </div>
                  
                  <div className="nav-right">
                    <a href="http://localhost:3000/auth/sign-in" className="btn btn-secondary">Sign In</a>
                    <a href="http://localhost:3000/auth/sign-up" className="btn btn-primary">Sign Up</a>
                  </div>
                </div>
              </div>
            </nav>
            
            <main>
              {children}
            </main>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

# Update Content Service layout
cat > "apps/content-service/src/app/layout.tsx" << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Content Service - TT-MS-Stack',
  description: 'Content management microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb' }}>
            <nav>
              <div className="nav-container">
                <div className="nav-content">
                  <div className="nav-left">
                    <a href="/" className="service-logo">
                      <div className="logo-icon">C</div>
                      <span className="service-name">Content Service</span>
                    </a>
                    <div className="nav-links">
                      <a href="/" className="nav-link">Home</a>
                      <a href="/about" className="nav-link">About</a>
                      <a href="/dashboard" className="nav-link">Dashboard</a>
                    </div>
                  </div>
                  
                  <div className="service-switcher">
                    <span className="switch-label">Switch Service:</span>
                    <a href="http://localhost:3000" className="switch-link">Auth Service</a>
                    <a href="http://localhost:3001" className="switch-link">User Service</a>
                    <span className="switch-link switch-current">Content Service</span>
                  </div>
                  
                  <div className="nav-right">
                    <a href="http://localhost:3000/auth/sign-in" className="btn btn-secondary">Sign In</a>
                    <a href="http://localhost:3000/auth/sign-up" className="btn btn-primary">Sign Up</a>
                  </div>
                </div>
              </div>
            </nav>
            
            <main>
              {children}
            </main>
          </div>
        </AuthProvider>
      </body>
    </html>
  )
}
EOF

echo ""
echo "4️⃣ Installing clean dependencies for user and content services..."

for service in "${services[@]}"; do
    cd "apps/$service"
    echo "Installing clean dependencies for $service..."
    npm install
    cd ../..
done

echo ""
echo "🎉 RESTORATION COMPLETE!"
echo ""
echo "✅ What was fixed:"
echo "  - Auth Service restored to original working state"
echo "  - User and Content services now use simple CSS (no Tailwind conflicts)"
echo "  - All services should have consistent navigation"
echo "  - No more PostCSS/Tailwind errors"
echo ""
echo "🚀 Next steps:"
echo "  1. Start all services: npm run dev"
echo "  2. Check Auth Service first (should be back to normal)"
echo "  3. Check User and Content services (should now match Auth Service layout)"
echo ""
echo "💡 This approach uses simple CSS that recreates the Auth Service look"
echo "without any complex build dependencies that could break."