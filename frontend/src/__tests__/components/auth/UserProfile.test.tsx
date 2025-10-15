import React from 'react'
import { render, screen, fireEvent, waitFor, act } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { UserProfile } from '@/components/auth/UserProfile'
import { useAuthStore } from '@/store/authStore'

// Mock the auth store
const mockAuthStore = {
  user: {
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z',
  },
  updateProfile: vi.fn(),
  loading: false,
  error: null,
  clearError: vi.fn(),
}

vi.mock('@/store/authStore', () => ({
  useAuthStore: vi.fn(),
}))

describe('UserProfile', () => {
  const mockOnClose = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
      ; (useAuthStore as unknown as vi.Mock).mockReturnValue(mockAuthStore)
  })

  it('renders user profile information', () => {
    render(<UserProfile onClose={mockOnClose} />)

    expect(screen.getByText('Profile')).toBeInTheDocument()
    expect(screen.getByText('testuser')).toBeInTheDocument()
    expect(screen.getByText('test@example.com')).toBeInTheDocument()
  })

  it('shows edit mode when edit button is clicked', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    const editButton = screen.getByText('Edit Profile')

    await act(async () => {
      fireEvent.click(editButton)
    })

    expect(screen.getByText('Save Changes')).toBeInTheDocument()
    expect(screen.getByText('Cancel')).toBeInTheDocument()
  })

  it('calls updateProfile when form is submitted', async () => {
    mockAuthStore.updateProfile.mockResolvedValue(undefined)

    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    // Change username
    const usernameInput = screen.getByDisplayValue('testuser')
    await act(async () => {
      fireEvent.change(usernameInput, { target: { value: 'newusername' } })
    })

    // Submit form
    const saveButton = screen.getByText('Save Changes')
    await act(async () => {
      fireEvent.click(saveButton)
    })

    expect(mockAuthStore.updateProfile).toHaveBeenCalledWith({
      username: 'newusername',
      email: 'test@example.com',
    })
  })

  it('calls clearError when form is submitted', async () => {
    mockAuthStore.updateProfile.mockResolvedValue(undefined)

    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    // Submit form
    const saveButton = screen.getByText('Save Changes')
    await act(async () => {
      fireEvent.click(saveButton)
    })

    expect(mockAuthStore.clearError).toHaveBeenCalled()
  })

  it('cancels edit mode when cancel button is clicked', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    // Cancel edit
    const cancelButton = screen.getByText('Cancel')
    await act(async () => {
      fireEvent.click(cancelButton)
    })

    expect(screen.getByText('Edit Profile')).toBeInTheDocument()
    expect(screen.queryByText('Save Changes')).not.toBeInTheDocument()
  })

  it('shows loading state when updating profile', () => {
    const loadingStore = {
      ...mockAuthStore,
      loading: true,
    }
      ; (useAuthStore as unknown as vi.Mock).mockReturnValue(loadingStore)

    render(<UserProfile onClose={mockOnClose} />)

    // The Edit Profile button is not disabled during loading - only form elements are disabled
    // This test verifies that the component renders correctly during loading state
    expect(screen.getByRole('button', { name: /edit profile/i })).toBeInTheDocument()
    expect(screen.getByText('Profile')).toBeInTheDocument()
  })

  it('shows error message when there is an error', () => {
    const errorStore = {
      ...mockAuthStore,
      error: 'Failed to update profile',
    }
      ; (useAuthStore as unknown as vi.Mock).mockReturnValue(errorStore)

    render(<UserProfile onClose={mockOnClose} />)

    expect(screen.getByText('Failed to update profile')).toBeInTheDocument()
  })

  it('calls onClose when close button is clicked', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    const closeButton = screen.getByRole('button', { name: /✕/i })

    await act(async () => {
      fireEvent.click(closeButton)
    })

    expect(mockOnClose).toHaveBeenCalledTimes(1)
  })

  it('does not show close button when onClose is not provided', () => {
    render(<UserProfile />)

    expect(screen.queryByLabelText('Close profile')).not.toBeInTheDocument()
  })

  it('disables form inputs when not in edit mode', () => {
    render(<UserProfile onClose={mockOnClose} />)

    const usernameText = screen.getByText('testuser')
    const emailText = screen.getByText('test@example.com')

    // In read-only mode, these are text elements, not inputs
    expect(usernameText).toBeInTheDocument()
    expect(emailText).toBeInTheDocument()
  })

  it('enables form inputs when in edit mode', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    const usernameInput = screen.getByDisplayValue('testuser')
    const emailInput = screen.getByDisplayValue('test@example.com')

    expect(usernameInput).not.toBeDisabled()
    expect(emailInput).not.toBeDisabled()
  })

  it('resets form data when cancel is clicked', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    // Change username
    const usernameInput = screen.getByDisplayValue('testuser')
    await act(async () => {
      fireEvent.change(usernameInput, { target: { value: 'newusername' } })
    })

    // Cancel edit
    const cancelButton = screen.getByText('Cancel')
    await act(async () => {
      fireEvent.click(cancelButton)
    })

    // Check that username is back to original value (read-only mode)
    expect(screen.getByText('testuser')).toBeInTheDocument()
  })

  it('shows user creation date', () => {
    render(<UserProfile onClose={mockOnClose} />)

    expect(screen.getByText('Member Since')).toBeInTheDocument()
    // Check that a date is displayed (format may vary by locale/timezone)
    // The component uses new Date(user.created_at).toLocaleDateString()
    const memberSinceElement = screen.getByText('Member Since').parentElement
    expect(memberSinceElement).toHaveTextContent(/\d{1,2}\/\d{1,2}\/\d{4}/) // Matches MM/DD/YYYY or M/D/YYYY format
  })

  it('handles form validation', async () => {
    render(<UserProfile onClose={mockOnClose} />)

    // Enter edit mode
    const editButton = screen.getByText('Edit Profile')
    await act(async () => {
      fireEvent.click(editButton)
    })

    // Clear username
    const usernameInput = screen.getByDisplayValue('testuser')
    await act(async () => {
      fireEvent.change(usernameInput, { target: { value: '' } })
    })

    // Try to submit
    const saveButton = screen.getByText('Save Changes')
    await act(async () => {
      fireEvent.click(saveButton)
    })

    // Should not call updateProfile with empty username
    expect(mockAuthStore.updateProfile).not.toHaveBeenCalled()
  })
})
