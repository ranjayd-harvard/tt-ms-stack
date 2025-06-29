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
}

export interface AuthResponse {
  authenticated: boolean
  user?: AuthUser
  error?: string
}

export class AuthClient {
  private secret: string

  constructor(secret?: string) {
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
        }
      }
    } catch (error) {
      console.error('Token verification failed:', error)
      return { authenticated: false, error: 'Token verification failed' }
    }
  }
}
