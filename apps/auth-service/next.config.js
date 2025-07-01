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
}

module.exports = nextConfig
