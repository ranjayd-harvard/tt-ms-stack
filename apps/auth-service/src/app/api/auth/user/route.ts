import { NextRequest, NextResponse } from 'next/server'
import { getToken } from 'next-auth/jwt'
import clientPromise from '@/lib/db'
import { ObjectId } from 'mongodb'

export async function GET(req: NextRequest) {
  try {
    const token = await getToken({
      req,
      secret: process.env.NEXTAUTH_SECRET,
    })

    if (!token?.id) {
      return NextResponse.json(
        { error: 'Authentication required' },
        { status: 401 }
      )
    }

    // Get full user data from database
    const client = await clientPromise
    const users = client.db().collection('users')
    
    const user = await users.findOne(
      { _id: new ObjectId(token.id as string) },
      { 
        projection: { 
          password: 0, // Don't expose password
          twoFactorSecret: 0, // Don't expose 2FA secret
          tempTwoFactorSecret: 0,
          backupCodes: 0,
        } 
      }
    )

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      user: {
        id: user._id.toString(),
        email: user.email,
        name: user.name,
        image: user.image,
        registerSource: user.registerSource,
        groupId: user.groupId,
        linkedEmails: user.linkedEmails || [],
        linkedProviders: user.linkedProviders || [],
        hasLinkedAccounts: user.hasLinkedAccounts || false,
        twoFactorEnabled: user.twoFactorEnabled || false,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
      }
    })

  } catch (error) {
    console.error('Get user error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}