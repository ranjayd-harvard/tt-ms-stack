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
