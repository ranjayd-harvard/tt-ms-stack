import { NextRequest, NextResponse } from 'next/server'
import { getToken } from 'next-auth/jwt'
import { jwtVerify } from 'jose'

export async function POST(req: NextRequest) {
  try {
    const { token } = await req.json()
    
    if (!token) {
      return NextResponse.json(
        { valid: false, error: 'Token required' },
        { status: 400 }
      )
    }

    // Use jose library to verify JWT token directly
    const secret = new TextEncoder().encode(process.env.NEXTAUTH_SECRET)
    
    try {
      const { payload } = await jwtVerify(token, secret)
      
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
    } catch (jwtError) {
      console.error('JWT verification failed:', jwtError)
      return NextResponse.json(
        { valid: false, error: 'Invalid token' },
        { status: 401 }
      )
    }

  } catch (error) {
    console.error('Token verification error:', error)
    
    // Handle specific error types with proper type checking
    const errorMessage = error instanceof Error ? error.message : String(error)
    
    return NextResponse.json(
      { 
        valid: false, 
        error: 'Verification failed',
        details: process.env.NODE_ENV === 'development' ? errorMessage : undefined
      },
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
        registerSource: token.registerSource,
        groupId: token.groupId,
        hasLinkedAccounts: token.hasLinkedAccounts,
      },
    })
  } catch (error) {
    console.error('GET token verification error:', error)
    
    // Handle specific error types with proper type checking
    const errorMessage = error instanceof Error ? error.message : String(error)
    
    return NextResponse.json(
      { 
        authenticated: false, 
        error: 'Verification failed',
        details: process.env.NODE_ENV === 'development' ? errorMessage : undefined
      },
      { status: 500 }
    )
  }
}