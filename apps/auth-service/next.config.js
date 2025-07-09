/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable Tailwind CSS
  experimental: {
    // Let Next.js handle PostCSS and Tailwind
  },
  eslint: {
    // Warning: This allows production builds to successfully complete even if
    // your project has ESLint errors.
    ignoreDuringBuilds: true,
  },
  // Ensure proper handling of client-side code during SSR
  transpilePackages: ['next-auth'],
  // Disable static optimization for pages that use authentication
  async redirects() {
    return []
  },
  // Configure output for proper SSR
  output: 'standalone',
}

module.exports = nextConfig
