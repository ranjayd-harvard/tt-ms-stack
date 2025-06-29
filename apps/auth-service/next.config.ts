import type { NextConfig } from "next";


const nextConfig: NextConfig = {
  eslint: {
    // Warning: This allows production builds to successfully complete even if
    // your project has ESLint errors.
    ignoreDuringBuilds: true,
  },
  // Enable standalone output for Docker - THIS IS THE KEY ADDITION
  output: 'standalone',
  experimental: {
    // your existing config
  },
  images: {
    domains: ['lh3.googleusercontent.com', 'avatars.githubusercontent.com','ui-avatars.com'],
  },
  // // Optional: Webpack configuration for Docker compatibility
  // webpack: (config, { isServer }) => {
  //   // Handle specific packages that might need special treatment in Docker
  //   if (!isServer) {
  //     config.resolve.fallback = {
  //       ...config.resolve.fallback,
  //       fs: false,
  //       net: false,
  //       tls: false,
  //     };
  //   }
  //   return config;
  // },

  // // Optional: Environment variables that should be available at runtime
  // env: {
  //   NEXTAUTH_URL: process.env.NEXTAUTH_URL,
  // },  
}

export default nextConfig;
