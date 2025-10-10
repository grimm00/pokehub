import React from 'react'
import { render, screen, fireEvent } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { GenerationFilter } from '@/components/pokemon/GenerationFilter'

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
    
    expect(screen.getByText('Loading generations...')).toBeInTheDocument()
    expect(document.querySelector('.animate-pulse')).toBeInTheDocument()
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
    
    expect(screen.getByLabelText('Filter by generation')).toBeInTheDocument()
    expect(screen.getByDisplayValue('All Generations')).toBeInTheDocument()
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
    
    const select = screen.getByLabelText('Filter by generation')
    expect(select).toBeInTheDocument()
    
    // Check that all generations are available as options
    expect(screen.getByText('All Generations')).toBeInTheDocument()
    expect(screen.getByText('Generation I (Kanto) - 151 Pokemon')).toBeInTheDocument()
    expect(screen.getByText('Generation II (Johto) - 100 Pokemon')).toBeInTheDocument()
    expect(screen.getByText('Generation III (Hoenn) - 135 Pokemon')).toBeInTheDocument()
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
    
    const select = screen.getByLabelText('Filter by generation')
    fireEvent.change(select, { target: { value: '1' } })
    
    expect(mockOnGenerationChange).toHaveBeenCalledWith(1)
  })

  it('calls onGenerationChange with "all" when All Generations is selected', () => {
    render(
      <GenerationFilter
        selectedGeneration="all"
        onGenerationChange={mockOnGenerationChange}
        generations={mockGenerations}
        isLoading={false}
      />
    )
    
    const select = screen.getByLabelText('Filter by generation')
    fireEvent.change(select, { target: { value: 'all' } })
    
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
    
    const select = screen.getByLabelText('Filter by generation')
    expect(select).toHaveValue('2')
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
    
    expect(screen.getByLabelText('Filter by generation')).toBeInTheDocument()
    expect(screen.getByText('All Generations')).toBeInTheDocument()
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
    expect(screen.getByText('Generation I (Kanto) - 151 Pokemon')).toBeInTheDocument()
    expect(screen.getByText('Generation II (Johto) - 100 Pokemon')).toBeInTheDocument()
    expect(screen.getByText('Generation III (Hoenn) - 135 Pokemon')).toBeInTheDocument()
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
    
    expect(screen.getByText('Generation I (Kanto) - 50 Pokemon')).toBeInTheDocument()
    expect(screen.getByText('Generation II (Johto) - 100 Pokemon')).toBeInTheDocument()
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
    
    const select = screen.getByLabelText('Filter by generation')
    expect(select).toHaveAttribute('id', 'generation-filter')
    expect(select).toHaveAttribute('name', 'generation')
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
    
    const select = screen.getByLabelText('Filter by generation')
    expect(select).toHaveClass('w-full', 'p-2', 'border', 'border-gray-300', 'rounded-md')
  })
})
