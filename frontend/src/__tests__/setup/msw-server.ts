import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

// Define handlers for common API endpoints
export const handlers = [
        // Pokemon API endpoints
        http.get('http://localhost:5000/api/v1/pokemon', () => {
          return HttpResponse.json({
            pokemon: [
              {
                id: 1,
                pokemon_id: 25,
                name: 'Pikachu',
                types: ['electric'],
                sprite_url: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
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
                  front_default: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
                  front_shiny: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png'
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
  
  http.get('http://localhost:5000/api/v1/pokemon/:id', ({ params }) => {
    const { id } = params
    return HttpResponse.json({
      id: Number(id),
      pokemon_id: Number(id),
      name: 'Test Pokemon',
      types: ['normal'],
      sprite_url: 'https://example.com/sprite.png'
    })
  }),
  
  // Auth endpoints
  http.post('http://localhost:5000/api/v1/auth/login', () => {
    return HttpResponse.json({ 
      access_token: 'mock-token',
      user: {
        id: 1,
        username: 'testuser',
        email: 'test@example.com'
      }
    })
  }),
  
  http.post('http://localhost:5000/api/v1/auth/register', () => {
    return HttpResponse.json({ 
      access_token: 'mock-token',
      user: {
        id: 1,
        username: 'testuser',
        email: 'test@example.com'
      }
    })
  }),
  
  // Generations endpoint
  http.get('http://localhost:5000/api/v1/generations', () => {
    return HttpResponse.json([
      { id: 1, name: 'Generation I', pokemon_count: 151 }
    ])
  }),
  
  // Pokemon generations endpoint (used by PokemonPage)
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
  }),
  
  // Pokemon types endpoint
  http.get('http://localhost:5000/api/v1/pokemon/types', () => {
    return HttpResponse.json([
      'normal', 'fire', 'water', 'electric', 'grass', 'ice', 'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug', 'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy'
    ])
  })
]

// Create server instance
export const server = setupServer(...handlers)
