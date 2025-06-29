import { NextRequest, NextResponse } from 'next/server'

// Proxy all auth requests to the main Auth Service
export async function GET(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  
  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}

export async function POST(request: NextRequest) {
  const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3000'
  const url = request.url.replace(request.nextUrl.origin, authServiceUrl)
  const body = await request.text()
  
  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': request.headers.get('cookie') || '',
      },
      body,
    })
    
    const data = await response.text()
    
    return new NextResponse(data, {
      status: response.status,
      headers: {
        'Content-Type': response.headers.get('content-type') || 'application/json',
        'Set-Cookie': response.headers.get('set-cookie') || '',
      },
    })
  } catch (error) {
    console.error('Auth proxy error:', error)
    return NextResponse.json({ error: 'Authentication service unavailable' }, { status: 503 })
  }
}
