// Complete replacement for lib/enhanced-auth.ts
// This is a clean, working version that should fix the session issue

import { NextAuthOptions } from 'next-auth'
import { MongoDBAdapter } from '@next-auth/mongodb-adapter'
import CredentialsProvider from 'next-auth/providers/credentials'
import GoogleProvider from 'next-auth/providers/google'
import GitHubProvider from 'next-auth/providers/github'
import clientPromise from './db'
//import { TokenManager } from './tokens'
import { verifyCode } from './sms'
import { EnhancedAuthIntegration } from './enhanced-auth-integration'
import { ActivityTracker } from './activity-tracker'
import bcrypt from 'bcryptjs'

// Format phone number function (same as used in registration)
function formatPhoneNumber(phoneNumber: string, countryCode: string = 'US'): string {
  const cleaned = phoneNumber.replace(/\D/g, '')
  const countryPrefixes: Record<string, string> = {
    'US': '+1', 'CA': '+1', 'GB': '+44', 'IN': '+91',
    'AU': '+61', 'DE': '+49', 'FR': '+33', 'JP': '+81',
    'BR': '+55', 'MX': '+52', 'IT': '+39', 'ES': '+34',
    'NL': '+31', 'SE': '+46', 'NO': '+47', 'DK': '+45',
    'FI': '+358', 'PL': '+48', 'CZ': '+420', 'HU': '+36'
  }
  const prefix = countryPrefixes[countryCode] || '+1'
  if (phoneNumber.startsWith('+')) {
    return phoneNumber
  }
  if ((countryCode === 'US' || countryCode === 'CA') && cleaned.startsWith('1')) {
    return `+1${cleaned.substring(1)}`
  }
  return `${prefix}${cleaned}`
}

