import { NextRequest, NextResponse } from 'next/server'
import { getToken } from 'next-auth/jwt'
import { enhancedAuthOptions as authOptions } from '@/lib/enhanced-auth'

export async function POST(req: NextRequest) {
  try {
    const { token } = await req.json()
    
    if (!token) {
      return NextResponse.json(
        { valid: false, error: 'Token required' },
        { status: 400 }
      )
    }

    // Verify the JWT token
    const payload = await getToken({
      req: {
        headers: {
          authorization: `Bearer ${token}`,
        },
      } as any,
      secret: process.env.NEXTAUTH_SECRET,
      raw: false,
    })

    if (!payload) {
      return NextResponse.json(
        { valid: false, error: 'Invalid token' },
        { status: 401 }
      )
    }

    // Return user data for other services
    return NextResponse.json({
      valid: true,
      user: {
        id: payload.id,
        email: payload.email,
        name: payload.name,
        registerSource: payload.registerSource,
        groupId: payload.groupId,
        hasLinkedAccounts: payload.hasLinkedAccounts,
        services: payload.services,
      },
      expires: payload.exp,
    })

  } catch (error) {
    console.error('Token verification error:', error)
    return NextResponse.json(
      { valid: false, error: 'Verification failed' },
      { status: 500 }
    )
  }
}

// Alternative: GET method for simple token verification
export async function GET(req: NextRequest) {
  try {
    const token = await getToken({
      req,
      secret: process.env.NEXTAUTH_SECRET,
    })

    if (!token) {
      return NextResponse.json(
        { authenticated: false },
        { status: 401 }
      )
    }

    return NextResponse.json({
      authenticated: true,
      user: {
        id: token.id,
        email: token.email,
        name: token.name,
      },
    })
  } catch (error) {
    return NextResponse.json(
      { authenticated: false, error: 'Verification failed' },
      { status: 500 }
    )
  }
}
