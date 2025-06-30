import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
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
          <AppLayout
            serviceName="User Service"
            serviceColor="green"
            showServiceSwitcher={true}
            customNavLinks={[
              { href: '/', label: 'Home' },
              { href: '/about', label: 'About' },
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