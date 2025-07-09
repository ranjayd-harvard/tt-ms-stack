import '@tt-ms-stack/ui/src/styles/globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'

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
          <AppLayout
              serviceName="User Service"
              serviceColor="green"
              showServiceSwitcher={true}
              customNavLinks={[
                { href: '/users', label: 'Users' },
                { href: '/roles', label: 'Roles' }
              ]}
              showFooter={false}
            >
              {children}
          </AppLayout>
        </AuthProvider>
      </body>
    </html>
  )
}
