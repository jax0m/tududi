# Using Your Git Username in Devcontainer

## Overview

The devcontainer can now be configured to use your Git username as the container user instead of the default "vscode" user. This provides a more personalized development environment.

## How It Works

The devcontainer configuration uses environment variables to detect your Git username:

```json
{
  "remoteUser": "${localEnv:GIT_USERNAME:-vscode}"
}
```

This means:
- If `GIT_USERNAME` environment variable is set, use it
- Otherwise, default to "vscode"

## Setup Instructions

### Method 1: Set Git Username in VS Code (Recommended)

1. **Open Command Palette**
   - Press `F1` or `Ctrl+Shift+P`

2. **Set Environment Variable**
   - Type: `Terminal: Set Environment Variable`
   - Add: `GIT_USERNAME=your-git-username`

3. **Reload Container**
   - Press `F1` → `Dev Containers: Reload Window`
   - The container will restart with your Git username

### Method 2: Set in Docker Compose

If using Docker Compose instead:

```yaml
environment:
  - GIT_USERNAME=your-git-username
  - NODE_ENV=development
  # ... other variables
```

### Method 3: Set in .env File

Create a `.devcontainer/.env` file:

```env
GIT_USERNAME=your-git-username
```

Then load it in devcontainer.json:

```json
{
  "remoteUser": "${localEnv:GIT_USERNAME:-vscode}",
  "postCreateCommand": "bash .devcontainer/scripts/post-create.sh"
}
```

## What Changes When Using Your Git Username

### 1. File Ownership
- Files in the container are owned by your Git username
- Better permission management
- Easier to map to host user

### 2. Git Configuration
- Git is automatically configured with your username
- No need to set up Git config inside the container

### 3. Sudo Access
- Your user has sudo privileges
- Can run administrative commands if needed

### 4. Shell Access
- SSH shell configured for your user
- Better shell environment

## Benefits

✅ **Consistent Identity** - Same username across host and container  
✅ **Better Permissions** - Proper file ownership  
✅ **Git Integration** - Git configured automatically  
✅ **Personalization** - Feels like "your" development environment  
✅ **Security** - User isolation with proper permissions  

## Troubleshooting

### Issue: Git username not detected

**Solution:** Make sure `GIT_USERNAME` environment variable is set before opening the container.

### Issue: Files owned by wrong user

**Solution:** 
```bash
# Inside container
chown -R $GIT_USERNAME:$GIT_USERNAME /app
```

### Issue: Git still shows "vscode"

**Solution:** Check if Git is properly configured:
```bash
git config --global user.name
git config --global user.email
```

## Advanced: Custom User Setup

For more control, you can customize user creation in the Dockerfile:

```dockerfile
# Create user with custom UID/GID
RUN addgroup -g 1000 -S ${GIT_USERNAME:-vscode} && \
    adduser -u 1000 -S ${GIT_USERNAME:-vscode} -G ${GIT_USERNAME:-vscode}
```

## Security Considerations

⚠️ **Important:**

1. **Always use sudoers properly** - Only grant sudo access when necessary
2. **Don't commit credentials** - Never commit `.env` files with real secrets
3. **Use strong passwords** - For any authentication inside the container
4. **Regular updates** - Keep base images and packages updated

## Example Workflow

### First Time Setup

```bash
# 1. Open repository in VS Code
code tududi

# 2. Set Git Username
F1 → "Terminal: Set Environment Variable"
→ GIT_USERNAME=your-git-username

# 3. Reopen in Container
F1 → "Dev Containers: Reopen in Container"

# 4. Container will:
#    - Create user "your-git-username"
#    - Configure Git with your username
#    - Set up sudo access
#    - Initialize database
#    - Create test user
```

### Daily Development

```bash
# Git is already configured
git add .
git commit -m "Your message"  # Uses your Git username
git push  # Signed with your identity
```

## Alternative: Keep Default User

If you prefer the default "vscode" user:

```bash
# Clear the environment variable
F1 → "Terminal: Clear Environment Variable"
→ GIT_USERNAME

# Reload container
F1 → "Dev Containers: Reload Window"
```

## Documentation

- [Devcontainer.json Reference](https://code.visualstudio.com/docs/devcontainers/containers#_configuration-files)
- [Customizing User](https://code.visualstudio.com/docs/devcontainers/containers#_customizing-user)
- [Environment Variables](https://code.visualstudio.com/docs/devcontainers/containers#_environment-variables)

---

**Last Updated:** 2026-03-25  
**Version:** 1.1.0
