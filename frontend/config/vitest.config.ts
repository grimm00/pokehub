import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
    plugins: [react()],
    test: {
        environment: 'jsdom',
        setupFiles: [path.resolve(__dirname, '../src/__tests__/test-utils/setup.ts')],
        globals: true,
    },
    define: {
        'process.env.NODE_ENV': '"test"',
        'process.env.VITE_API_URL': '"http://localhost:5000"',
    },
    resolve: {
        alias: {
            '@': path.resolve(__dirname, '../src'),
        },
    },
})
