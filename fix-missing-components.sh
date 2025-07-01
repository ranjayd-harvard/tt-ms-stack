#!/bin/bash

echo "🔧 Fixing missing shadcn/ui components in shared UI package..."

echo ""
echo "1️⃣ Adding missing dependencies to UI package..."

cd packages/ui

# Install missing dependencies for shadcn/ui components
npm install @radix-ui/react-slot class-variance-authority clsx tailwind-merge

echo "✅ Dependencies installed"

echo ""
echo "2️⃣ Creating missing shadcn/ui components..."

# Create utils function first
mkdir -p src/lib
cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

# Create Button component
mkdir -p src/components/ui
cat > src/components/ui/button.tsx << 'EOF'
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "../../lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
        outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-9 px-4 py-2",
        sm: "h-8 rounded-md px-3 text-xs",
        lg: "h-10 rounded-md px-8",
        icon: "h-9 w-9",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
EOF

# Create Card component
cat > src/components/ui/card.tsx << 'EOF'
import * as React from "react"
import { cn } from "../../lib/utils"

const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "rounded-lg border bg-card text-card-foreground shadow-sm",
      className
    )}
    {...props}
  />
))
Card.displayName = "Card"

const CardHeader = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("flex flex-col space-y-1.5 p-6", className)} {...props} />
))
CardHeader.displayName = "CardHeader"

const CardTitle = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLHeadingElement>
>(({ className, ...props }, ref) => (
  <h3
    ref={ref}
    className={cn("font-semibold leading-none tracking-tight", className)}
    {...props}
  />
))
CardTitle.displayName = "CardTitle"

const CardDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, ...props }, ref) => (
  <p ref={ref} className={cn("text-sm text-muted-foreground", className)} {...props} />
))
CardDescription.displayName = "CardDescription"

const CardContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
))
CardContent.displayName = "CardContent"

const CardFooter = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("flex items-center p-6 pt-0", className)} {...props} />
))
CardFooter.displayName = "CardFooter"

export { Card, CardHeader, CardFooter, CardTitle, CardDescription, CardContent }
EOF

echo "✅ shadcn/ui components created"

echo ""
echo "3️⃣ Updating package.json with new dependencies..."

# Update package.json to include new dependencies
cat > package.json << 'EOF'
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
  "peerDependencies": {
    "next": ">=14.0.0",
    "react": ">=18.0.0",
    "react-dom": ">=18.0.0",
    "next-auth": "^4.24.11"
  },
  "dependencies": {
    "@radix-ui/react-slot": "^1.0.2",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^19",
    "@types/react-dom": "^19"
  }
}
EOF

echo "✅ Package.json updated"

echo ""
echo "4️⃣ Updating index.ts to export all components..."

# Update the main index.ts to export everything
cat > src/index.ts << 'EOF'
// UI Components
export * from './components/ui/button'
export * from './components/ui/card'

// Layout Components
export { default as AppLayout } from './layouts/AppLayout'
export { default as Navigation } from './components/Navigation'
export { default as Footer } from './components/Footer'

// Utility Functions
export { cn } from './lib/utils'

// Export types
export type { AppLayoutProps } from './layouts/AppLayout'
EOF

echo "✅ Exports updated"

echo ""
echo "5️⃣ Updating Tailwind config to include shadcn/ui design tokens..."

# Update tailwind config with proper shadcn/ui setup
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [],
}
EOF

echo "✅ Tailwind config updated"

echo ""
echo "6️⃣ Installing dependencies and building..."

npm install

echo "✅ Dependencies installed"

echo ""
echo "7️⃣ Building the UI package..."

npm run build

if [ $? -eq 0 ]; then
    echo "✅ UI package built successfully"
else
    echo "❌ Build failed. Checking for issues..."
    
    # Try to identify the issue
    echo "Checking TypeScript compilation..."
    npx tsc --noEmit
    
    echo "❌ Build failed. Please check the errors above."
    cd ../..
    exit 1
fi

cd ../..

echo ""
echo "8️⃣ Installing updated UI package in all services..."

npm install

echo ""
echo "9️⃣ Testing component exports..."

# Test that components can be imported (just check syntax)
echo "Testing import syntax..."

cat > test-imports.js << 'EOF'
// Test file to verify exports
try {
  const ui = require('./packages/ui/dist/index.js');
  console.log('✅ Available exports:', Object.keys(ui));
  
  if (ui.Button) console.log('✅ Button component exported');
  if (ui.Card) console.log('✅ Card component exported');
  if (ui.CardHeader) console.log('✅ CardHeader component exported');
  if (ui.AppLayout) console.log('✅ AppLayout component exported');
  if (ui.Footer) console.log('✅ Footer component exported');
} catch (error) {
  console.log('❌ Import test failed:', error.message);
}
EOF

node test-imports.js
rm test-imports.js

echo ""
echo "🎉 Component fix complete!"
echo ""
echo "📋 Summary:"
echo "✅ Added missing shadcn/ui components (Button, Card, etc.)"
echo "✅ Installed required dependencies"
echo "✅ Updated exports in index.ts"
echo "✅ Enhanced Tailwind config with design tokens"
echo "✅ Rebuilt UI package successfully"
echo ""
echo "🚀 Now you can use these components:"
echo "import { Button, Card, CardHeader, CardTitle, CardContent } from '@tt-ms-stack/ui'"
echo ""
echo "🔄 Next steps:"
echo "1. Run 'npm run build' in each service to verify imports work"
echo "2. Test your /themed-example pages"
echo "3. The components should now work without import errors!"