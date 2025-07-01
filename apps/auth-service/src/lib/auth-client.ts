// lib/auth-client.ts - Shared authentication client for other microservices
// Compatible with your enhanced-auth.ts configuration
import { getToken } from 'next-auth/jwt'
import { NextRequest, NextResponse } from 'next/server'

export interface AuthUser {
  id: string
  email?: string | null
  name?: string | null
  image?: string | null
  registerSource?: string
  groupId?: string
  hasLinkedAccounts?: boolean
  services?: Record<string, unknown>
}

export interface AuthResponse {
  authenticated: boolean
  user?: AuthUser
  error?: string
}

export class AuthClient {
  private authServiceUrl: string
  private secret: string

  constructor(authServiceUrl?: string, secret?: string) {
    this.authServiceUrl = authServiceUrl || process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
    this.secret = secret || process.env.NEXTAUTH_SECRET || ''
  }

  /**
   * Get the auth service URL
   */
  getAuthServiceUrl(): string {
    return this.authServiceUrl
  }

  /**
   * Verify JWT token locally (fastest)
   */
  async verifyTokenLocal(req: NextRequest): Promise<AuthResponse> {
    try {
      const token = await getToken({
        req,
        secret: this.secret,
      })

      if (!token) {
        return { authenticated: false, error: 'No valid token' }
      }

      return {
        authenticated: true,
        user: {
          id: token.id as string,
          email: token.email,
          name: token.name,
          image: token.picture,
          registerSource: token.registerSource as string,
          groupId: token.groupId as string,
          hasLinkedAccounts: token.hasLinkedAccounts as boolean,
          services: token.services as Record<string, unknown> | undefined,
        }
      }
    } catch (error) {
      return { 
        authenticated: false, 
        error: 'Token verification failed: ' + (error instanceof Error ? error.message : 'Unknown error')
      }
    }
  }

  /**
   * Verify token via auth service API (if you need fresh user data)
   */
  async verifyTokenRemote(token: string): Promise<AuthResponse> {
    try {
      const response = await fetch(`${this.authServiceUrl}/api/auth/verify`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token }),
      })

      const data = await response.json()

      if (!response.ok) {
        return { authenticated: false, error: data.error }
      }

      return {
        authenticated: data.valid,
        user: data.user,
      }
    } catch (error) {
      return { 
        authenticated: false, 
        error: 'Remote verification failed: ' + (error instanceof Error ? error.message : 'Unknown error')
      }
    }
  }

  /**
   * Get user data from auth service
   */
  async getUser(req: NextRequest): Promise<AuthResponse> {
    try {
      const token = await getToken({
        req,
        secret: this.secret,
        raw: true, // Get raw JWT
      })

      if (!token) {
        return { authenticated: false, error: 'No token' }
      }

      const response = await fetch(`${this.authServiceUrl}/api/auth/user`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Cookie': req.headers.get('cookie') || '',
        },
      })

      const data = await response.json()

      if (!response.ok) {
        return { authenticated: false, error: data.error }
      }

      return {
        authenticated: true,
        user: data.user,
      }
    } catch (error) {
      return { 
        authenticated: false, 
        error: 'Failed to get user data: ' + (error instanceof Error ? error.message : 'Unknown error')
      }
    }
  }

  /**
   * Middleware helper for protecting routes
   */
  async requireAuth(req: NextRequest): Promise<AuthResponse> {
    const authResult = await this.verifyTokenLocal(req)
    
    if (!authResult.authenticated) {
      throw new Error('Authentication required')
    }
    
    return authResult
  }

  /**
   * Extract token from request headers
   */
  extractToken(req: NextRequest): string | null {
    const authHeader = req.headers.get('authorization')
    if (authHeader?.startsWith('Bearer ')) {
      return authHeader.substring(7)
    }

    // Try to get from cookie
    const cookies = req.headers.get('cookie')
    if (cookies) {
      const tokenCookie = cookies
        .split(';')
        .find(c => c.trim().startsWith('next-auth.session-token='))
      
      if (tokenCookie) {
        return tokenCookie.split('=')[1]
      }
    }

    return null
  }
}

// Middleware example for other microservices
export async function authMiddleware(req: NextRequest) {
  const authClient = new AuthClient()
  
  try {
    const authResult = await authClient.verifyTokenLocal(req)
    
    if (!authResult.authenticated) {
      return new Response(
        JSON.stringify({ error: 'Authentication required' }),
        { 
          status: 401,
          headers: { 'Content-Type': 'application/json' }
        }
      )
    }

    // Add user info to request headers for downstream handlers
    const requestHeaders = new Headers(req.headers)
    requestHeaders.set('x-user-id', authResult.user!.id)
    requestHeaders.set('x-user-email', authResult.user!.email || '')
    
    return NextResponse.next({
      request: {
        headers: requestHeaders,
      },
    })
  } catch (error) {
    return new Response(
      JSON.stringify({ 
        error: 'Authentication failed: ' + (error instanceof Error ? error.message : 'Unknown error')
      }),
      { 
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      }
    )
  }
}

// React hook for client-side authentication in other services
export function useAuthClient() {
  const authClient = new AuthClient()

  const verifySession = async () => {
    try {
      const response = await fetch('/api/auth/session')
      const session = await response.json()
      return session?.user ? { authenticated: true, user: session.user } : { authenticated: false }
    } catch (error) {
      return { 
        authenticated: false, 
        error: 'Session check failed: ' + (error instanceof Error ? error.message : 'Unknown error')
      }
    }
  }

  const redirectToAuth = () => {
    window.location.href = `${authClient.getAuthServiceUrl()}/auth/signin?callbackUrl=${encodeURIComponent(window.location.href)}`
  }

  return {
    verifySession,
    redirectToAuth,
  }
}