import React from 'react'
import { render, screen, fireEvent } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { PokemonList } from '@/components/pokemon/PokemonList'
import { PokemonCard } from '@/components/pokemon/PokemonCard'

// Mock PokemonCard component
vi.mock('@/components/pokemon/PokemonCard', () => ({
  PokemonCard: vi.fn(({ pokemon, onClick }) => (
    <div data-testid={`pokemon-card-${pokemon.id}`} onClick={() => onClick?.(pokemon)}>
      {pokemon.name}
    </div>
  )),
}))

const mockPokemon = [
  {
    id: 1,
    pokemon_id: 25,
    name: 'Pikachu',
    types: ['electric'],
    height: 4,
    weight: 60,
    base_experience: 112,
    abilities: ['static'],
    stats: { hp: 35, attack: 55, defense: 40 },
    sprites: { front_default: 'https://example.com/pikachu.png' },
  },
  {
    id: 2,
    pokemon_id: 1,
    name: 'Bulbasaur',
    types: ['grass', 'poison'],
    height: 7,
    weight: 69,
    base_experience: 64,
    abilities: ['overgrow'],
    stats: { hp: 45, attack: 49, defense: 49 },
    sprites: { front_default: 'https://example.com/bulbasaur.png' },
  },
]

describe('PokemonList', () => {
  const mockOnPokemonClick = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders loading state', () => {
    render(<PokemonList pokemon={[]} loading={true} />)
    
    expect(screen.getByRole('status')).toBeInTheDocument()
    expect(document.querySelector('.animate-spin')).toBeInTheDocument()
  })

  it('renders empty state when no pokemon', () => {
    render(<PokemonList pokemon={[]} loading={false} />)
    
    expect(screen.getByText('No Pokemon found')).toBeInTheDocument()
    expect(screen.getByText('Try adjusting your search or filters.')).toBeInTheDocument()
  })

  it('renders pokemon list when pokemon are provided', () => {
    render(<PokemonList pokemon={mockPokemon} loading={false} />)
    
    expect(screen.getByTestId('pokemon-card-1')).toBeInTheDocument()
    expect(screen.getByTestId('pokemon-card-2')).toBeInTheDocument()
    expect(screen.getByText('Pikachu')).toBeInTheDocument()
    expect(screen.getByText('Bulbasaur')).toBeInTheDocument()
  })

  it('calls onPokemonClick when pokemon card is clicked', () => {
    render(<PokemonList pokemon={mockPokemon} loading={false} onPokemonClick={mockOnPokemonClick} />)
    
    const pikachuCard = screen.getByTestId('pokemon-card-1')
    fireEvent.click(pikachuCard)
    
    expect(mockOnPokemonClick).toHaveBeenCalledWith(mockPokemon[0])
  })

  it('does not call onPokemonClick when not provided', () => {
    render(<PokemonList pokemon={mockPokemon} loading={false} />)
    
    const pikachuCard = screen.getByTestId('pokemon-card-1')
    fireEvent.click(pikachuCard)
    
    expect(mockOnPokemonClick).not.toHaveBeenCalled()
  })

  it('applies custom className', () => {
    const { container } = render(
      <PokemonList pokemon={mockPokemon} loading={false} className="custom-class" />
    )
    
    expect(container.firstChild).toHaveClass('custom-class')
  })

  it('renders with default className when none provided', () => {
    const { container } = render(<PokemonList pokemon={mockPokemon} loading={false} />)
    
    expect(container.firstChild).toHaveClass('grid', 'grid-cols-1', 'md:grid-cols-2', 'lg:grid-cols-3', 'gap-6')
  })

  it('renders correct number of pokemon cards', () => {
    render(<PokemonList pokemon={mockPokemon} loading={false} />)
    
    const pokemonCards = screen.getAllByTestId(/pokemon-card-/)
    expect(pokemonCards).toHaveLength(2)
  })

  it('passes correct props to PokemonCard components', () => {
    render(<PokemonList pokemon={mockPokemon} loading={false} onPokemonClick={mockOnPokemonClick} />)
    
    expect(PokemonCard).toHaveBeenCalledWith(
      expect.objectContaining({
        pokemon: mockPokemon[0],
        onClick: expect.any(Function),
      }),
      expect.any(Object)
    )
    
    expect(PokemonCard).toHaveBeenCalledWith(
      expect.objectContaining({
        pokemon: mockPokemon[1],
        onClick: expect.any(Function),
      }),
      expect.any(Object)
    )
  })

  it('handles single pokemon correctly', () => {
    const singlePokemon = [mockPokemon[0]]
    render(<PokemonList pokemon={singlePokemon} loading={false} />)
    
    expect(screen.getByTestId('pokemon-card-1')).toBeInTheDocument()
    expect(screen.queryByTestId('pokemon-card-2')).not.toBeInTheDocument()
  })

  it('shows loading state even when pokemon are provided', () => {
    render(<PokemonList pokemon={mockPokemon} loading={true} />)
    
    expect(screen.getByRole('status')).toBeInTheDocument()
    expect(screen.queryByTestId('pokemon-card-1')).not.toBeInTheDocument()
  })
})
