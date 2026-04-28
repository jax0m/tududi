#!/bin/bash
set -euo pipefail

echo "========================================="
echo "Tududi Development Server - Post Container Create"
echo "========================================="
echo "From location $(pwd)"

# Step 1: Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"

# Step 2: Normalize line endings across OSs
echo ""
echo "🔧 Normalizing file line endings (handles CRLF/LF differences between OSs)..."
dos2unix -q **/*
echo "✅ Line endings normalized"

# Step 3: Create necessary directories
echo ""
echo "📂 Creating required directories..."
mkdir -p ./backend/db ./backend/uploads
echo "✅ Directories created"

# Step 4: Set up .env file
echo ""
echo "🔧 Setting up environment configuration..."
if [ -f ./backend/.env ]; then
    echo "File ./backend/.env found, extracting credentials"
    # Extract values from existing .env file
    TUDUDI_USER_EMAIL=$(grep "^TUDUDI_USER_EMAIL=" ./backend/.env | cut -d'=' -f2-)
    TUDUDI_USER_PASSWORD=$(grep "^TUDUDI_USER_PASSWORD=" ./backend/.env | cut -d'=' -f2-)
    TUDUDI_SESSION_SECRET=$(grep "^TUDUDI_SESSION_SECRET=" ./backend/.env | cut -d'=' -f2-)
    if [ -n "$TUDUDI_USER_PASSWORD" ]; then
        echo "✅ Extracted existing credentials from .env"
    else
        echo "⚠️  Password not found in .env"
    fi
else
    echo "File ./backend/.env not found, creating from .env.example..."
    # Copy .env.example as base, then replace dynamic values
    cp ./backend/.env.example ./backend/.env

    # Replace TUDUDI_SESSION_SECRET with a random one (or use env var if set)
    if [ -n "${TUDUDI_SESSION_SECRET:-}" ]; then
        echo "Using session secret from environment variable"
        sed -i "s|^TUDUDI_SESSION_SECRET=.*|TUDUDI_SESSION_SECRET=${TUDUDI_SESSION_SECRET}|" ./backend/.env
    else
        echo "Generating new session secret"
        sed -i "s|^TUDUDI_SESSION_SECRET=.*|TUDUDI_SESSION_SECRET=$(openssl rand -hex 64)|" ./backend/.env
    fi

    # Replace TUDUDI_USER_EMAIL (or use env var if set)
    if [ -n "${TUDUDI_USER_EMAIL:-}" ]; then
        echo "Using email from environment variable: ${TUDUDI_USER_EMAIL}"
        sed -i "s|^TUDUDI_USER_EMAIL=.*|TUDUDI_USER_EMAIL=${TUDUDI_USER_EMAIL}|" ./backend/.env
    else
        echo "Using default email: admin@example.com"
        sed -i "s|^TUDUDI_USER_EMAIL=.*|TUDUDI_USER_EMAIL=admin@example.com|" ./backend/.env
    fi

    # Replace TUDUDI_USER_PASSWORD with a random one (or use env var if set)
    if [ -n "${TUDUDI_USER_PASSWORD:-}" ]; then
        echo "Using password from environment variable"
        sed -i "s|^TUDUDI_USER_PASSWORD=.*|TUDUDI_USER_PASSWORD=${TUDUDI_USER_PASSWORD}|" ./backend/.env
    else
        echo "Generating new password"
        sed -i "s|^TUDUDI_USER_PASSWORD=.*|TUDUDI_USER_PASSWORD=$(openssl rand -hex 32)|" ./backend/.env
    fi

    # Set TUDUDI_TRUST_PROXY to true (required for Docker/reverse proxy setups)
    # This is the new default in .env.example and enables Express to correctly
    # read client IPs from X-Forwarded-For headers
    if grep -q "^TUDUDI_TRUST_PROXY=" ./backend/.env; then
        echo "TUDUDI_TRUST_PROXY is already set in .env"
    else
        echo "Adding TUDUDI_TRUST_PROXY=true to .env (required for Docker setups)"
        echo "TUDUDI_TRUST_PROXY=true" >> ./backend/.env
    fi

    echo "✅ Created backend/.env from .env.example"
    echo ""
    echo "⚠️  IMPORTANT: Change TUDUDI_USER_PASSWORD in production!"
    echo ""

    # Extract final values
    TUDUDI_USER_EMAIL=$(grep "^TUDUDI_USER_EMAIL=" ./backend/.env | cut -d'=' -f2-)
    TUDUDI_USER_PASSWORD=$(grep "^TUDUDI_USER_PASSWORD=" ./backend/.env | cut -d'=' -f2-)
fi

# Step 5: Initialize database if needed
echo ""
echo "📦 Setting up database..."
DB_PATH="db/development.sqlite3"

# Use codebase default (matches backend/config/config.js)
if [ -f "./backend/$DB_PATH" ]; then
    echo "✅ Database already exists at ./backend/$DB_PATH, skipping initialization"
else
    echo "🗄️  Database not found, running initialization..."
    npm run db:init
    echo ""

    if [ -n "$TUDUDI_USER_PASSWORD" ]; then
        echo "👤 Creating test user..."
        npm run user:create "$TUDUDI_USER_EMAIL" "$TUDUDI_USER_PASSWORD" true
    else
        echo "⚠️  No password found. Database created but you'll need to create a user manually:"
        echo "   npm run user:create"
    fi
fi

# Final summary
echo ""
echo "========================================="
echo "✅ Container Setup Complete"
echo "========================================="
echo ""
echo "🔐 Login credentials:"
echo "   Email: ${TUDUDI_USER_EMAIL:-(see ./backend/.env)}"
echo "   Password: ${TUDUDI_USER_PASSWORD:-(see ./backend/.env)}"
echo ""
echo "📝 Next steps:"
echo "   1. Start the dev servers:"
echo "      - Backend:  npm run backend:dev"
echo "      - Frontend: npm run frontend:dev"
echo "   2. Or run both: npm start"
echo "   3. Open http://localhost:8080 in your browser"
echo ""
echo "📚 Docs: docs/development-workflow.md"
