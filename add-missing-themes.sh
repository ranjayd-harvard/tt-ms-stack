#!/bin/bash

echo "🎨 Adding missing theme classes to your project..."

echo ""
echo "1️⃣ Creating comprehensive themed CSS for all services..."

# Create the enhanced globals.css with all theme classes
cat > enhanced-globals-with-themes.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* ============================================
   BASE CSS VARIABLES & DESIGN TOKENS
   ============================================ */
:root {
  --background: #ffffff;
  --foreground: #171717;
  
  /* Base design system colors */
  --border: 214.3 31.8% 91.4%;
  --input: 214.3 31.8% 91.4%;
  --ring: 221.2 83.2% 53.3%;
  --radius: 0.75rem;
  
  /* Default theme colors */
  --primary: 221.2 83.2% 53.3%;
  --primary-foreground: 210 40% 98%;
  --secondary: 210 40% 96%;
  --secondary-foreground: 222.2 84% 4.9%;
  --muted: 210 40% 96%;
  --muted-foreground: 215.4 16.3% 46.9%;
  --accent: 210 40% 96%;
  --accent-foreground: 222.2 84% 4.9%;
  --destructive: 0 84.2% 60.2%;
  --destructive-foreground: 210 40% 98%;
  --card: 0 0% 100%;
  --card-foreground: 222.2 84% 4.9%;
  --popover: 0 0% 100%;
  --popover-foreground: 222.2 84% 4.9%;
}

@media (prefers-color-scheme: dark) {
  :root {
    --background: #0a0a0a;
    --foreground: #ededed;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 94.1%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 84% 4.9%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
  }
}

/* ============================================
   SERVICE-SPECIFIC THEME CLASSES
   ============================================ */

/* AUTH SERVICE THEME - Blue */
.auth-theme {
  --primary: 221.2 83.2% 53.3%;        /* Blue */
  --primary-foreground: 210 40% 98%;
  --secondary: 210 40% 96%;
  --accent: 210 40% 96%;
  --service-color: #3b82f6;             /* For direct usage */
}

/* USER SERVICE THEME - Green */
.user-theme {
  --primary: 142.1 76.2% 36.3%;        /* Green */
  --primary-foreground: 355.7 100% 97.3%;
  --secondary: 138 76% 97%;
  --accent: 138 76% 97%;
  --service-color: #10b981;             /* For direct usage */
}

/* CONTENT SERVICE THEME - Purple */
.content-theme {
  --primary: 262.1 83.3% 57.8%;        /* Purple */
  --primary-foreground: 210 40% 98%;
  --secondary: 270 95% 98%;
  --accent: 270 95% 98%;
  --service-color: #8b5cf6;             /* For direct usage */
}

/* Dark mode variants for each theme */
.auth-theme.dark {
  --primary: 217.2 91.2% 59.8%;
  --primary-foreground: 222.2 84% 4.9%;
  --secondary: 217.2 32.6% 17.5%;
  --accent: 217.2 32.6% 17.5%;
}

.user-theme.dark {
  --primary: 142.1 70.6% 45.3%;
  --primary-foreground: 144.9 80.4% 10%;
  --secondary: 144.9 60.4% 12%;
  --accent: 144.9 60.4% 12%;
}

.content-theme.dark {
  --primary: 263.4 70% 50.4%;
  --primary-foreground: 210 40% 98%;
  --secondary: 263 45% 15%;
  --accent: 263 45% 15%;
}

/* ============================================
   BASE STYLING
   ============================================ */
* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

body {
  background: var(--background);
  color: var(--foreground);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  margin: 0;
}

a {
  color: inherit;
  text-decoration: none;
}

button {
  font-family: inherit;
}

/* ============================================
   COMPONENT STYLING
   ============================================ */

/* Enhanced styling for dashboard cards */
.dashboard-card {
  background: hsl(var(--card));
  color: hsl(var(--card-foreground));
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  border: 1px solid hsl(var(--border));
  transition: all 0.2s;
}

.dashboard-card:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  transform: translateY(-1px);
}

.card-icon {
  width: 48px;
  height: 48px;
  background: hsl(var(--accent));
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px auto;
  font-size: 24px;
  color: hsl(var(--accent-foreground));
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: hsl(var(--card-foreground));
  text-align: center;
  margin-bottom: 8px;
}

.card-description {
  font-size: 14px;
  color: hsl(var(--muted-foreground));
  text-align: center;
  line-height: 1.5;
  margin-bottom: 20px;
}

