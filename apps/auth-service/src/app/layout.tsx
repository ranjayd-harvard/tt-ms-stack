import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/Providers'
import { AppLayout } from '@tt-ms-stack/ui'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Auth Service',
  description: 'Authentication microservice',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          <AppLayout
              serviceName="Auth Service"
              serviceColor="blue"
              showServiceSwitcher={true}
              customNavLinks={[
                { href: '/dashboard', label: 'Dashboard' },
                { href: '/admin', label: 'Admin Panel' }
              ]}
              showFooter={false}
            >
              {children}
          </AppLayout>
        </Providers>
      </body>
    </html>
  )
}
