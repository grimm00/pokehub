import React from 'react'
import { render, screen, waitFor } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach, afterEach } from 'vitest'
import { BrowserRouter } from 'react-router-dom'
import { ProtectedRoute } from '@/components/auth/ProtectedRoute'
import { useAuthStore } from '@/store/authStore'

// Mock react-router-dom
const mockNavigate = vi.fn()
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom')
  return {
    ...actual,
    useNavigate: () => mockNavigate,
  }
})

// Mock localStorage
const mockLocalStorage = {
  getItem: vi.fn(),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn(),
}
Object.defineProperty(window, 'localStorage', {
  value: mockLocalStorage,
})

// Mock the auth store
const mockAuthStore = {
  isAuthenticated: false,
  loading: false,
  refreshAuth: vi.fn(),
}

vi.mock('@/store/authStore', () => ({
  useAuthStore: vi.fn(),
}))

const TestComponent = () => <div>Protected Content</div>

const renderWithRouter = (component: React.ReactElement) => {
  return render(
    <BrowserRouter>
      {component}
    </BrowserRouter>
  )
}

describe('ProtectedRoute', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(mockAuthStore)
  })

  afterEach(() => {
    vi.clearAllMocks()
  })

  it('renders loading state when loading', () => {
    const loadingStore = {
      ...mockAuthStore,
      loading: true,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(loadingStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    expect(screen.getByRole('status')).toBeInTheDocument()
    expect(document.querySelector('.animate-spin')).toBeInTheDocument()
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument()
  })

  it('renders children when authenticated', async () => {
    const authenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: true,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(authenticatedStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(screen.getByText('Protected Content')).toBeInTheDocument()
    })
  })

  it('redirects to login when not authenticated and no token', async () => {
    mockLocalStorage.getItem.mockReturnValue(null)
    
    const unauthenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: false,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(unauthenticatedStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalledWith('/auth')
    })
    
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument()
  })

  it('calls refreshAuth when token exists but not authenticated', async () => {
    mockLocalStorage.getItem.mockReturnValue('valid-token')
    mockAuthStore.refreshAuth.mockResolvedValue(undefined)
    
    const storeWithToken = {
      ...mockAuthStore,
      isAuthenticated: false,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(storeWithToken)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(mockAuthStore.refreshAuth).toHaveBeenCalled()
    })
  })

  it('redirects to login when refreshAuth fails', async () => {
    mockLocalStorage.getItem.mockReturnValue('invalid-token')
    mockAuthStore.refreshAuth.mockRejectedValue(new Error('Refresh failed'))
    
    const storeWithToken = {
      ...mockAuthStore,
      isAuthenticated: false,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(storeWithToken)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(mockAuthStore.refreshAuth).toHaveBeenCalled()
      expect(mockNavigate).toHaveBeenCalledWith('/auth')
    })
  })

  it('does not redirect when refreshAuth succeeds', async () => {
    mockLocalStorage.getItem.mockReturnValue('valid-token')
    mockAuthStore.refreshAuth.mockResolvedValue(undefined)
    
    // After refresh, user becomes authenticated
    const storeAfterRefresh = {
      ...mockAuthStore,
      isAuthenticated: true,
      loading: false,
    }
    
    // Mock the store to return different values on subsequent calls
    let callCount = 0
    ;(useAuthStore as unknown as vi.Mock).mockImplementation(() => {
      callCount++
      if (callCount === 1) {
        return {
          ...mockAuthStore,
          isAuthenticated: false,
          loading: false,
        }
      }
      return storeAfterRefresh
    })
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(mockAuthStore.refreshAuth).toHaveBeenCalled()
    })
    
    // Should not navigate to login
    expect(mockNavigate).not.toHaveBeenCalledWith('/auth')
  })

  it('does not call refreshAuth when already authenticated', async () => {
    mockLocalStorage.getItem.mockReturnValue('valid-token')
    
    const authenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: true,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(authenticatedStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(screen.getByText('Protected Content')).toBeInTheDocument()
    })
    
    expect(mockAuthStore.refreshAuth).not.toHaveBeenCalled()
    expect(mockNavigate).not.toHaveBeenCalled()
  })

  it('does not call refreshAuth when loading', async () => {
    mockLocalStorage.getItem.mockReturnValue('valid-token')
    
    const loadingStore = {
      ...mockAuthStore,
      isAuthenticated: false,
      loading: true,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(loadingStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    expect(mockAuthStore.refreshAuth).not.toHaveBeenCalled()
    expect(mockNavigate).not.toHaveBeenCalled()
  })

  it('renders nothing when not authenticated (will redirect)', async () => {
    mockLocalStorage.getItem.mockReturnValue(null)
    
    const unauthenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: false,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(unauthenticatedStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalledWith('/auth')
    })
    
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument()
  })

  it('handles multiple children correctly', async () => {
    const authenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: true,
      loading: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(authenticatedStore)
    
    renderWithRouter(
      <ProtectedRoute>
        <div>Child 1</div>
        <div>Child 2</div>
        <TestComponent />
      </ProtectedRoute>
    )
    
    await waitFor(() => {
      expect(screen.getByText('Child 1')).toBeInTheDocument()
      expect(screen.getByText('Child 2')).toBeInTheDocument()
      expect(screen.getByText('Protected Content')).toBeInTheDocument()
    })
  })
})
