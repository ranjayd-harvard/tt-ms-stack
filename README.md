# tt-ms-stack

TypeScript Microservices Stack - A modern, scalable microservices architecture built with Next.js and NextAuth.

## Architecture

- **Auth Service** (Port 3000) - Central authentication service
- **User Service** (Port 3001) - User management and profiles  
- **Content Service** (Port 3002) - Content management system

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd tt-ms-stack

# Setup development environment
npm run setup

# Start all services
npm run dev

# Or use Docker
npm run docker:up