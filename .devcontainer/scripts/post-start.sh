#!/bin/bash
set -euo pipefail

echo "========================================="
echo "🎬 Starting Tududi Development Servers"
echo "========================================="

# Check if database exists
if [ ! -f "../backend/database.sqlite" ]; then
    echo ""
    echo "⚠️  Database not found. Initializing..."
    npm run db:init
    npm run user:create
fi

echo ""
echo "🚀 Starting backend server on http://localhost:3002"
echo "🎨 Starting frontend server on http://localhost:8080"
echo ""
echo "📝 Opening browser..."

# Start both servers
npm start

echo ""
echo "✅ Tududi is running!"
echo "📖 Swagger API docs: http://localhost:3002/api-docs (requires login)"
echo "📖 Frontend: http://localhost:8080"
