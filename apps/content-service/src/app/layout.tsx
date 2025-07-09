import '@tt-ms-stack/ui/src/styles/globals.css'
import { Inter } from 'next/font/google'
import { AppLayout } from '@tt-ms-stack/ui'

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
    <html lang="en">
      <body className={inter.className}>
        <AppLayout 
          serviceName="Content Service"
          serviceColor="purple"
          showServiceSwitcher={true}
          customNavLinks={[
            { href: '/articles', label: 'Articles' },
            { href: '/media', label: 'Media' },
            { href: '/categories', label: 'Categories' },
            { href: '/analytics', label: 'Analytics' },
          ]}
        >
          {children}
        </AppLayout>
      </body>
    </html>
  )
}
