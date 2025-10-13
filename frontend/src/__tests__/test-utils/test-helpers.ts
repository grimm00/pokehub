import { act } from '@testing-library/react'
import { beforeEach, afterEach, vi } from 'vitest'

/**
 * Common test helpers to reduce boilerplate and improve consistency
 */

/**
 * Wait for async operations to complete
 * Use this when you need to wait for state updates or API calls
 */
export async function waitForAsync() {
    await act(async () => {
        // Allow any pending promises to resolve
        await new Promise(resolve => setTimeout(resolve, 0))
    })
}

/**
 * Mock console methods to avoid noise in tests
 * Use this in beforeEach to suppress expected console warnings
 */
export function mockConsole() {
    const originalError = console.error
    const originalWarn = console.warn

    beforeEach(() => {
        console.error = vi.fn()
        console.warn = vi.fn()
    })

    afterEach(() => {
        console.error = originalError
        console.warn = originalWarn
    })
}

/**
 * Create a mock function with proper typing
 * Use this for consistent mock creation
 */
export function createMockFunction<T extends (...args: any[]) => any>(
    implementation?: T
): ReturnType<typeof vi.fn<T>> {
    return vi.fn(implementation)
}

/**
 * Common mock data for Pokemon components
 */
export const mockPokemon = {
    id: 1,
    pokemon_id: 25,
    name: 'Pikachu',
    types: ['electric'],
    height: 4,
    weight: 60,
    abilities: ['static', 'lightning-rod'],
    stats: {
        hp: 35,
        attack: 55,
        defense: 40,
        'special-attack': 50,
        'special-defense': 50,
        speed: 90
    },
    sprites: {
        front_default: 'https://example.com/pikachu.png',
        front_animated: 'https://example.com/pikachu.gif'
    },
}

/**
 * Common mock data for user authentication
 */
export const mockUser = {
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
}

/**
 * Common mock data for generations
 */
export const mockGenerations = [
    {
        generation: 1,
        name: 'Kanto',
        region: 'Kanto',
        year: 1996,
        pokemon_count: 151,
        expected_count: 151,
        color: '#FF0000',
        games: ['Red', 'Blue'],
        description: 'First generation'
    },
    {
        generation: 2,
        name: 'Johto',
        region: 'Johto',
        year: 1999,
        pokemon_count: 100,
        expected_count: 100,
        color: '#00FF00',
        games: ['Gold', 'Silver'],
        description: 'Second generation'
    },
]

/**
 * Helper to create mock Zustand store
 */
export function createMockStore<T>(initialState: T) {
    return {
        ...initialState,
        // Add common store methods that might be needed
        setState: vi.fn(),
        getState: vi.fn(() => initialState),
        subscribe: vi.fn(),
        destroy: vi.fn(),
    }
}

/**
 * Helper to wait for element to appear/disappear
 * Use this instead of waitFor for simple visibility checks
 */
export async function waitForElement(
    queryFn: () => HTMLElement | null,
    options: { timeout?: number; interval?: number } = {}
) {
    const { timeout = 1000, interval = 50 } = options

    return new Promise<HTMLElement>((resolve, reject) => {
        const startTime = Date.now()

        const check = () => {
            const element = queryFn()
            if (element) {
                resolve(element)
            } else if (Date.now() - startTime > timeout) {
                reject(new Error(`Element not found within ${timeout}ms`))
            } else {
                setTimeout(check, interval)
            }
        }

        check()
    })
}
