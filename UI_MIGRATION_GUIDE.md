# UI Migration Guide

## ✅ What's Been Set Up

1. **Shared UI Package**: `packages/ui` with all common components
2. **Updated Layouts**: All services now use the shared `AppLayout` component
3. **Dependencies**: Added `@tt-ms-stack/ui` to all service package.json files

## 🔄 Manual Steps Required

### 1. Update Import Statements in Auth Service

Replace the old navigation import in `apps/auth-service/src/app/layout.tsx`:

```typescript
// OLD
import EnhancedNavigation from '@/components/EnhancedNavigation'

// NEW
import { AppLayout } from '@tt-ms-stack/ui'
```

### 2. Update Individual Service Files

For any components that import the old navigation:

```typescript
// OLD
import EnhancedNavigation from '@/components/EnhancedNavigation'

// NEW
import { Navigation } from '@tt-ms-stack/ui'
```

### 3. Environment Variables

Add these to your `.env.local` files in each service:

```env
NEXT_PUBLIC_AUTH_SERVICE_URL=http://localhost:3000
NEXT_PUBLIC_USER_SERVICE_URL=http://localhost:3001
NEXT_PUBLIC_CONTENT_SERVICE_URL=http://localhost:3002
```

## 🎨 Customization Options

Each service can customize their navigation:

```typescript
<AppLayout
  serviceName="Your Service Name"
  serviceColor="blue" // blue, green, purple, red
  showServiceSwitcher={true}
  customNavLinks={[
    { href: '/custom', label: 'Custom Page' },
    { href: 'https://external.com', label: 'External', external: true }
  ]}
>
  {children}
</AppLayout>
```

## 🚀 Next Steps

1. Test each service individually
2. Verify navigation works between services
3. Customize colors and links as needed
4. Add any missing components to the shared package

## 🔧 Development Commands

```bash
# Build shared packages
npm run build --workspace=packages/ui

# Start all services
npm run dev

# Start individual services
npm run dev:auth
npm run dev:user
npm run dev:content
```
