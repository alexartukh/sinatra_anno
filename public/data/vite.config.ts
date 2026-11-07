import { defineConfig } from 'vite'
import { resolve } from 'path'

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, 'src/server.ts'),
      name: 'server',
      fileName: 'server',
      formats: ['es']
    },
    target: 'node18',
    outDir: 'dist',
    rollupOptions: {
      external: [
        // Node.js built-ins
        'fs',
        'path',
        'url',
        'crypto',
        'http',
        'https',
        'stream',
        'util',
        'events',
        'buffer',
        'querystring',
        'os',
        'net',
        'tls',
        'zlib',
        'child_process',
        // Dependencies that should be external
        /^@fastify\/.*/,
        /^@sentry\/.*/,
        /^firebase-admin.*/,
        /^@google-cloud\/.*/,
        /^@firebase\/.*/,
        'fastify',
        'dotenv',
        'joi',
        'jose',
      ]
    },
    sourcemap: true,
    minify: true,
    // Don't bundle node_modules and preserve dynamic imports
    ssr: true
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  esbuild: {
    target: 'node18'
  }
})
