// apps/content-service/src/app/layout.tsx
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
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
          <AppLayout
            serviceName="Content Service"
            serviceColor="purple"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/', label: 'Home' },
              { href: '/dashboard', label: 'Dashboard' },
              { href: '/admin', label: 'Admin Panel' }
            ]}
            showFooter={true}
          >
            {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}