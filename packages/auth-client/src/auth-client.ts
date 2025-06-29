import { getToken } from 'next-auth/jwt'
import { NextRequest } from 'next/server'

export interface AuthUser {
  id: string
  email?: string | null
  name?: string | null
  image?: string | null
  registerSource?: string
  groupId?: string
  hasLinkedAccounts?: boolean
  services?: any
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
          services: token.services,
        }
      }
    } catch (error) {
      console.error('Local token verification failed:', error)
      return { authenticated: false, error: 'Token verification failed' }
    }
  }
}
