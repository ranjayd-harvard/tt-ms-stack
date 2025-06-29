import { NextRequest, NextResponse } from 'next/server'
import { AuthClient } from './auth-client'
import type { AuthUser } from './auth-client'

export async function withAuth(
  req: NextRequest, 
  callback: (req: NextRequest, user: AuthUser) => Promise<Response>
): Promise<Response> {
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

    return await callback(req, authResult.user!)
  } catch (error) {
    console.error('Auth middleware error:', error)
    return new Response(
      JSON.stringify({ error: 'Authentication failed' }),
      { 
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      }
    )
  }
}
