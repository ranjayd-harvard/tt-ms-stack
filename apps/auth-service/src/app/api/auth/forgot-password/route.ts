import { NextRequest, NextResponse } from 'next/server'
import clientPromise from '@/lib/db'
import { sendEmail, emailTemplates } from '@/lib/email'
import { TokenManager } from '@/lib/tokens'

export async function POST(req: NextRequest) {
  try {
    const { email } = await req.json()

    if (!email) {
      return NextResponse.json(
        { error: 'Email is required' },
        { status: 400 }
      )
    }

    const client = await clientPromise
    const users = client.db().collection('users')
    
    // Find user by email
    const user = await users.findOne({ email })
    
    if (!user) {
      // For security, don't reveal whether email exists
      return NextResponse.json(
        { message: 'If an account with that email exists, we have sent a password reset link.' },
        { status: 200 }
      )
    }

    // Check if user registered with credentials (has password)
    if (user.registerSource !== 'credentials' || !user.password) {
      return NextResponse.json(
        { error: `This account was registered with ${user.registerSource}. Please sign in using ${user.registerSource}.` },
        { status: 400 }
      )
    }

    // Generate reset token (shorter expiry for security)
    // Parameters: identifier, type, expiresInMinutes, userId
    const resetToken = await TokenManager.createToken(
      email,                    // identifier (email)
      'password_reset',         // type
      60,                       // expiresInMinutes (1 hour)
      user._id.toString()       // userId (optional)
    )

    // Send reset email
    const resetUrl = `${process.env.NEXTAUTH_URL}/auth/reset-password?token=${resetToken}`
    const emailTemplate = emailTemplates.resetPasswordEmail(user.name, resetUrl)
    
    const emailResult = await sendEmail({
      to: email,
      subject: emailTemplate.subject,
      html: emailTemplate.html,
    })

    if (emailResult.success) {
      return NextResponse.json(
        { message: 'Password reset email sent successfully. Please check your inbox.' },
        { status: 200 }
      )
    } else {
      return NextResponse.json(
        { error: 'Failed to send reset email. Please try again later.' },
        { status: 500 }
      )
    }
  } catch (error) {
    console.error('Forgot password error:', error)
    
    // Handle specific error types with proper type checking
    const errorMessage = error instanceof Error ? error.message : String(error)
    
    return NextResponse.json(
      { 
        error: 'Internal server error',
        details: process.env.NODE_ENV === 'development' ? errorMessage : undefined
      },
      { status: 500 }
    )
  }
}