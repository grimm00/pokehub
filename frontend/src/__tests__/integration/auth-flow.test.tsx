import { describe, it, expect, vi } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import { fireEvent } from '@testing-library/react'
import { act } from 'react'
import { BrowserRouter } from 'react-router-dom'
import { server } from '../setup/msw-server'
import { http, HttpResponse } from 'msw'
import { LoginForm } from '@/components/auth/LoginForm'

describe('Authentication Flow Integration Tests', () => {
  it('successfully logs in user with valid credentials', async () => {
    const mockOnSuccess = vi.fn()
    
    render(
      <BrowserRouter>
        <LoginForm onSuccess={mockOnSuccess} />
      </BrowserRouter>
    )

    // Fill in login form
    await act(async () => {
      fireEvent.change(screen.getByLabelText(/username or email/i), {
        target: { value: 'test@example.com' }
      })
      fireEvent.change(screen.getByLabelText(/password/i), {
        target: { value: 'password123' }
      })
    })

    // Submit form
    await act(async () => {
      fireEvent.click(screen.getByRole('button', { name: /login/i }))
    })

    // Wait for success
    await waitFor(() => {
      expect(mockOnSuccess).toHaveBeenCalled()
    })
  })

  it('shows error message on failed login', async () => {
    // Override handler to return error
    server.use(
      http.post('http://localhost:5000/api/v1/auth/login', () => {
        return HttpResponse.json(
          { message: 'Invalid credentials' },
          { status: 401 }
        )
      })
    )

    const mockOnSuccess = vi.fn()
    
    render(
      <BrowserRouter>
        <LoginForm onSuccess={mockOnSuccess} />
      </BrowserRouter>
    )

    // Fill and submit form
    await act(async () => {
      fireEvent.change(screen.getByLabelText(/username or email/i), {
        target: { value: 'test@example.com' }
      })
      fireEvent.change(screen.getByLabelText(/password/i), {
        target: { value: 'wrongpassword' }
      })
      fireEvent.click(screen.getByRole('button', { name: /login/i }))
    })

    // Should show error
    await waitFor(() => {
      expect(screen.getByText(/invalid credentials/i)).toBeInTheDocument()
    })
    expect(mockOnSuccess).not.toHaveBeenCalled()
  })
})