.card-button {
  background: hsl(var(--primary));
  color: hsl(var(--primary-foreground));
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: block;
  margin: 0 auto;
}

.card-button:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

/* Service-specific button colors */
.auth-theme .card-button {
  background: #3b82f6;
}

.auth-theme .card-button:hover {
  background: #2563eb;
}

.user-theme .card-button {
  background: #10b981;
}

.user-theme .card-button:hover {
  background: #059669;
}

.content-theme .card-button {
  background: #8b5cf6;
}

.content-theme .card-button:hover {
  background: #7c3aed;
}

/* Grid layout */
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin: 32px 0;
}

/* Main content styling */
.main-content {
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px;
  background: hsl(var(--background));
  min-height: calc(100vh - 64px);
}

.page-title {
  font-size: 30px;
  font-weight: 700;
  color: hsl(var(--foreground));
  text-align: center;
  margin-bottom: 32px;
}

.welcome-message {
  text-align: center;
  font-size: 16px;
  color: hsl(var(--muted-foreground));
  margin-top: 32px;
}

/* ============================================
   ANIMATIONS & UTILITIES
   ============================================ */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.animate-shake {
  animation: shake 0.5s ease-in-out;
}

/* Service indicator utilities */
.service-indicator {
  position: relative;
}

.service-indicator::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 4px;
  height: 100%;
  border-radius: 0 2px 2px 0;
}

.auth-theme .service-indicator::before {
  background: #3b82f6;
}

.user-theme .service-indicator::before {
  background: #10b981;
}

.content-theme .service-indicator::before {
  background: #8b5cf6;
}

/* Responsive utilities */
@media (max-width: 768px) {
  .nav-links,
  .service-switcher {
    display: none;
  }
  
  .nav-container {
    padding: 0 1rem;
  }
  
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
  
  .main-content {
    padding: 16px;
  }
}

/* Focus styles for accessibility */
@layer base {
  button:focus-visible,
  a:focus-visible {
    outline: 2px solid hsl(var(--ring));
    outline-offset: 2px;
  }
}

/* Custom utilities */
@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}

/* Loading spinner */
.spinner {
  border: 2px solid hsl(var(--muted));
  border-top: 2px solid hsl(var(--primary));
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
EOF

echo ""
echo "2️⃣ Applying the enhanced CSS to all services..."

# Apply to all services
services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Updating $service with themed CSS..."
    
    # Backup existing CSS
    if [ -f "apps/$service/src/app/globals.css" ]; then
        cp "apps/$service/src/app/globals.css" "apps/$service/src/app/globals.css.backup"
    fi
    
    # Apply the new CSS
    cp enhanced-globals-with-themes.css "apps/$service/src/app/globals.css"
    
    echo "✅ $service CSS updated with themes"
done

# Clean up temp file
rm enhanced-globals-with-themes.css

echo ""
echo "3️⃣ Updating layout files to use the theme classes..."

# Update auth-service layout
if [ -f "apps/auth-service/src/app/layout.tsx" ]; then
    echo "Updating auth-service layout..."
    
    # Backup existing layout
    cp "apps/auth-service/src/app/layout.tsx" "apps/auth-service/src/app/layout.tsx.backup"
    
    # Check if it already has theme classes
    if ! grep -q "auth-theme" "apps/auth-service/src/app/layout.tsx"; then
        cat > temp_auth_layout.tsx << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Auth Service - TT-MS-Stack',
  description: 'Authentication microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="auth-theme">
      <body className={`${inter.className} auth-theme`}>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  )
}
EOF
        
        # Only replace if file exists and is different
        if [ -f "apps/auth-service/src/app/layout.tsx" ]; then
            mv temp_auth_layout.tsx "apps/auth-service/src/app/layout.tsx"
            echo "✅ Auth service layout updated with auth-theme"
        else
            echo "⚠️ Auth service layout not found, skipping"
            rm temp_auth_layout.tsx
        fi
    else
        echo "✅ Auth service layout already has theme classes"
    fi
fi

# Update user-service layout
if [ -f "apps/user-service/src/app/layout.tsx" ]; then
    echo "Updating user-service layout..."
    
    # Backup existing layout
    cp "apps/user-service/src/app/layout.tsx" "apps/user-service/src/app/layout.tsx.backup"
    
    # Update to include user-theme
    if ! grep -q "user-theme" "apps/user-service/src/app/layout.tsx"; then
        cat > temp_user_layout.tsx << 'EOF'
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
    <html lang="en" className="user-theme">
      <body className={`${inter.className} user-theme`}>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  )
}
EOF
        
        if [ -f "apps/user-service/src/app/layout.tsx" ]; then
            mv temp_user_layout.tsx "apps/user-service/src/app/layout.tsx"
            echo "✅ User service layout updated with user-theme"
        else
            echo "⚠️ User service layout not found, skipping"
            rm temp_user_layout.tsx
        fi
    else
        echo "✅ User service layout already has theme classes"
    fi
