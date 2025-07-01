// apps/auth-service/src/app/layout.tsx
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'
import { AppLayout } from '@tt-ms-stack/ui'
import { Navigation }  from '@tt-ms-stack/ui'
import './globals.css';

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