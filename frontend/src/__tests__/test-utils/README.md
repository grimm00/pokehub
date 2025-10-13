# Test Utilities

This directory contains shared testing utilities to reduce boilerplate and improve consistency across frontend tests.

## Files

- `custom-render.tsx` - Custom render functions with act() handling
- `test-helpers.ts` - Common test helpers and mock data
- `setup.ts` - Test setup configuration (existing)

## Usage

### Custom Render

Instead of importing `render` from `@testing-library/react`, use our custom render:

```typescript
import { render, renderWithAct } from '@/__tests__/test-utils/custom-render'

// For simple rendering
const { getByText } = render(<MyComponent />)

// For async operations that need act() wrapping
const { getByText } = await renderWithAct(<MyComponent />)
```

### Test Helpers

Import common helpers and mock data:

```typescript
import { 
  waitForAsync, 
  mockPokemon, 
  mockUser, 
  createMockStore 
} from '@/__tests__/test-utils/test-helpers'

// Wait for async operations
await waitForAsync()

// Use common mock data
const pokemon = mockPokemon
const user = mockUser

// Create mock store
const mockStore = createMockStore({ user: mockUser })
```

### User Events with Act()

For user interactions that trigger async operations:

```typescript
import { userEventWithAct } from '@/__tests__/test-utils/custom-render'
import userEvent from '@testing-library/user-event'

// Wrap user events that trigger async operations
await userEventWithAct(userEvent, button, () => userEvent.click(button))
```

### Fire Events with Act()

For fireEvent operations that trigger async operations:

```typescript
import { fireEventWithAct } from '@/__tests__/test-utils/custom-render'
import { fireEvent } from '@testing-library/react'

// Wrap fireEvent operations that trigger async operations
await fireEventWithAct(fireEvent, input, { target: { value: 'test' } })
```

## Best Practices

1. **Always use custom render** instead of the default render
2. **Use renderWithAct** for components with async operations
3. **Wrap user interactions** in act() when they trigger state updates
4. **Use shared mock data** for consistency
5. **Import helpers** to reduce boilerplate

## Migration Guide

To update existing tests to use the new utilities:

1. **Update imports:**
   ```typescript
   // Old
   import { render, act } from '@testing-library/react'
   
   // New
   import { render, renderWithAct } from '@/__tests__/test-utils/custom-render'
   ```

2. **Replace act() usage:**
   ```typescript
   // Old
   await act(async () => {
     fireEvent.change(input, { target: { value: 'test' } })
   })
   
   // New
   await fireEventWithAct(fireEvent, input, { target: { value: 'test' } })
   ```

3. **Use shared mock data:**
   ```typescript
   // Old
   const mockPokemon = { id: 1, name: 'Pikachu', ... }
   
   // New
   import { mockPokemon } from '@/__tests__/test-utils/test-helpers'
   ```

## Benefits

- **Reduced boilerplate** - Less repetitive code in tests
- **Consistent act() handling** - No more act() warnings
- **Shared mock data** - Consistent test data across components
- **Better maintainability** - Centralized test utilities
- **Improved readability** - Clear intent with helper functions
