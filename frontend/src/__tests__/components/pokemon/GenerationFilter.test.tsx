import React from 'react'
import { render, screen, fireEvent } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach } from 'vitest'
import GenerationFilter from '@/components/pokemon/GenerationFilter'

const mockGenerations = [
  {
    generation: 1,
    name: 'Generation I',
    region: 'Kanto',
    year: 1996,
    pokemon_count: 151,
    expected_count: 151,
    color: '#FF6B6B',
    games: ['Red', 'Blue', 'Yellow'],
    description: 'The original 151 Pokemon',
    is_complete: true,
  },
  {
    generation: 2,
    name: 'Generation II',
    region: 'Johto',
    year: 1999,
    pokemon_count: 100,
    expected_count: 100,
    color: '#4ECDC4',
    games: ['Gold', 'Silver', 'Crystal'],
    description: 'The second generation',
    is_complete: true,
  },
  {
    generation: 3,
    name: 'Generation III',
    region: 'Hoenn',
    year: 2002,
    pokemon_count: 135,
    expected_count: 135,
    color: '#45B7D1',
    games: ['Ruby', 'Sapphire', 'Emerald'],
    description: 'The third generation',
    is_complete: true,
  },
]

describe('GenerationFilter', () => {
  const mockOnGenerationChange = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders loading state', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={[]}
        isLoading={true}
      />
    )

    expect(screen.getByText('Filter by Generation:')).toBeInTheDocument()
    expect(document.querySelector('.animate-pulse')).toBeInTheDocument()
    expect(document.querySelectorAll('.generation-chip-skeleton')).toHaveLength(3)
  })

  it('renders generation filter with all option', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    expect(screen.getByText('Filter by Generation:')).toBeInTheDocument()
    expect(screen.getByText('All Generations')).toBeInTheDocument()
  })

  it('renders all generation options', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    // Check that all generation buttons are rendered
    expect(screen.getByText('All Generations')).toBeInTheDocument()
    expect(screen.getByText('Gen 1')).toBeInTheDocument()
    expect(screen.getByText('Generation I')).toBeInTheDocument()
    expect(screen.getByText('151')).toBeInTheDocument()
    expect(screen.getByText('Gen 2')).toBeInTheDocument()
    expect(screen.getByText('Generation II')).toBeInTheDocument()
    expect(screen.getByText('100')).toBeInTheDocument()
    expect(screen.getByText('Gen 3')).toBeInTheDocument()
    expect(screen.getByText('Generation III')).toBeInTheDocument()
    expect(screen.getByText('135')).toBeInTheDocument()
  })

  it('calls onGenerationChange when selection changes', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    const gen1Button = screen.getByRole('button', { name: /gen 1/i })
    fireEvent.click(gen1Button)

    expect(mockOnGenerationChange).toHaveBeenCalledWith(1)
  })

  it('calls onGenerationChange with "all" when All Generations is selected', () => {
    render(
      <GenerationFilter
        selectedGeneration={1}
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    const allButton = screen.getByRole('button', { name: /all generations/i })
    fireEvent.click(allButton)

    expect(mockOnGenerationChange).toHaveBeenCalledWith('all')
  })

  it('shows correct selected value', () => {
    render(
      <GenerationFilter
        selectedGeneration={2}
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    // Check that the correct button is active
    const gen2Button = screen.getByRole('button', { name: /gen 2/i })
    expect(gen2Button).toHaveClass('active')

    // Check that generation info is displayed
    expect(screen.getByText('Generation II Region (Gen 2)')).toBeInTheDocument()
    expect(screen.getByText('1999 • 100 Pokemon • Gold, Silver, Crystal')).toBeInTheDocument()
  })

  it('handles empty generations array', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={[]}
        isLoading={false}
      />
    )

    expect(screen.getByText('Filter by Generation:')).toBeInTheDocument()
    expect(screen.getByText('All Generations')).toBeInTheDocument()

    // Should only have the "All Generations" button
    const buttons = screen.getAllByRole('button')
    expect(buttons).toHaveLength(1)
  })

  it('displays generation information correctly', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    // Check that generation details are displayed correctly
    expect(screen.getByText('Gen 1')).toBeInTheDocument()
    expect(screen.getByText('Generation I')).toBeInTheDocument()
    expect(screen.getByText('151')).toBeInTheDocument()
    expect(screen.getByText('Gen 2')).toBeInTheDocument()
    expect(screen.getByText('Generation II')).toBeInTheDocument()
    expect(screen.getByText('100')).toBeInTheDocument()
    expect(screen.getByText('Gen 3')).toBeInTheDocument()
    expect(screen.getByText('Generation III')).toBeInTheDocument()
    expect(screen.getByText('135')).toBeInTheDocument()
  })

  it('handles generation with different pokemon counts', () => {
    const generationsWithDifferentCounts = [
      {
        ...mockGenerations[0],
        pokemon_count: 50,
        expected_count: 151,
      },
      {
        ...mockGenerations[1],
        pokemon_count: 100,
        expected_count: 100,
      },
    ]

    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={generationsWithDifferentCounts}
        isLoading={false}
      />
    )

    expect(screen.getByText('Gen 1')).toBeInTheDocument()
    expect(screen.getByText('Generation I')).toBeInTheDocument()
    expect(screen.getByText('50')).toBeInTheDocument()
    expect(screen.getByText('Gen 2')).toBeInTheDocument()
    expect(screen.getByText('Generation II')).toBeInTheDocument()
    expect(screen.getByText('100')).toBeInTheDocument()
  })

  it('has correct accessibility attributes', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    // Check that buttons have proper accessibility attributes
    const allButton = screen.getByRole('button', { name: /all generations/i })
    expect(allButton).toBeInTheDocument()

    const gen1Button = screen.getByRole('button', { name: /gen 1/i })
    expect(gen1Button).toBeInTheDocument()
    expect(gen1Button).toHaveAttribute('title', 'The original 151 Pokemon (1996)')
  })

  it('applies correct CSS classes', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )

    // Check that the container has correct classes
    const container = document.querySelector('.generation-filter')
    expect(container).toBeInTheDocument()

    // Check that the active button has correct classes
    const allButton = screen.getByRole('button', { name: /all generations/i })
    expect(allButton).toHaveClass('generation-chip', 'active')
  })
})
