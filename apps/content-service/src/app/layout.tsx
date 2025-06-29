import './globals.css'
import { Inter } from 'next/font/google'
import { AuthProvider } from './providers/auth-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Content Service',
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
          <header className="bg-green-600 text-white p-4">
            <div className="container mx-auto flex justify-between items-center">
              <h1 className="text-xl font-bold">Content Service</h1>
              <nav className="space-x-4">
                <a href="http://localhost:3000" className="hover:underline">Auth Service</a>
                <a href="http://localhost:3001" className="hover:underline">User Service</a>
              </nav>
            </div>
          </header>
          <main className="container mx-auto p-4">
            {children}
          </main>
        </AuthProvider>
      </body>
    </html>
  )
}
