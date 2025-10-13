import React from 'react'
import { render, RenderOptions } from '@testing-library/react'
import { act } from '@testing-library/react'

interface CustomRenderOptions extends Omit<RenderOptions, 'wrapper'> {
    // Add custom options here if needed in the future
}

/**
 * Custom render function that provides consistent testing setup
 * Use this instead of the default render from @testing-library/react
 */
export function customRender(
    ui: React.ReactElement,
    options: CustomRenderOptions = {}
) {
    return render(ui, {
        ...options,
    })
}

/**
 * Render component with automatic act() wrapping for async operations
 * Use this when you need to handle async state updates
 */
export async function renderWithAct(
    ui: React.ReactElement,
    options: CustomRenderOptions = {}
) {
    let result: any
    await act(async () => {
        result = customRender(ui, options)
    })
    return result
}

/**
 * Helper for user interactions that need act() wrapping
 * Use this when simulating user events that trigger async operations
 */
export async function userEventWithAct(
    userEvent: any,
    element: HTMLElement,
    action: () => Promise<void>
) {
    await act(async () => {
        await action()
    })
}


// Re-export everything from testing-library for convenience
export * from '@testing-library/react'
export { customRender as render }
