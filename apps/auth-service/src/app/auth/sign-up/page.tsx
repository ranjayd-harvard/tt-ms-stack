// src/app/auth/sign-up/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { signIn, getProviders } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import AccountLinkingModal from '@/components/AccountLinkingModal'
import { useAccountLinking } from '@/hooks/useAccountLinking'

type SignUpMethod = 'email' | 'phone' | 'social'

interface Provider {
  id: string
  name: string
  type: string
}

interface LinkingSuggestion {
  shouldSuggest: boolean
  candidates: any[]
  confidence: number
}

export default function UnifiedSignUp() {
  const [activeMethod, setActiveMethod] = useState<SignUpMethod>('email')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [providers, setProviders] = useState<Record<string, Provider>>({})
  const [linkingSuggestion, setLinkingSuggestion] = useState<LinkingSuggestion | null>(null)
  const [newUserId, setNewUserId] = useState<string | null>(null)
  
  const router = useRouter()

  const {
    candidates,
    isLoading: isLinkingLoading,
    error: linkingError,
    showLinkingModal,
    linkAccounts,
    setShowLinkingModal,
    resetState
  } = useAccountLinking()

  useEffect(() => {
    getProviders().then((res) => {
      if (res) {
        // Convert NextAuth providers to our Provider interface
        const mapped = Object.entries(res).reduce((acc, [key, value]) => {
          acc[key] = {
            id: value.id,
            name: value.name,
            type: value.type || 'oauth' // fallback if undefined
          }
          return acc
        }, {} as Record<string, Provider>)
        setProviders(mapped)
      }
    })
  }, [])

  const methods = [
    { 
      id: 'email', 
      label: 'Email', 
      icon: '📧', 
      description: 'Quick setup with email verification',
      recommended: true
    },
    { 
      id: 'phone', 
      label: 'Phone', 
      icon: '📱', 
      description: 'Instant SMS verification' 
    },
    { 
      id: 'social', 
      label: 'Social', 
      icon: '🌐', 
      description: 'One-click with Google, GitHub, etc.' 
    }
  ]

  const handleLinkingSuggestion = (suggestion: LinkingSuggestion, userId: string) => {
    if (suggestion.shouldSuggest && suggestion.candidates.length > 0) {
      setLinkingSuggestion(suggestion)
      setNewUserId(userId)
      setShowLinkingModal(true)
    }
  }

  const handleLinkAccounts = async (primaryUserId: string, secondaryUserIds: string[]) => {
    const success = await linkAccounts(primaryUserId, secondaryUserIds)
    if (success) {
      setSuccess('Account created and linked successfully! Redirecting to your dashboard...')
      setTimeout(() => {
        router.push('/dashboard')
      }, 2000)
    }
  }

  const handleSkipLinking = () => {
    setShowLinkingModal(false)
    setSuccess('Account created successfully! Please check your email to verify your account.')
    resetState()
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        {!success ? (
          <>
            {/* Header */}
            <div className="text-center">
              <div className="mx-auto h-12 w-12 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-xl">✨</span>
              </div>
              <h2 className="mt-6 text-3xl font-extrabold text-gray-900">
                Join us today! 🚀
              </h2>
              <p className="mt-2 text-sm text-gray-600">
                Create your account in seconds using your preferred method
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

            {/* Linking Error */}
            {linkingError && (
              <div className="bg-orange-50 border border-orange-200 rounded-lg p-4">
                <div className="flex">
                  <span className="text-orange-400">🔗</span>
                  <div className="ml-3">
                    <p className="text-sm text-orange-800">{linkingError}</p>
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
                      setActiveMethod(method.id as SignUpMethod)
                      setError('')
                    }}
                    className={`flex-1 py-3 px-2 rounded-md text-sm font-medium transition-all duration-200 relative ${
                      activeMethod === method.id
                        ? 'bg-white text-blue-600 shadow-sm ring-1 ring-blue-100'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    <div className="flex flex-col items-center space-y-1">
                      <span className="text-lg">{method.icon}</span>
                      <span className="font-medium">{method.label}</span>
                      {method.recommended && (
                        <span className="absolute -top-1 -right-1 bg-blue-500 text-white text-xs px-1 rounded-full">
                          ⭐
                        </span>
                      )}
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
              <div className="min-h-[400px]">
                {activeMethod === 'email' && (
                  <EmailSignUpForm 
                    onError={setError}
                    onSuccess={setSuccess}
                    onLinkingSuggestion={handleLinkingSuggestion}
                    isLoading={isLoading}
                    setIsLoading={setIsLoading}
                  />
                )}
                {activeMethod === 'phone' && (
                  <PhoneSignUpForm 
                    onError={setError}
                    onSuccess={setSuccess}
                    isLoading={isLoading}
                    setIsLoading={setIsLoading}
                  />
                )}
                {activeMethod === 'social' && (
                  <SocialSignUpForm 
                    providers={providers}
                    onError={setError}
                    isLoading={isLoading}
                    setIsLoading={setIsLoading}
                  />
                )}
              </div>

              {/* Benefits Section */}
              <div className="mt-8 p-4 bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg border border-blue-100">
                <div className="flex items-start space-x-3">
                  <span className="text-blue-500 text-xl flex-shrink-0">🎯</span>
                  <div className="text-sm text-blue-700">
                    <p className="font-medium">Smart Account Management</p>
                    <p className="mt-1">
                      We automatically detect and link your accounts across different sign-in methods. 
                      This lets you sign in with email, phone, or social accounts seamlessly!
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Footer */}
            <div className="text-center space-y-4">
              <p className="text-sm text-gray-600">
                Already have an account?{' '}
                <Link href="/auth/sign-in" className="font-medium text-blue-600 hover:text-blue-500">
                  Sign in here
                </Link>
              </p>
              <div className="flex items-center justify-center space-x-6 text-xs text-gray-500">
                <Link href="/privacy" className="hover:text-gray-700">Privacy Policy</Link>
                <Link href="/terms" className="hover:text-gray-700">Terms of Service</Link>
              </div>
            </div>
          </>
        ) : (
          /* Success State */
          <div className="text-center">
            <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100 mb-6">
              <span className="text-green-600 text-2xl">🎉</span>
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">Welcome aboard!</h3>
            <p className="text-gray-600 mb-6">{success}</p>
            
            <div className="space-y-4">
              <Link
                href="/auth/sign-in"
                className="block w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors font-medium"
              >
                Sign In to Your Account
              </Link>
              <button
                onClick={() => {
                  setSuccess('')
                  setError('')
                  resetState()
                }}
                className="block w-full text-gray-600 hover:text-gray-800 text-sm"
              >
                Create Another Account
              </button>
            </div>
          </div>
        )}

        {/* Account Linking Modal */}
        <AccountLinkingModal
          isOpen={showLinkingModal}
          onClose={handleSkipLinking}
          candidates={candidates}
          currentUserData={{
            email: '', // Will be filled by the form component
            phoneNumber: '',
            name: '',
            userId: newUserId ?? undefined // Convert null to undefined
          }}
          onConfirmLinking={handleLinkAccounts}
          isLoading={isLinkingLoading}
        />
      </div>
    </div>
  )
}

// Email Sign-Up Form Component
function EmailSignUpForm({ 
  onError, 
  onSuccess, 
  onLinkingSuggestion,
  isLoading,
  setIsLoading
}: {
  onError: (error: string) => void
  onSuccess: (message: string) => void
  onLinkingSuggestion: (suggestion: any, userId: string) => void
  isLoading: boolean
  setIsLoading: (loading: boolean) => void
}) {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: ''
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    // Validation
    if (formData.password !== formData.confirmPassword) {
      onError('Passwords do not match')
      setIsLoading(false)
      return
    }

    if (formData.password.length < 6) {
      onError('Password must be at least 6 characters')
      setIsLoading(false)
      return
    }

    try {
      const response = await fetch('/api/auth/enhanced-register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: formData.name,
          email: formData.email,
          password: formData.password
        })
      })

      const data = await response.json()

      if (response.ok) {
        if (data.autoLinked) {
          onSuccess('Account created and automatically linked! Please check your email to verify your account.')
        } else if (data.linkingSuggestion?.shouldSuggest) {
          onLinkingSuggestion(data.linkingSuggestion, data.userId)
        } else {
          onSuccess('Account created successfully! Please check your email to verify your account.')
        }
      } else {
        onError(data.error || 'Registration failed')
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error)
      onError('Registration failed. Please try again.' + errorMessage)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-1">
          Full Name
        </label>
        <input
          id="name"
          type="text"
          required
          value={formData.name}
          onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
          className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          placeholder="Enter your full name"
          disabled={isLoading}
        />
      </div>

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
          placeholder="Create a password (min. 6 characters)"
          disabled={isLoading}
        />
      </div>

      <div>
        <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700 mb-1">
          Confirm Password
        </label>
        <input
          id="confirmPassword"
          type="password"
          required
          value={formData.confirmPassword}
          onChange={(e) => setFormData(prev => ({ ...prev, confirmPassword: e.target.value }))}
          className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          placeholder="Confirm your password"
          disabled={isLoading}
        />
      </div>

      <div className="flex items-center">
        <input
          id="terms"
          type="checkbox"
          required
          className="h-4 w-4 text-blue-600 rounded border-gray-300"
        />
        <label htmlFor="terms" className="ml-2 text-sm text-gray-600">
          I agree to the{' '}
          <Link href="/terms" className="text-blue-600 hover:text-blue-500">
            Terms of Service
          </Link>{' '}
          and{' '}
          <Link href="/privacy" className="text-blue-600 hover:text-blue-500">
            Privacy Policy
          </Link>
        </label>
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
      >
        {isLoading ? (
          <div className="flex items-center justify-center space-x-2">
            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
            <span>Creating account...</span>
          </div>
        ) : (
          'Create Account with Email'
        )}
      </button>
    </form>
  )
}

// Phone Sign-Up Form Component
function PhoneSignUpForm({ 
  onError, 
  onSuccess, 
  isLoading, 
  setIsLoading 
}: {
  onError: (error: string) => void
  onSuccess: (message: string) => void
  isLoading: boolean
  setIsLoading: (loading: boolean) => void
}) {
  const [step, setStep] = useState<'phone' | 'verify'>('phone')
  const [formData, setFormData] = useState({
    name: '',
    phoneNumber: '',
    countryCode: 'US',
    verificationCode: ''
  })

  const handlePhoneSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    try {
      const response = await fetch('/api/auth/enhanced-phone-register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: formData.name,
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
      const errorMessage = error instanceof Error ? error.message : String(error)
      onError('Failed to send verification code.' + errorMessage)
    } finally {
      setIsLoading(false)
    }
  }

  const handleVerifySubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    onError('')

    try {
      const response = await fetch('/api/auth/verify-phone', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          phoneNumber: formData.phoneNumber,
          code: formData.verificationCode
        })
      })

      const data = await response.json()

      if (response.ok) {
        onSuccess('Phone verified successfully! You can now sign in.')
      } else {
        onError(data.error || 'Verification failed')
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error)
      onError('Verification failed.' + errorMessage)
    } finally {
      setIsLoading(false)
    }
  }

  if (step === 'verify') {
    return (
      <form onSubmit={handleVerifySubmit} className="space-y-4">
        <div className="text-center mb-6">
          <div className="text-4xl mb-3">📱</div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">Verify Your Phone</h3>
          <p className="text-sm text-gray-600">
            We sent a code to {formData.phoneNumber}
          </p>
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
            'Verify & Complete Sign Up'
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
        <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-1">
          Full Name
        </label>
        <input
          id="name"
          type="text"
          required
          value={formData.name}
          onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
          className="w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          placeholder="Enter your full name"
          disabled={isLoading}
        />
      </div>

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

// Social Sign-Up Form Component
function SocialSignUpForm({ 
  providers, 
  onError, 
  isLoading, 
  setIsLoading 
}: {
  providers: Record<string, Provider>
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

  const handleSocialSignUp = async (providerId: string) => {
    setIsLoading(true)
    onError('')

    try {
      await signIn(providerId, { callbackUrl: '/dashboard' })
    } catch (error) {
      onError('Failed to sign up. Please try again.')
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
    <div className="space-y-4">
      <div className="text-center text-sm text-gray-600 mb-6">
        Choose your preferred social account to continue
      </div>
      
      {socialProviders.map((provider) => (
        <button
          key={provider.id}
          onClick={() => handleSocialSignUp(provider.id)}
          disabled={isLoading}
          className={`w-full flex items-center justify-center space-x-3 py-4 px-4 border-2 rounded-lg transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed ${getProviderColor(provider.id)}`}
        >
          <span className="text-xl">{getProviderIcon(provider.id)}</span>
          <span>Continue with {provider.name}</span>
        </button>
      ))}

      <div className="mt-6 p-4 bg-gradient-to-r from-green-50 to-blue-50 rounded-lg border border-green-200">
        <div className="flex items-start space-x-2">
          <span className="text-green-500 text-lg">✨</span>
          <div className="text-sm text-green-700">
            <p className="font-medium">Instant Account Linking</p>
            <p className="mt-1">
              If you have existing accounts with the same email, we'll automatically link them together!
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}