import { describe, it, expect } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { server } from '../setup/msw-server'
import { http, HttpResponse } from 'msw'
import { PokemonPage } from '@/pages/PokemonPage'

describe('API Integration Tests', () => {
  it('fetches and displays pokemon from API', async () => {
    // Override handlers for this test
    server.use(
      http.get('http://localhost:5000/api/v1/pokemon', () => {
        return HttpResponse.json({
          pokemon: [
            {
              id: 1,
              pokemon_id: 25,
              name: 'Pikachu',
              types: ['electric'],
              sprite_url: 'https://example.com/pikachu.png',
              height: 4,
              weight: 60,
              abilities: ['static', 'lightning-rod'],
              stats: {
                hp: 35,
                attack: 55,
                defense: 40,
                special_attack: 50,
                special_defense: 50,
                speed: 90
              },
              sprites: {
                front_default: 'https://example.com/pikachu.png',
                front_shiny: 'https://example.com/pikachu-shiny.png'
              }
            }
          ],
          pagination: {
            page: 1,
            per_page: 20,
            total: 1,
            pages: 1,
            has_next: false,
            has_prev: false
          }
        })
      }),
      http.get('http://localhost:5000/api/v1/pokemon/types', () => {
        return HttpResponse.json(['electric', 'normal'])
      }),
      http.get('http://localhost:5000/api/v1/pokemon/generations', () => {
        return HttpResponse.json({
          generations: [
            {
              generation: 1,
              name: 'Generation I',
              region: 'Kanto',
              year: 1996,
              pokemon_count: 151,
              expected_count: 151,
              color: '#ff6b6b',
              games: ['Red', 'Blue', 'Yellow'],
              description: 'The original Pokemon games',
              is_complete: true
            }
          ],
          total_generations: 1,
          total_pokemon: 151,
          available_generations: [1]
        })
      })
    )

    render(
      <BrowserRouter>
        <PokemonPage />
      </BrowserRouter>
    )

    // Wait for pokemon to load
    await waitFor(() => {
      expect(screen.getByText('Pikachu')).toBeInTheDocument()
    })
  })

  it('handles API errors gracefully', async () => {
    // Override handlers to return errors
    server.use(
      http.get('http://localhost:5000/api/v1/pokemon', () => {
        return HttpResponse.json({ message: 'Server error' }, { status: 500 })
      }),
      http.get('http://localhost:5000/api/v1/pokemon/types', () => {
        return HttpResponse.json(['electric', 'normal'])
      }),
      http.get('http://localhost:5000/api/v1/pokemon/generations', () => {
        return HttpResponse.json({
          generations: [
            {
              generation: 1,
              name: 'Generation I',
              region: 'Kanto',
              year: 1996,
              pokemon_count: 151,
              expected_count: 151,
              color: '#ff6b6b',
              games: ['Red', 'Blue', 'Yellow'],
              description: 'The original Pokemon games',
              is_complete: true
            }
          ],
          total_generations: 1,
          total_pokemon: 151,
          available_generations: [1]
        })
      })
    )

    render(
      <BrowserRouter>
        <PokemonPage />
      </BrowserRouter>
    )

    // Should show error state
    await waitFor(() => {
      expect(screen.getByText('Error: Server error')).toBeInTheDocument()
    })
  })
})