export const enhancedAuthOptions: NextAuthOptions = {
  adapter: MongoDBAdapter(clientPromise),
  
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
      allowDangerousEmailAccountLinking: true,
      authorization: {
        params: {
          prompt: "consent",
          access_type: "offline",
          response_type: "code"
        }
      }
    }),
    GitHubProvider({
      clientId: process.env.GITHUB_ID!,
      clientSecret: process.env.GITHUB_SECRET!,
      allowDangerousEmailAccountLinking: true,
      authorization: {
        params: {
          scope: "user:email"
        }
      }
    }),
    CredentialsProvider({
      name: 'credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
        twoFactorCode: { label: '2FA Code', type: 'text' }
      },
      async authorize(credentials) {
        console.log('🔍 Credentials authorize called')
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        // Use enhanced authentication to find user with group support
        const authResult = await EnhancedAuthIntegration.authenticateUserWithGroup({
          email: credentials.email
        })

        if (!authResult?.user) {
          console.log('❌ DEBUG: User not found for email:', credentials.email)
          // Track failed login attempt
          await ActivityTracker.track(
            credentials.email,
            'auth_failed_login',
            'Failed login attempt - user not found',
            { 
              reason: 'user_not_found', 
              email: credentials.email,
              provider: 'credentials'
            },
            req
          )
          return null
        }

        const user = authResult.user
        console.log('🔍 DEBUG: User found:', {
          id: user._id,
          email: user.email,
          twoFactorEnabled: user.twoFactorEnabled,
          hasTwoFactorSecret: !!user.twoFactorSecret,
          hasBackupCodes: !!(user.backupCodes && user.backupCodes.length > 0),
          backupCodesCount: user.backupCodes?.length || 0
        })

        // Check if user registered with OAuth but trying to sign in with credentials
        if (!user.password && user.registerSource !== 'credentials') {
          await ActivityTracker.track(
            user._id.toString(),
            'auth_failed_login',
            `Failed login attempt - registered with ${user.registerSource}`,
            { 
              reason: 'wrong_provider', 
              email: credentials.email,
              actualProvider: user.registerSource,
              attemptedProvider: 'credentials'
            },
            req
          )
          throw new Error(`This email is registered with ${user.registerSource}. Please use ${user.registerSource} to sign in.`)
        }

        if (!user.password) {
          await ActivityTracker.track(
            user._id.toString(),
            'auth_failed_login',
            'Failed login attempt - no password set',
            { 
              reason: 'no_password', 
              email: credentials.email 
            },
            req
          )
          return null
        }

        const isPasswordValid = await bcrypt.compare(credentials.password, user.password)
        
        if (!isPasswordValid) {
          await ActivityTracker.track(
            user._id.toString(),
            'auth_failed_login',
            'Failed login attempt - invalid password',
            { 
              reason: 'invalid_password', 
              email: credentials.email 
            },
            req
          )
          return null
        }

        // Check if 2FA is enabled for this user
        if (user.twoFactorEnabled && user.twoFactorSecret) {
          const twoFactorCode = credentials.twoFactorCode
          console.log('🔍 DEBUG: 2FA Code received:', twoFactorCode)

          if (!twoFactorCode) {
            console.log('❌ DEBUG: No 2FA code provided, throwing 2FA_REQUIRED')
            throw new Error('2FA_REQUIRED')
          }

          // Verify 2FA code
          console.log('🔍 DEBUG: Attempting TOTP verification...')
          const verified = speakeasy.totp.verify({
            secret: user.twoFactorSecret,
            encoding: 'base32',
            token: twoFactorCode,
            window: 2
          })
          console.log('🔍 DEBUG: TOTP verification result:', verified)

          if (verified) {
            console.log('✅ DEBUG: TOTP verification successful!')
            // TOTP is valid, continue with authentication
          } else {
            // Check backup codes
            console.log('🔍 DEBUG: TOTP failed, checking backup codes...')
            if (user.backupCodes && user.backupCodes.includes(twoFactorCode.toUpperCase())) {
              console.log('✅ DEBUG: Backup code valid!')
              // Remove used backup code
              const client = await clientPromise
              const users = client.db().collection('users')
              await users.updateOne(
                { _id: user._id },
                { $pull: { backupCodes: twoFactorCode.toUpperCase() } }
              )
            } else {
              console.log('❌ DEBUG: Both TOTP and backup code failed')
              throw new Error('Invalid 2FA code')
            }
          }
          
          console.log('✅ DEBUG: 2FA validation passed, continuing...')
        }

        // Update user activity through Enhanced Auth Integration
        await EnhancedAuthIntegration.updateUserActivity(user._id.toString())
        console.log('✅ DEBUG: Authentication successful, returning user')

        // Successful authentication

        
        // Make sure you return the user object like this:
        return {
          id: user._id.toString(),
          email: user.email,
          name: user.name,
          image: user.image,
          registerSource: user.registerSource,
          avatarType: user.avatarType,
          twoFactorEnabled: user.twoFactorEnabled,
          groupId: user.groupId,
          hasLinkedAccounts: user.hasLinkedAccounts
        }
      }
    }),
    CredentialsProvider({
      id: 'phone',
      name: 'Phone Number', 
      credentials: {
        phoneNumber: { label: 'Phone Number', type: 'tel' },
        code: { label: 'Verification Code', type: 'text' }
      },
      async authorize(credentials, req) {
        try {
          console.log('🔐 Phone provider authorize called with:', credentials)
    
          if (!credentials?.phoneNumber || !credentials?.code) {
            console.log('❌ Missing phone number or code')
            return null
          }
    
          // Format the phone number consistently
          const formattedPhoneNumber = formatPhoneNumber(credentials.phoneNumber)
          console.log('🔐 Formatted phone number:', formattedPhoneNumber)
    
          // Use enhanced authentication to find user with group support
          const authResult = await EnhancedAuthIntegration.authenticateUserWithGroup({
            phoneNumber: formattedPhoneNumber
          })
    
          if (!authResult?.user) {
            console.log('❌ User not found for phone:', formattedPhoneNumber)
            await ActivityTracker.track(
              formattedPhoneNumber,
              'auth_failed_login',
              'Failed phone login attempt - user not found',
              { 
                reason: 'user_not_found', 
                phoneNumber: formattedPhoneNumber,
                provider: 'phone'
              },
              req
            )
            return null
          }
    
          const user = authResult.user
          console.log('✅ User found:', user._id, 'phoneVerified:', user.phoneVerified)
    
          // Check if phone is verified
          if (!user.phoneVerified) {
            console.log('❌ Phone not verified for user:', user._id)
            await ActivityTracker.track(
              user._id.toString(),
              'auth_failed_login',
              'Failed phone login attempt - phone not verified',
              { 
                reason: 'phone_not_verified', 
                phoneNumber: formattedPhoneNumber 
              },
              req
            )
            throw new Error('Phone number is not verified')
          }
    
          // 🔥 FIX: Import verifyCode properly and check .success property
          console.log('🔐 Verifying SMS code...')
          //const { verifyCode } = await import('@/lib/sms')
          const verificationResult = await verifyCode(formattedPhoneNumber, credentials.code)
          
          console.log('🔐 Verification result:', verificationResult)
          
          // 🔥 CRITICAL FIX: Check .success property, not the object itself
          if (!verificationResult.success) {
            console.log('❌ Invalid verification code for phone:', formattedPhoneNumber)
            console.log('❌ Verification error:', verificationResult.error)
            
            await ActivityTracker.track(
              user._id.toString(),
              'auth_failed_login',
              'Failed phone login attempt - invalid code',
              { 
                reason: 'invalid_code', 
                phoneNumber: formattedPhoneNumber,
                error: verificationResult.error
              },
              req
            )
            throw new Error(verificationResult.error || 'Invalid or expired verification code')
          }
    
          console.log('✅ Phone authentication successful for user:', user._id)
    
          // Update user activity
          await EnhancedAuthIntegration.updateUserActivity(user._id.toString())
    
          // Successful phone authentication
          return {
            id: user._id.toString(),
            phoneNumber: formattedPhoneNumber,
            email: user.email || user.primaryEmail,
            name: user.name,
            image: user.image,
            registerSource: user.registerSource,
            avatarType: user.avatarType,
            groupId: user.groupId,
            linkedEmails: user.linkedEmails || [],
            linkedPhones: user.linkedPhones || [],
            linkedProviders: user.linkedProviders || [],
            hasLinkedAccounts: authResult.hasLinkedAccounts,
            twoFactorEnabled: user.twoFactorEnabled || false
          }
    
        } catch (error) {
          console.error('❌ Phone provider error:', error)
          return null
        }
      }
    }),    
  ],

  // CRITICAL: Clean callbacks section
  callbacks: {
    // async signIn({ user, account, profile, credentials }) {
    //   console.log('🔓 SignIn callback triggered')
    //   try {
    //     if (account?.provider === 'google' || account?.provider === 'github') {
    //       const client = await clientPromise
    //       const users = client.db().collection('users')
    //       const accounts = client.db().collection('accounts')
          
    //       const existingUser = await users.findOne({ email: user.email })
          
    //       if (existingUser) {
    //         // 🔥 FIX: Update linkedProviders array when linking social account
    //         await users.updateOne(
    //           { _id: existingUser._id },
    //           { 
    //             $addToSet: { 
    //               linkedProviders: account.provider // Add provider if not already present
    //             },
    //             $set: {
    //               lastLoginAt: new Date(),
    //               updatedAt: new Date()
    //             }
    //           }
    //         )

    //         if (user.id) {
    //           await EnhancedAuthIntegration.updateUserActivity(user.id)
    //           const method = account?.provider || 'credentials'
    //           await ActivityTracker.trackSignIn(user.id, method)
    //           console.log(`🔓 Sign-in tracked for user ${user.id} via ${method}`)
    //         }
            
    //         console.log(`✅ Updated linkedProviders for user ${existingUser._id} with ${account.provider}`)
    //       }
    //     }
        
    //     return true
    //   } catch (error) {
    //     console.error('SignIn callback error:', error)
    //     return false
    //   }
    // },
    async signIn({ user, account, profile, isNewUser }) {
      console.log('🔓 SignIn callback triggered', { 
        userId: user?.id, 
        provider: account?.provider, 
        accountType: account?.type,
        accountId: account?.id
      })
      
      try {
        if (user.id) {
          await EnhancedAuthIntegration.updateUserActivity(user.id)
          
          // 🔥 FIX: Determine the method based on account properties
          let method = 'unknown'
          
          if (account?.provider) {
            // OAuth providers (google, github, etc.)
            method = account.provider
          } else if (account?.type === 'credentials') {
            // Credentials providers - check the account id to determine type
            if (account?.id === 'phone') {
              method = 'phone'
            } else if (account?.id === 'credentials') {
              method = 'credentials'
            } else {
              method = account?.id || 'credentials'
            }
          } else {
            // Fallback - try to determine from user data
            if (user.registerSource) {
              method = user.registerSource
            }
          }
          
          console.log(`🔓 Tracking sign-in for user ${user.id} via method: ${method}`)
          
          await ActivityTracker.trackSignIn(user.id, method)
          console.log(`✅ Sign-in tracked successfully for user ${user.id} via ${method}`)
        }

        if (account?.provider === 'google' || account?.provider === 'github') {
          const client = await clientPromise
          const users = client.db().collection('users')
          const accounts = client.db().collection('accounts')
          
          const existingUser = await users.findOne({ email: user.email })
          
          if (existingUser) {
            // 🔥 FIX: Update linkedProviders array when linking social account
            await users.updateOne(
              { _id: existingUser._id },
              { 
                $addToSet: { 
                  linkedProviders: account.provider // Add provider if not already present
                },
                $set: {
                  lastLoginAt: new Date(),
                  updatedAt: new Date()
                }
              }
            )

            if (user.id) {
              const method = account?.provider || 'credentials'
              await ActivityTracker.trackSignIn(user.id, method)
              console.log(`🔓 Sign-in tracked for user ${user.id} via ${method}`)
            }
            
            console.log(`✅ Updated linkedProviders for user ${existingUser._id} with ${account.provider}`)
          }
        }
        return true
      } catch (error) {
        console.error('❌ SignIn callback error:', error)
        return true // Don't fail the login if activity tracking fails
      }
    },
        

    async jwt({ token, user, account }) {
      console.log('🔑 JWT callback triggered:', { hasUser: !!user, hasToken: !!token })
      
      if (user) {
        console.log('🔑 Setting token data from user:', user)
        token.sub = user.id
        token.id = user.id
        token.registerSource = user.registerSource
        token.avatarType = user.avatarType
        token.twoFactorEnabled = user.twoFactorEnabled
        token.groupId = user.groupId
        token.hasLinkedAccounts = user.hasLinkedAccounts
      }
      
      console.log('🔑 JWT callback returning token with sub:', token.sub)
      return token
    },

    async session({ session, token }) {
      console.log('👤 SESSION CALLBACK TRIGGERED!', { 
        hasSession: !!session, 
        hasToken: !!token, 
        tokenSub: token?.sub 
      })
      
      if (session?.user && token?.sub) {
        console.log('👤 Mapping token to session')
        session.user.id = token.sub
        session.user.registerSource = token.registerSource as string
        session.user.avatarType = token.avatarType as string
        session.user.twoFactorEnabled = token.twoFactorEnabled as boolean
        session.user.groupId = token.groupId as string
        session.user.hasLinkedAccounts = token.hasLinkedAccounts as boolean
        
        console.log('👤 Session user populated:', {
          id: session.user.id,
          email: session.user.email,
          registerSource: session.user.registerSource
        })
      } else {
        console.log('👤 Session callback: missing session.user or token.sub', {
          hasSessionUser: !!session?.user,
          hasSub: !!token?.sub
        })
      }
      
      console.log('👤 Session callback returning:', session)
      return session
    },

    async signOut({ session, token }) {
      try {
        const userId = session?.user?.id || token?.sub as string
        if (userId) {
          await ActivityTracker.trackSignOut(userId)
          console.log(`🔒 Sign-out tracked for user ${userId}`)
        }
      } catch (error) {
        console.error('❌ SignOut event error:', error)
      }
    },
  },

  // Session configuration
  session: {
    strategy: 'jwt',
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },

  // Events for debugging
  events: {
    async signIn({ user, account }) {
      console.log('🔓 NextAuth signIn event:', { userId: user.id, provider: account?.provider })
    },
    async session({ session, token }) {
      console.log('👤 NextAuth session event triggered')
    },
    async jwt({ token, user }) {
      console.log('🔑 NextAuth jwt event triggered')
    },
  },

  // Enable debug
  debug: true,
  
  // Pages
  pages: {
    signIn: '/auth/sign-in',
    signOut: '/auth/signout',
    error: '/auth/error',
  },
}

// Type declarations
declare module 'next-auth' {
  interface User {
    id: string
    registerSource?: string
    avatarType?: string
    twoFactorEnabled?: boolean
    phoneNumber?: string
    groupId?: string
    linkedEmails?: string[]
    linkedPhones?: any[]
    linkedProviders?: string[]
    hasLinkedAccounts?: boolean
  }

  interface Session {
    user: {
      id: string
      name?: string | null
      email?: string | null
      image?: string | null
      registerSource?: string
      avatarType?: string
      twoFactorEnabled?: boolean
      groupId?: string
      hasLinkedAccounts?: boolean
    }
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    id?: string
    registerSource?: string
    avatarType?: string
    twoFactorEnabled?: boolean
    groupId?: string
    hasLinkedAccounts?: boolean
  }
}