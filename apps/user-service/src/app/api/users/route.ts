import { NextRequest, NextResponse } from 'next/server'
import { AuthClient } from '@/lib/auth-client'

export async function GET(req: NextRequest) {
  try {
    const authClient = new AuthClient()
    const authResult = await authClient.verifyTokenLocal(req)

    if (!authResult.authenticated) {
      return NextResponse.json(
        { error: 'Authentication required' },
        { status: 401 }
      )
    }

    // Here you would fetch users from your user service database
    // For now, returning mock data
    const users = [
      { id: '1', name: 'John Doe', email: 'john@example.com' },
      { id: '2', name: 'Jane Smith', email: 'jane@example.com' },
    ]

    return NextResponse.json({ users })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch users' },
      { status: 500 }
    )
  }
}