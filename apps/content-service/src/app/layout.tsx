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
