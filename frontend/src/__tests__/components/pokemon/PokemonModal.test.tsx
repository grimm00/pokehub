import React from 'react'
import { render, screen, fireEvent, waitFor, act } from '@testing-library/react'
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { PokemonModal } from '@/components/pokemon/PokemonModal'
import { useAuthStore } from '@/store/authStore'
import { useFavoritesStore } from '@/store/favoritesStore'

// Mock the stores
const mockAuthStore = {
  user: { id: 1, username: 'testuser', email: 'test@example.com' },
  isAuthenticated: true,
}

const mockFavoritesStore = {
  favorites: [1, 2, 3],
  toggleFavorite: vi.fn(),
  isFavorite: vi.fn((pokemonId: number) => mockFavoritesStore.favorites.includes(pokemonId)),
}

vi.mock('@/store/authStore', () => ({
  useAuthStore: vi.fn(),
}))

vi.mock('@/store/favoritesStore', () => ({
  useFavoritesStore: vi.fn(),
}))

// Mock sprite utilities
vi.mock('@/utils/spriteUtils', () => ({
  getAnimatedSpriteUrl: vi.fn(() => 'https://example.com/animated.gif'),
  getStaticSpriteUrl: vi.fn(() => 'https://example.com/static.png'),
  preloadAnimatedSprite: vi.fn(),
  hasAnimatedSprite: vi.fn(() => true),
}))

const mockPokemon = {
  id: 1,
  pokemon_id: 25,
  name: 'Pikachu',
  types: ['electric'],
  height: 4,
  weight: 60,
  base_experience: 112,
  abilities: ['static', 'lightning-rod'],
  stats: {
    hp: 35,
    attack: 55,
    defense: 40,
    'special-attack': 50,
    'special-defense': 50,
    speed: 90,
  },
  sprites: {
    front_default: 'https://example.com/pikachu.png',
    back_default: 'https://example.com/pikachu-back.png',
  },
  created_at: '2024-01-01T00:00:00Z',
  updated_at: '2024-01-01T00:00:00Z',
}

describe('PokemonModal', () => {
  const mockOnClose = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(mockAuthStore)
    ;(useFavoritesStore as unknown as vi.Mock).mockReturnValue(mockFavoritesStore)
  })

  it('renders nothing when not open', () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={false} onClose={mockOnClose} />)
    
    expect(screen.queryByText('Pikachu')).not.toBeInTheDocument()
  })

  it('renders nothing when pokemon is null', () => {
    render(<PokemonModal pokemon={null} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.queryByText('Pikachu')).not.toBeInTheDocument()
  })

  it('renders modal when open with pokemon', () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByText('Pikachu')).toBeInTheDocument()
    expect(screen.getByText('Electric')).toBeInTheDocument()
    expect(screen.getByText('Height: 4 dm')).toBeInTheDocument()
    expect(screen.getByText('Weight: 60 hg')).toBeInTheDocument()
    expect(screen.getByText('Base Experience: 112')).toBeInTheDocument()
  })

  it('displays pokemon stats correctly', () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByText('HP: 35')).toBeInTheDocument()
    expect(screen.getByText('Attack: 55')).toBeInTheDocument()
    expect(screen.getByText('Defense: 40')).toBeInTheDocument()
    expect(screen.getByText('Special Attack: 50')).toBeInTheDocument()
    expect(screen.getByText('Special Defense: 50')).toBeInTheDocument()
    expect(screen.getByText('Speed: 90')).toBeInTheDocument()
  })

  it('displays pokemon abilities', () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByText('Static')).toBeInTheDocument()
    expect(screen.getByText('Lightning Rod')).toBeInTheDocument()
  })

  it('calls onClose when close button is clicked', async () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    const closeButton = screen.getByLabelText('Close modal')
    
    await act(async () => {
      fireEvent.click(closeButton)
    })
    
    expect(mockOnClose).toHaveBeenCalledTimes(1)
  })

  it('calls onClose when escape key is pressed', async () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    await act(async () => {
      fireEvent.keyDown(document, { key: 'Escape', code: 'Escape' })
    })
    
    expect(mockOnClose).toHaveBeenCalledTimes(1)
  })

  it('shows add to favorites button when pokemon is not favorite', () => {
    mockFavoritesStore.isFavorite.mockReturnValue(false)
    
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByLabelText('Add to favorites')).toBeInTheDocument()
  })

  it('shows remove from favorites button when pokemon is favorite', () => {
    mockFavoritesStore.isFavorite.mockReturnValue(true)
    
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByLabelText('Remove from favorites')).toBeInTheDocument()
  })

  it('calls toggleFavorite when favorite button is clicked', async () => {
    mockFavoritesStore.isFavorite.mockReturnValue(false)
    
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    const favoriteButton = screen.getByLabelText('Add to favorites')
    
    await act(async () => {
      fireEvent.click(favoriteButton)
    })
    
    expect(mockFavoritesStore.toggleFavorite).toHaveBeenCalledWith(1, 25)
  })

  it('does not show favorite button when user is not authenticated', () => {
    const unauthenticatedStore = {
      ...mockAuthStore,
      isAuthenticated: false,
    }
    ;(useAuthStore as unknown as vi.Mock).mockReturnValue(unauthenticatedStore)
    
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.queryByLabelText('Add to favorites')).not.toBeInTheDocument()
    expect(screen.queryByLabelText('Remove from favorites')).not.toBeInTheDocument()
  })

  it('displays pokemon image', () => {
    render(<PokemonModal pokemon={mockPokemon} isOpen={true} onClose={mockOnClose} />)
    
    const image = screen.getByAltText('Pikachu')
    expect(image).toBeInTheDocument()
    expect(image).toHaveAttribute('src', 'https://example.com/pikachu.png')
  })

  it('handles pokemon with multiple types', () => {
    const multiTypePokemon = {
      ...mockPokemon,
      types: ['fire', 'flying'],
    }
    
    render(<PokemonModal pokemon={multiTypePokemon} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.getByText('Fire')).toBeInTheDocument()
    expect(screen.getByText('Flying')).toBeInTheDocument()
  })

  it('handles pokemon without base experience', () => {
    const pokemonWithoutExp = {
      ...mockPokemon,
      base_experience: undefined,
    }
    
    render(<PokemonModal pokemon={pokemonWithoutExp} isOpen={true} onClose={mockOnClose} />)
    
    expect(screen.queryByText('Base Experience:')).not.toBeInTheDocument()
  })
})
