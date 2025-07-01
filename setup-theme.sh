#!/bin/bash

echo "🎨 Setting up shadcn/ui theme across all microservices..."

# Configuration
services=("auth-service" "user-service" "content-service")

echo ""
echo "1️⃣ Installing shadcn/ui in shared UI package..."

# First, enhance the shared UI package with shadcn/ui
cd packages/ui

# Install required dependencies
npm install class-variance-authority clsx tailwind-merge lucide-react
npm install -D @types/react @types/react-dom

# Create components.json for shadcn/ui configuration
cat > components.json << 'EOF'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "src/styles/globals.css",
    "baseColor": "slate",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "./src/components",
    "utils": "./src/lib/utils"
  }
}
EOF

# Create utility functions
mkdir -p src/lib
cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

# Create the base CSS file with design tokens
mkdir -p src/styles
cat > src/styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
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
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.75rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
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
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 94.1%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
EOF

# Create Tailwind config for the UI package
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
  plugins: [require("tailwindcss-animate")],
}
EOF

cd ../..

echo ""
echo "2️⃣ Installing dependencies in each microservice..."

for service in "${services[@]}"; do
    echo "Setting up $service..."
    cd "apps/$service"
    
    # Install shadcn/ui related dependencies
    npm install class-variance-authority clsx tailwind-merge lucide-react @radix-ui/react-slot
    npm install -D tailwindcss-animate
    
    # Update package.json to include the shared UI package
    node -e "
      const fs = require('fs');
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      pkg.dependencies = pkg.dependencies || {};
      pkg.dependencies['@tt-ms-stack/ui'] = '1.0.0';
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
    "
    
    cd ../..
done

echo ""
echo "3️⃣ Creating base shadcn/ui components in shared package..."

cd packages/ui

# Create the Button component
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

# Create the Card component
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

# Update the main index.ts to export all components
cat > src/index.ts << 'EOF'
// UI Components
export * from './components/ui/button'
export * from './components/ui/card'

// Layout Components
export { default as AppLayout } from './layouts/AppLayout'
export { default as Navigation } from './components/Navigation'

// Utility Functions
export { cn } from './lib/utils'

// Styles
export './styles/globals.css'
EOF

cd ../..

echo ""
echo "4️⃣ Updating Tailwind configs in all services..."

for service in "${services[@]}"; do
    echo "Updating Tailwind config for $service..."
    
    # Copy the enhanced Tailwind config to each service
    cp packages/ui/tailwind.config.js "apps/$service/tailwind.config.js"
    
    # Update the content paths for each service
    sed -i 's|"./src/\*\*/\*\.{js,ts,jsx,tsx,mdx}"|"./src/**/*.{js,ts,jsx,tsx,mdx}", "../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}"|g' "apps/$service/tailwind.config.js"
done

echo ""
echo "5️⃣ Creating themed layouts for each service..."

for service in "${services[@]}"; do
    echo "Creating themed layout for $service..."
    
    # Determine service color based on name
    case $service in
        "auth-service")
            color="blue"
            ;;
        "user-service") 
            color="green"
            ;;
        "content-service")
            color="purple"
            ;;
        *)
            color="slate"
            ;;
    esac
    
    # Create a themed page example
    mkdir -p "apps/$service/src/app/themed-example"
    cat > "apps/$service/src/app/themed-example/page.tsx" << EOF
import { Button } from '@tt-ms-stack/ui'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@tt-ms-stack/ui'

export default function ThemedExamplePage() {
  return (
    <div className="container mx-auto py-8">
      <div className="space-y-6">
        <div>
          <h1 className="text-4xl font-bold tracking-tight">$service Theme Example</h1>
          <p className="text-lg text-muted-foreground">
            Demonstrating the consistent design system across microservices
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card>
            <CardHeader>
              <CardTitle>Component Showcase</CardTitle>
              <CardDescription>
                All services use the same design tokens and components
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button className="w-full">Primary Button</Button>
              <Button variant="outline" className="w-full">
                Outline Button
              </Button>
              <Button variant="secondary" className="w-full">
                Secondary Button
              </Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Service Colors</CardTitle>
              <CardDescription>
                Each service can have its own accent color while maintaining consistency
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                <div className="w-full h-8 bg-primary rounded"></div>
                <div className="w-full h-8 bg-secondary rounded"></div>
                <div className="w-full h-8 bg-accent rounded"></div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Typography</CardTitle>
              <CardDescription>
                Consistent typography across all services
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-2">
              <h1 className="text-2xl font-bold">Heading 1</h1>
              <h2 className="text-xl font-semibold">Heading 2</h2>
              <p className="text-sm text-muted-foreground">
                Body text with muted foreground
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
EOF

done

echo ""
echo "6️⃣ Building the shared UI package..."
cd packages/ui
npm run build
cd ../..

echo ""
echo "7️⃣ Installing dependencies across the monorepo..."
npm install

echo ""
echo "🎉 Theme implementation complete!"
echo ""
echo "📋 Summary:"
echo "✅ Set up shadcn/ui design system in shared UI package"
echo "✅ Created consistent design tokens and CSS variables"
echo "✅ Added base UI components (Button, Card)"
echo "✅ Updated Tailwind configs across all services"
echo "✅ Created themed example pages for each service"
echo ""
echo "🚀 Next steps:"
echo "1. Visit /themed-example on each service to see the consistent theme"
echo "2. Import components from '@tt-ms-stack/ui' in your pages"
echo "3. Add more shadcn/ui components as needed"
echo "4. Customize the color scheme in the CSS variables"
echo ""
echo "📖 Available components:"
echo "- Button (with variants: default, outline, secondary, ghost, link)"
echo "- Card (with Header, Content, Footer, Title, Description)"
echo "- More components can be added using: npx shadcn-ui@latest add <component-name>"