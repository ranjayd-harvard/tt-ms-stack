import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone',
  images: {
    domains: ['localhost', 'auth-service', 'lh3.googleusercontent.com', 'avatars.githubusercontent.com'],
  },
  async redirects() {
    return [
      {
        source: '/auth/signin',
        destination: `${process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000'}/auth/sign-in`,
        permanent: false,
      },
    ]
  },
  async rewrites() {
    return [
      {
        source: '/api/auth/:path*',
        destination: `${process.env.AUTH_SERVICE_URL || 'http://localhost:3000'}/api/auth/:path*`,
      },
    ]
  },
}

export default nextConfig;