fi

# Update content-service layout
if [ -f "apps/content-service/src/app/layout.tsx" ]; then
    echo "Updating content-service layout..."
    
    # Backup existing layout
    cp "apps/content-service/src/app/layout.tsx" "apps/content-service/src/app/layout.tsx.backup"
    
    # Update to include content-theme
    if ! grep -q "content-theme" "apps/content-service/src/app/layout.tsx"; then
        cat > temp_content_layout.tsx << 'EOF'
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
    <html lang="en" className="content-theme">
      <body className={`${inter.className} content-theme`}>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  )
}
EOF
        
        if [ -f "apps/content-service/src/app/layout.tsx" ]; then
            mv temp_content_layout.tsx "apps/content-service/src/app/layout.tsx"
            echo "✅ Content service layout updated with content-theme"
        else
            echo "⚠️ Content service layout not found, skipping"
            rm temp_content_layout.tsx
        fi
    else
        echo "✅ Content service layout already has theme classes"
    fi
fi

echo ""
echo "4️⃣ Creating test pages to verify themes work..."

# Create theme test pages for each service
for service in "${services[@]}"; do
    case $service in
        "auth-service")
            theme_name="Auth"
            theme_class="auth-theme"
            color="blue"
            ;;
        "user-service") 
            theme_name="User"
            theme_class="user-theme"
            color="green"
            ;;
        "content-service")
            theme_name="Content"
            theme_class="content-theme"
            color="purple"
            ;;
    esac
    
    # Create theme test page
    mkdir -p "apps/$service/src/app/theme-test"
    cat > "apps/$service/src/app/theme-test/page.tsx" << EOF
export default function ThemeTestPage() {
  return (
    <div className="main-content">
      <h1 className="page-title">$theme_name Service Theme Test</h1>
      
      <div className="dashboard-grid">
        <div className="dashboard-card">
          <div className="card-icon">🎨</div>
          <h3 className="card-title">Theme Demonstration</h3>
          <p className="card-description">
            This card shows the $color theme in action. Notice the colors automatically
            match the service theme.
          </p>
          <button className="card-button">
            $theme_name Themed Button
          </button>
        </div>
        
        <div className="dashboard-card service-indicator">
          <div className="card-icon">🔧</div>
          <h3 className="card-title">CSS Variables</h3>
          <p className="card-description">
            The theme uses CSS variables that automatically change colors
            based on the .$theme_class class.
          </p>
          <button className="card-button">
            Test Variables
          </button>
        </div>
        
        <div className="dashboard-card">
          <div className="card-icon">✨</div>
          <h3 className="card-title">Consistent Design</h3>
          <p className="card-description">
            All services share the same components and layout, but with
            different color schemes.
          </p>
          <button className="card-button">
            See Consistency
          </button>
        </div>
      </div>
      
      <div className="welcome-message">
        <p>Visit this page on other services to see different color themes!</p>
        <p>
          <strong>Auth Service:</strong> Blue theme |
          <strong>User Service:</strong> Green theme |
          <strong>Content Service:</strong> Purple theme
        </p>
      </div>
    </div>
  )
}
EOF
    
    echo "✅ Created theme test page for $service"
done

echo ""
echo "🎉 Theme classes successfully added!"
echo ""
echo "📋 What was created:"
echo "✅ auth-theme class (blue colors)"
echo "✅ user-theme class (green colors)" 
echo "✅ content-theme class (purple colors)"
echo "✅ Dark mode variants for all themes"
echo "✅ Updated layout files to use theme classes"
echo "✅ Enhanced CSS with proper design tokens"
echo "✅ Test pages at /theme-test for each service"
echo ""
echo "🚀 Next steps:"
echo "1. Run 'npm run dev' to start all services"
echo "2. Visit /theme-test on each service to see the themes:"
echo "   • Auth: http://localhost:3000/theme-test (Blue)"
echo "   • User: http://localhost:3001/theme-test (Green)" 
echo "   • Content: http://localhost:3002/theme-test (Purple)"
echo "3. Start using themed components with .dashboard-card, .card-button, etc."