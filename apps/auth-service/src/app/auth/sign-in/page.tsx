// src/app/auth/sign-in/page.tsx - Your UI with 2FA support
'use client'

import { useState, useEffect } from 'react'
import { signIn, getProviders, useSession } from 'next-auth/react'
import { useRouter, useSearchParams } from 'next/navigation'
import Link from 'next/link'

type AuthMethod = 'email' | 'phone' | 'social'

interface Provider {
  id: string
  name: string
  type: string
}

export default function UnifiedSignIn() {
  const { data: session, status } = useSession()
  const [activeMethod, setActiveMethod] = useState<AuthMethod>('email')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')
  const [providers, setProviders] = useState<Record<string, Provider>>({})
  
  const router = useRouter()
  const searchParams = useSearchParams()
  const callbackUrl = searchParams.get('callbackUrl') || '/dashboard'

  useEffect(() => {
    getProviders().then(setProviders)
  }, [])

  // Redirect if already signed in
  useEffect(() => {
    console.log('🔍 Auth status check:', { status, hasSession: !!session, callbackUrl })
    
    if (status === 'authenticated' && session) {
      console.log('✅ User already authenticated, forcing redirect to:', callbackUrl)
      // Use window.location.href for immediate redirect instead of router.push
      window.location.href = callbackUrl
    }
  }, [session, status, callbackUrl])

  const methods = [
    { 
      id: 'email', 
      label: 'Email', 
      icon: '📧', 
      description: 'Sign in with your email address' 
    },
    { 
      id: 'phone', 
      label: 'Phone', 
      icon: '📱', 
      description: 'Get a text message code' 
    },
    { 
      id: 'social', 
      label: 'Social', 
      icon: '🌐', 
      description: 'Google, GitHub, etc.' 
    }
  ]

  // ADD THE LOADING STATES HERE - RIGHT BEFORE THE MAIN RETURN
  // Show loading while checking authentication status
  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  // If already authenticated, show redirecting message
  if (status === 'authenticated') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p>Redirecting to dashboard...</p>
        </div>
      </div>
    )
  }  

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        {/* Header */}
        <div className="text-center">
          <div className="mx-auto h-12 w-12 bg-blue-600 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-xl">M</span>
          </div>
          <h2 className="mt-6 text-3xl font-extrabold text-gray-900">
            Welcome back! 👋
          </h2>
          <p className="mt-2 text-sm text-gray-600">
            Sign in to your account using any method below
          </p>
        </div>

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-4">
            <div className="flex">
              <span className="text-red-400">⚠️</span>
              <div className="ml-3">
                <p className="text-sm text-red-800">{error}</p>
              </div>
            </div>
          </div>
        )}

        {/* Method Selector */}
        <div className="bg-white rounded-xl shadow-lg p-6">
          <div className="flex space-x-1 bg-gray-100 p-1 rounded-lg mb-6">
            {methods.map((method) => (
              <button
                key={method.id}
                onClick={() => {
                  setActiveMethod(method.id as AuthMethod)
                  setError('')
                }}
                className={`flex-1 py-3 px-3 rounded-md text-sm font-medium transition-all duration-200 ${
                  activeMethod === method.id
                    ? 'bg-white text-blue-600 shadow-sm ring-1 ring-blue-100'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
              >
                <div className="flex flex-col items-center space-y-1">
                  <span className="text-lg">{method.icon}</span>
                  <span className="font-medium">{method.label}</span>
                </div>
              </button>
            ))}
          </div>

          {/* Active Method Description */}
          <div className="text-center mb-6">
            <p className="text-sm text-gray-600">
              {methods.find(m => m.id === activeMethod)?.description}
            </p>
          </div>

          {/* Dynamic Form Content */}
          <div className="min-h-[320px]">
            {activeMethod === 'email' && (
              <EmailSignInForm 
                callbackUrl={callbackUrl}
                onError={setError}
                isLoading={isLoading}
                setIsLoading={setIsLoading}
              />
            )}
            {activeMethod === 'phone' && (
              <PhoneSignInForm 
                callbackUrl={callbackUrl}
                onError={setError}
                isLoading={isLoading}
                setIsLoading={setIsLoading}
              />
            )}
            {activeMethod === 'social' && (
              <SocialSignInForm 
                providers={providers}
                callbackUrl={callbackUrl}
                onError={setError}
                isLoading={isLoading}
                setIsLoading={setIsLoading}
              />
            )}
          </div>

          {/* Help Section */}
          <div className="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-100">
            <div className="flex items-start space-x-3">
              <span className="text-blue-500 text-xl flex-shrink-0">💡</span>
              <div className="text-sm text-blue-700">
                <p className="font-medium">Can't access your account?</p>
                <p className="mt-1">
                  Try signing in with a different method above. If you have multiple accounts, 
                  we'll automatically link them together for you!
                </p>
                <div className="mt-2 flex items-center space-x-4 text-xs">
                  <button
                    onClick={() => setActiveMethod('phone')}
                    className="text-blue-600 hover:text-blue-800 font-medium"
                  >
                    → Try Phone
                  </button>
                  <button
                    onClick={() => setActiveMethod('social')}
                    className="text-blue-600 hover:text-blue-800 font-medium"
                  >
                    → Try Social
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center space-y-4">
          <p className="text-sm text-gray-600">
            Don't have an account?{' '}
            <Link href="/auth/sign-up" className="font-medium text-blue-600 hover:text-blue-500">
              Sign up here
            </Link>
          </p>
          <div className="flex items-center justify-center space-x-6 text-xs text-gray-500">
            <Link href="/privacy" className="hover:text-gray-700">Privacy Policy</Link>
            <Link href="/terms" className="hover:text-gray-700">Terms of Service</Link>
            <Link href="/support" className="hover:text-gray-700">Support</Link>
          </div>
        </div>
      </div>
    </div>
  )
}

// Email Sign-In Form Component - Enhanced with 2FA support
function EmailSignInForm({ 
  callbackUrl, 
  onError, 
  isLoading, 
  setIsLoading 
}: {
  callbackUrl: string
  onError: (error: string) => void
  isLoading: boolean
  setIsLoading: (loading: boolean) => void
}) {
  const [step, setStep] = useState<'credentials' | '2fa'>('credentials')
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    twoFactorCode: ''
  })
  const [userEmail, setUserEmail] = useState('')

  const handleCredentialsSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')
  
    try {
      console.log('🔐 Attempting credential sign-in...')
      const result = await signIn('credentials', {
        email: formData.email,
        password: formData.password,
        callbackUrl,
        redirect: false,
      })
  
      if (result?.error) {
        // Handle errors as before
        if (result.error === '2FA_REQUIRED') {
          setUserEmail(formData.email)
          setStep('2fa')
          onError('')
        } else {
          onError(result.error)
        }
        setIsLoading(false)
      } else if (result?.ok) {
        console.log('✅ Sign-in successful! Forcing immediate redirect...')
        
        // Use window.location.replace instead of href
        window.location.replace(callbackUrl)
      }
    } catch (error) {
      console.error('❌ Sign-in exception:', error)
      onError('An unexpected error occurred. Please try again.')
      setIsLoading(false)
    }
  }

  const handle2FASubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    // 🔍 DEBUG: Log what we're sending
    console.log('🔍 DEBUG: About to submit 2FA form with:', {
      email: formData.email,
      password: formData.password ? '[REDACTED]' : 'MISSING',
      twoFactorCode: formData.twoFactorCode,
      twoFactorCodeLength: formData.twoFactorCode?.length
    })    

    try {
      const result = await signIn('credentials', {
        email: formData.email,
        password: formData.password,
        twoFactorCode: formData.twoFactorCode,
        redirect: false,
      })

      // 🔍 DEBUG: Log the result
      console.log('🔍 DEBUG: SignIn result:', result)

      if (result?.error) {
        console.log('❌ DEBUG: SignIn error:', result.error)
        if (result.error.includes('Invalid 2FA code')) {
          onError('Invalid verification code. Please try again.')
        } else {
          onError('Authentication failed. Please try again.')
        }
      } else if (result?.ok) {
        console.log('✅ 2FA sign-in successful, forcing redirect to:', callbackUrl)
        window.location.href = callbackUrl
        return
      }
    } catch (error) {
      console.log('❌ DEBUG: Exception during signIn:', error)
      onError('An unexpected error occurred. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  const resetToCredentials = () => {
    setStep('credentials')
    setFormData(prev => ({ ...prev, twoFactorCode: '' }))
    setUserEmail('')
    onError('')
  }

  if (step === '2fa') {
    return (
      <form onSubmit={handle2FASubmit} className="space-y-4">
        <div className="text-center mb-6">
          <div className="text-4xl mb-3">🔐</div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">Two-Factor Authentication</h3>
          <p className="text-sm text-gray-600 mb-1">
            Authentication required for
          </p>
          <p className="font-medium text-gray-900 mb-3">{userEmail}</p>
          <p className="text-sm text-gray-600">
            Enter the 6-digit code from your authenticator app or use a backup code
          </p>
        </div>

        <div>
          <label htmlFor="twoFactorCode" className="block text-sm font-medium text-gray-700 mb-1">
            Verification Code
          </label>
          <input
            id="twoFactorCode"
            type="text"
            required
            value={formData.twoFactorCode}
            onChange={(e) => setFormData(prev => ({ ...prev, twoFactorCode: e.target.value }))}
            className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors text-center text-lg tracking-widest"
            placeholder="000000"
            maxLength={8}
            autoComplete="one-time-code"
            autoFocus
            disabled={isLoading}
          />
          <p className="mt-2 text-xs text-gray-500 text-center">
            Enter your 6-digit authenticator code or 8-character backup code
          </p>
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
        >
          {isLoading ? (
            <div className="flex items-center justify-center space-x-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
              <span>Verifying...</span>
            </div>
          ) : (
            'Verify & Sign In'
          )}
        </button>

        <div className="text-center">
          <button
            type="button"
            onClick={resetToCredentials}
            className="text-sm text-blue-600 hover:text-blue-500"
          >
            ← Back to sign in
          </button>
        </div>
      </form>
    )
  }

  return (
    <form onSubmit={handleCredentialsSubmit} className="space-y-4">
      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
          Email Address
        </label>
        <input
          id="email"
          type="email"
          required
          value={formData.email}
          onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
          className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          placeholder="Enter your email"
          disabled={isLoading}
        />
      </div>

      <div>
        <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-1">
          Password
        </label>
        <input
          id="password"
          type="password"
          required
          value={formData.password}
          onChange={(e) => setFormData(prev => ({ ...prev, password: e.target.value }))}
          className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          placeholder="Enter your password"
          disabled={isLoading}
        />
      </div>

      <div className="flex items-center justify-between">
        <label className="flex items-center">
          <input type="checkbox" className="h-4 w-4 text-blue-600 rounded border-gray-300" />
          <span className="ml-2 text-sm text-gray-600">Remember me</span>
        </label>
        <Link href="/auth/forgot-password" className="text-sm text-blue-600 hover:text-blue-500">
          Forgot password?
        </Link>
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
      >
        {isLoading ? (
          <div className="flex items-center justify-center space-x-2">
            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
            <span>Signing in...</span>
          </div>
        ) : (
          'Sign In with Email'
        )}
      </button>
    </form>
  )
}

// Phone Sign-In Form Component - Kept exactly the same
function PhoneSignInForm({ 
  callbackUrl, 
  onError, 
  isLoading, 
  setIsLoading 
}: {
  callbackUrl: string
  onError: (error: string) => void
  isLoading: boolean
  setIsLoading: (loading: boolean) => void
}) {
  const [step, setStep] = useState<'phone' | 'verify'>('phone')
  const [formData, setFormData] = useState({
    phoneNumber: '',
    countryCode: 'US',
    verificationCode: ''
  })

  const handlePhoneSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    try {
      const response = await fetch('/api/auth/phone-login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          phoneNumber: formData.phoneNumber,
          countryCode: formData.countryCode
        })
      })

      const data = await response.json()

      if (response.ok) {
        setStep('verify')
      } else {
        onError(data.error || 'Failed to send verification code')
      }
    } catch (error) {
      onError('An error occurred. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  const handleVerifySubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    try {
      const result = await signIn('phone', {
        phoneNumber: formData.phoneNumber,
        code: formData.verificationCode,
        redirect: false,
      })

      if (result?.error) {
        onError(result.error)
      } else if (result?.ok) {
        console.log('✅ Phone sign-in successful, forcing redirect to:', callbackUrl)
        window.location.href = callbackUrl
        return
      }
    } catch (error) {
      onError('An error occurred. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  if (step === 'verify') {
    return (
      <form onSubmit={handleVerifySubmit} className="space-y-4">
        <div className="text-center mb-4">
          <p className="text-sm text-gray-600">
            We sent a verification code to
          </p>
          <p className="font-medium text-gray-900">{formData.phoneNumber}</p>
        </div>

        <div>
          <label htmlFor="code" className="block text-sm font-medium text-gray-700 mb-1">
            Verification Code
          </label>
          <input
            id="code"
            type="text"
            required
            value={formData.verificationCode}
            onChange={(e) => setFormData(prev => ({ ...prev, verificationCode: e.target.value }))}
            className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors text-center text-lg tracking-widest"
            placeholder="Enter 6-digit code"
            maxLength={6}
            disabled={isLoading}
          />
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
        >
          {isLoading ? (
            <div className="flex items-center justify-center space-x-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
              <span>Verifying...</span>
            </div>
          ) : (
            'Verify & Sign In'
          )}
        </button>

        <div className="text-center">
          <button
            type="button"
            onClick={() => setStep('phone')}
            className="text-sm text-blue-600 hover:text-blue-500"
          >
            ← Change phone number
          </button>
        </div>
      </form>
    )
  }

  return (
    <form onSubmit={handlePhoneSubmit} className="space-y-4">
      <div>
        <label htmlFor="phone" className="block text-sm font-medium text-gray-700 mb-1">
          Phone Number
        </label>
        <div className="flex space-x-2">
          <select
            value={formData.countryCode}
            onChange={(e) => setFormData(prev => ({ ...prev, countryCode: e.target.value }))}
            className="px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            disabled={isLoading}
          >
            <option value="US">🇺🇸 +1</option>
            <option value="GB">🇬🇧 +44</option>
            <option value="IN">🇮🇳 +91</option>
            <option value="CA">🇨🇦 +1</option>
          </select>
          <input
            id="phone"
            type="tel"
            required
            value={formData.phoneNumber}
            onChange={(e) => setFormData(prev => ({ ...prev, phoneNumber: e.target.value }))}
            className="flex-1 px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
            placeholder="Enter your phone number"
            disabled={isLoading}
          />
        </div>
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
      >
        {isLoading ? (
          <div className="flex items-center justify-center space-x-2">
            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
            <span>Sending code...</span>
          </div>
        ) : (
          'Send Verification Code'
        )}
      </button>
    </form>
  )
}

// Social Sign-In Form Component - Kept exactly the same
function SocialSignInForm({ 
  providers, 
  callbackUrl, 
  onError, 
  isLoading, 
  setIsLoading 
}: {
  providers: Record<string, Provider>
  callbackUrl: string
  onError: (error: string) => void
  isLoading: boolean
  setIsLoading: (loading: boolean) => void
}) {
  const socialProviders = Object.values(providers).filter(
    provider => provider.type === 'oauth'
  )

  const getProviderIcon = (providerId: string) => {
    switch (providerId) {
      case 'google': return '🔴'
      case 'github': return '⚫'
      case 'facebook': return '🔵'
      case 'twitter': return '🐦'
      default: return '🌐'
    }
  }

  const getProviderColor = (providerId: string) => {
    switch (providerId) {
      case 'google': return 'hover:bg-red-50 border-red-200'
      case 'github': return 'hover:bg-gray-50 border-gray-200'
      case 'facebook': return 'hover:bg-blue-50 border-blue-200'
      case 'twitter': return 'hover:bg-blue-50 border-blue-200'
      default: return 'hover:bg-gray-50 border-gray-200'
    }
  }

  const handleSocialSignIn = async (providerId: string) => {
    setIsLoading(true)
    onError('')

    try {
      console.log(`🔐 Attempting ${providerId} sign-in...`)
      
      const result = await signIn(providerId, { 
        callbackUrl,
        redirect: false
      })

      console.log(`🔐 SignIn result for ${providerId}:`, result)

      if (result?.error) {
        console.error(`❌ OAuth error for ${providerId}:`, result.error)
        
        if (result.error.includes('OAuthAccountNotLinked')) {
          onError('This account is already linked to another user. Please use account linking.')
        } else if (result.error.includes('OAuthCallback')) {
          onError('Failed to connect to the social provider. Please try again.')
        } else if (result.error.includes('AccessDenied')) {
          onError('Access was denied. Please grant permission to continue.')
        } else {
          onError(`Failed to sign in with ${providerId}. Please try again.`)
        }
      } else if (result?.ok) {
        console.log(`✅ ${providerId} sign-in successful, redirecting to:`, callbackUrl)
        window.location.href = callbackUrl
        return
      }
    } catch (error) {
      console.error(`❌ Exception during ${providerId} sign-in:`, error)
      onError('Failed to sign in. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  if (socialProviders.length === 0) {
    return (
      <div className="text-center py-8">
        <div className="text-gray-400 text-4xl mb-4">🌐</div>
        <p className="text-gray-600">No social providers configured</p>
      </div>
    )
  }

  return (
    <div className="space-y-3">
      <div className="text-center text-sm text-gray-600 mb-4">
        Choose your preferred social account
      </div>
      
      {socialProviders.map((provider) => (
        <button
          key={provider.id}
          onClick={() => handleSocialSignIn(provider.id)}
          disabled={isLoading}
          className={`w-full flex items-center justify-center space-x-3 py-3 px-4 border-2 rounded-lg transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed ${getProviderColor(provider.id)}`}
        >
          <span className="text-xl">{getProviderIcon(provider.id)}</span>
          <span>Continue with {provider.name}</span>
        </button>
      ))}

      <div className="mt-6 p-3 bg-gray-50 rounded-lg">
        <p className="text-xs text-gray-600 text-center">
          We'll automatically link this account if you have an existing account with the same email address.
        </p>
      </div>
    </div>
  )
}