# Tududi Development Container Setup

This repository includes a comprehensive development container setup for consistent development environments.

## 🚀 Quick Start

### Prerequisites
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code
- Docker Desktop installed

### Get Started (3 Steps)

1. **Open in VS Code**
   ```bash
   cd tududi
   code .
   ```

2. **Reopen in Container**
   - Press `F1` → `Dev Containers: Reopen in Container`
   - Wait for Docker to build the image (~2-3 minutes)

3. **Start Development**
   - Press `F1` → `Dev Containers: Restart Task`
   - Select `Post Start Script`
   - Both frontend and backend start automatically!

### Access the Application

- **Frontend:** http://localhost:8080
- **Backend API:** http://localhost:3002
- **Swagger Docs:** http://localhost:3002/api-docs (requires login)

---

## 📋 What's Included

### Pre-installed Extensions
- ESLint
- Prettier
- Tailwind CSS IntelliSense
- TypeScript
- Auto Rename Tag
- Code Spell Checker
- GitHub Pull Requests

### Pre-configured Settings
- Auto-format on save
- Linting on save
- File associations
- Prettier configuration
- ESLint configuration

### Development Ports
- **Backend API:** Port 3002
- **Frontend:** Port 8080

### Shared Volumes
- Backend code (live reload)
- Frontend code (hot reload)
- Database (persistent)
- Uploads (persistent)

---

## 🎯 Common Commands

### Start Development
```bash
npm start              # Start both servers
npm run backend:dev    # Backend only
npm run frontend:dev   # Frontend only
```

### Testing
```bash
npm test                      # Backend tests
npm run test:ui              # E2E tests
npm run test:coverage        # Coverage report
npm run pre-push             # All checks (lint, format, tests)
```

### Database
```bash
npm run db:init      # Initialize/reset database
npm run db:status    # Check database
npm run db:reset     # Reset everything
```

### Code Quality
```bash
npm run lint           # Check linting
npm run lint:fix       # Auto-fix linting
npm run format:fix     # Format code
```

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill processes using ports
lsof -ti:3002,8080 | xargs kill -9
```

### Database Issues
```bash
# Stop containers
docker-compose -f .devcontainer/docker-compose.dev.yml down

# Remove volumes (WARNING: deletes all data!)
docker volume rm tududi_tududi-db tududi_tududi-uploads

# Rebuild
docker-compose -f .devcontainer/docker-compose.dev.yml up -d
```

### Build Failures
```bash
# Remove old images
docker rm -f tududi-backend tududi-frontend

# Rebuild
docker-compose -f .devcontainer/docker-compose.dev.yml build --no-cache

# Start
docker-compose -f .devcontainer/docker-compose.dev.yml up -d
```

---

## 📚 Documentation

- [Devcontainer Guide](DEVCONTAINER-README.md) - Complete setup guide
- [Issues & Solutions](ISSUES-AND-SOLUTIONS.md) - Common problems fixed
- [Development Workflow](../docs/development-workflow.md) - Daily development
- [Testing Guide](../docs/testing.md) - Testing instructions

---

## 🔧 Environment Variables

The container uses environment variables for configuration. Common ones:

| Variable | Default | Description |
|----------|---------|-------------|
| `TUDUDI_SESSION_SECRET` | `dev-secret-change-me` | **CHANGE THIS!** |
| `TUDUDI_USER_EMAIL` | `admin@example.com` | Admin email |
| `TUDUDI_USER_PASSWORD` | `dev-password` | Admin password |
| `DISABLE_TELEGRAM` | `true` | Disable Telegram |
| `ENABLE_EMAIL` | `false` | Disable email |
| `SWAGGER_ENABLED` | `true` | Enable API docs |

---

## 🎉 Benefits

✅ **Consistent Environment** - Same setup for everyone  
✅ **Fast Setup** - One command to get started  
✅ **Persistent Data** - Database survives restarts  
✅ **Debug Ready** - Pre-configured VS Code debugging  
✅ **Hot Reload** - Instant feedback on changes  
✅ **No Dependency Hell** - Everything pre-configured  

---

**Last Updated:** 2026-03-25  
**Version:** 1.0.0
