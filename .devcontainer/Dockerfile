# Tududi Development Container
FROM node:22-alpine

RUN npm install -g npm@11.6.4

# Install system dependencies
RUN apk add --no-cache \
    git \
    bash \
    procps \
    openssh-client \
    sudo \
    dos2unix \
    sqlite

# Copy project
COPY . /app

# Create app directory
WORKDIR /app

# # Copy package files
# COPY package*.json ./

# Install dependencies
RUN dos2unix *

# # Copy project
# COPY . /app

# Create necessary directories
RUN mkdir -p /app/backend/db /app/backend/uploads

# # Create user based on GIT_USERNAME env var or default to vscode
# # This runs after user creation from devcontainer features
# # RUN if [ -n "$GIT_USERNAME" ] && [ "$GIT_USERNAME" != "vscode" ]; then \
# #     useradd -m -s /bin/bash $GIT_USERNAME 2>/dev/null || true; \
# #     usermod -aG sudo $GIT_USERNAME 2>/dev/null || true; \
# #     echo "$GIT_USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$GIT_USERNAME 2>/dev/null || true; \
# #     chown -R $GIT_USERNAME:$GIT_USERNAME /app; \
# # fi || true

# # # Set default user
# USER vscode

# Expose ports
EXPOSE 3002 8080

