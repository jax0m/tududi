#!/bin/bash
set -euo pipefail

echo "========================================="
echo "🚀 Tududi Development Environment Setup"
echo "========================================="

# Get Git username if available
GIT_USERNAME="${GIT_USERNAME:-vscode}"
echo ""
echo "👤 Detected user: $GIT_USERNAME"

# Create user if GIT_USERNAME is set and different from default
if [ "$GIT_USERNAME" != "vscode" ] && [ -n "$GIT_USERNAME" ]; then
    echo ""
    echo "🔧 Creating user: $GIT_USERNAME"
    if id "$GIT_USERNAME" &>/dev/null; then
        echo "   User already exists, skipping creation"
    else
        useradd -m -s /bin/bash "$GIT_USERNAME"
        usermod -aG sudo "$GIT_USERNAME"
        echo "$GIT_USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$GIT_USERNAME
        chown -R "$GIT_USERNAME":"$GIT_USERNAME" /app
        echo "   ✅ User created with sudo access"
    fi
else
    echo "   ℹ️  Using default 'vscode' user"
fi

# Check if database already exists
if [ -f "../backend/database.sqlite" ]; then
    echo "✅ Database already exists, skipping initialization"
else
    echo ""
    echo "📦 Initializing database..."
    npm run db:init
    echo ""
    echo "👤 Creating test user..."
    npm run user:create
fi

# Create .env file if it doesn't exist
if [ ! -f "../backend/.env" ]; then
    echo ""
    echo "🔧 Creating .env file..."
    cat > ../backend/.env <<'ENVEOF'
NODE_ENV=development

HOST=0.0.0.0
PORT=3002

DB_FILE=database.sqlite

FRONTEND_URL=http://localhost:8080
BACKEND_URL=http://localhost:3002

TUDUDI_SESSION_SECRET=your-random-64-character-hex-string-here

TUDUDI_USER_EMAIL=admin@example.com
TUDUDI_USER_PASSWORD=change-me-to-secure-password

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
    echo "⚠️  IMPORTANT: Change the TUDUDI_SESSION_SECRET!"
    echo "   Run: openssl rand -hex 64"
    echo ""
fi

# Set up Git user if not configured
if [ "$GIT_USERNAME" != "vscode" ] && [ -n "$GIT_USERNAME" ]; then
    echo ""
    echo "🔧 Configuring Git user..."
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "${GIT_USERNAME}@users.noreply.github.com"
    echo "✅ Git configured with username: $GIT_USERNAME"
fi

echo ""
echo "========================================="
echo "✅ Setup Complete!"
echo "========================================="
echo ""
echo "📚 Next Steps:"
echo "   1. Open http://localhost:8080 in your browser"
echo "   2. Login with credentials from user:create"
echo "   3. Check http://localhost:3002/api-docs"
echo ""
echo "🔧 Common Commands:"
echo "   npm start              # Start both servers"
echo "   npm run backend:dev    # Backend only"
echo "   npm run frontend:dev   # Frontend only"
echo "   npm test               # Run backend tests"
echo ""
echo "========================================="
