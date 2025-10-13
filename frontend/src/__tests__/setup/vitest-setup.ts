import { beforeAll, afterEach, afterAll, vi } from 'vitest'
import { server } from './msw-server'

// Mock window.alert for tests
global.alert = vi.fn()

// Start server before all tests
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }))

// Reset handlers after each test
afterEach(() => server.resetHandlers())

// Clean up after all tests
afterAll(() => server.close())
