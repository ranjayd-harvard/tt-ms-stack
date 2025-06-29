// Shared types for tt-ms-stack

export interface AuthUser {
  id: string
  email?: string | null
  name?: string | null
  image?: string | null
  registerSource?: string
  groupId?: string
  hasLinkedAccounts?: boolean
  services?: any
}

export interface AuthResponse {
  authenticated: boolean
  user?: AuthUser
  error?: string
}

export interface ServiceResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  timestamp: string
}

export interface PaginatedResponse<T> {
  items: T[]
  total: number
  page: number
  limit: number
  hasMore: boolean
}

export interface MicroserviceConfig {
  name: string
  port: number
  authServiceUrl: string
  databaseUrl?: string
  requiredPermissions?: string[]
}
