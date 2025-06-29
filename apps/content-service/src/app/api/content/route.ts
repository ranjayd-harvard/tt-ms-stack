import { NextRequest, NextResponse } from 'next/server'
import { AuthClient } from '../../../lib/auth-client'

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

    // Mock content data - replace with actual database queries
    const content = [
      { 
        id: '1', 
        title: 'Welcome to Our Platform',
        type: 'article' as const,
        author: 'System Admin',
        createdAt: '2024-01-15',
        status: 'published' as const
      },
      { 
        id: '2', 
        title: 'Getting Started Guide',
        type: 'article' as const,
        author: authResult.user?.name || 'Unknown Author',
        createdAt: '2024-01-14',
        status: 'draft' as const
      },
      { 
        id: '3', 
        title: 'User Announcement',
        type: 'post' as const,
        author: 'Content Team',
        createdAt: '2024-01-13',
        status: 'published' as const
      },
      { 
        id: '4', 
        title: 'Company Logo',
        type: 'media' as const,
        author: 'Design Team',
        createdAt: '2024-01-12',
        status: 'published' as const
      },
      { 
        id: '5', 
        title: 'Draft Article',
        type: 'article' as const,
        author: authResult.user?.name || 'Current User',
        createdAt: new Date().toISOString().split('T')[0],
        status: 'draft' as const
      },
    ]

    return NextResponse.json({ 
      content,
      total: content.length,
      currentUser: authResult.user 
    })
  } catch (error) {
    console.error('Get content error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch content' },
      { status: 500 }
    )
  }
}

export async function POST(req: NextRequest) {
  try {
    const authClient = new AuthClient()
    const authResult = await authClient.verifyTokenLocal(req)

    if (!authResult.authenticated) {
      return NextResponse.json(
        { error: 'Authentication required' },
        { status: 401 }
      )
    }

    const { title, type, content } = await req.json()

    if (!title || !type) {
      return NextResponse.json(
        { error: 'Title and type are required' },
        { status: 400 }
      )
    }

    // Mock content creation - replace with actual database insertion
    const newContent = {
      id: Date.now().toString(),
      title,
      type,
      content,
      author: authResult.user?.name || 'Unknown Author',
      createdAt: new Date().toISOString().split('T')[0],
      status: 'draft' as const
    }

    return NextResponse.json({ 
      success: true,
      content: newContent,
      message: 'Content created successfully'
    })
  } catch (error) {
    console.error('Create content error:', error)
    return NextResponse.json(
      { error: 'Failed to create content' },
      { status: 500 }
    )
  }
}
