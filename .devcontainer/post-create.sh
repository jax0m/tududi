#!/bin/bash
set -euo pipefail

# Install dependencies
echo "Attempting dos2unix in case some of the line endings in files were CRLF"
dos2unix -q **/*

# Create necessary directories
echo "Attempting to create directories if not as expected"
mkdir -p ./backend/db ./backend/uploads

echo "========================================="
echo "Tududi Development Server - Post Container Create"
echo "========================================="
echo "From location $(pwd)"

# Create .env file if it doesn't exist, or extract password if it does
if [ -f ./backend/.env ]; then
    echo "File ./backend/.env found, extracting credentials"
    # Extract TUDUDI_USER_PASSWORD from existing .env file
    TUDUDI_USER_PASSWORD=$(grep "^TUDUDI_USER_PASSWORD=" ./backend/.env | cut -d'=' -f2-)
    if [ -n "$TUDUDI_USER_PASSWORD" ]; then
        echo "✅ Extracted existing password from .env"
    else
        echo "⚠️  Password not found in .env"
    fi
else
    echo "File ./backend/.env not found, Creating:"
    echo ""
    echo "🔧 Creating .env file..."
    cat > ./backend/.env <<ENVEOF
NODE_ENV=development

HOST=0.0.0.0
PORT=3002

DB_FILE=db/database.sqlite3

FRONTEND_URL=http://localhost:8080
BACKEND_URL=http://localhost:3002

TUDUDI_SESSION_SECRET=${TUDUDI_SESSION_SECRET:-$(openssl rand -hex 64)}

TUDUDI_USER_EMAIL=${TUDUDI_USER_EMAIL:-admin@example.com}
TUDUDI_USER_PASSWORD=${TUDUDI_USER_PASSWORD:-$(openssl rand -hex 32)}

ENABLE_EMAIL=false
DISABLE_TELEGRAM=true
REGISTRATION_TOKEN_EXPIRY_HOURS=24

TUDUDI_ALLOWED_ORIGINS=http://localhost:8080
TUDUDI_TRUST_PROXY=false

SWAGGER_ENABLED=true

FF_ENABLE_BACKUPS=false
FF_ENABLE_CALENDAR=false
FF_ENABLE_HABITS=false
FF_ENABLE_MCP=false

RATE_LIMITING_ENABLED=false

TUDUDI_UPLOAD_PATH=backend/uploads
ENVEOF
    echo "✅ Created backend/.env file"
    echo ""
    echo "⚠️  IMPORTANT: Change TUDUDI_USER_PASSWORD in production!"
    echo ""
    TUDUDI_USER_PASSWORD=$(grep "^TUDUDI_USER_PASSWORD=" ./backend/.env | cut -d'=' -f2-)
    TUDUDI_USER_EMAIL=$(grep "^TUDUDI_USER_EMAIL=" ./backend/.env | cut -d'=' -f2-)
fi

# Check if database already exists
DB_FILE=$(grep "^DB_FILE=" ./backend/.env | cut -d'=' -f2-)
if [ -n "$DB_FILE" ]; then
    # Check if database already exists
    if [ -f "./backend/$DB_FILE" ]; then
        echo "✅ Database already exists, skipping initialization"
    else
        echo ""
        echo "📦 Initializing database..."
        npm run db:init
        echo ""
        if [ -n "$TUDUDI_USER_PASSWORD" ]; then
            echo "✅ Password exists for user creation..."
            echo "👤 Creating test user..."
            npm run user:create admin@example.com "$TUDUDI_USER_PASSWORD" true
        else
            echo "⚠️  Password not found, you will have to create your own user manually"
        fi
    fi
else
    echo "⚠️  Database variable not found in environment variables, check env file"
fi

echo ""
echo "🔐 Login credentials:"
echo "   Email: ${TUDUDI_USER_EMAIL:-(see .env file)}"
echo "   Password: ${TUDUDI_USER_PASSWORD:-(see .env file)}"
echo "✅ Container ready for use"
