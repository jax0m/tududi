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
COPY . .

# Create app directory
WORKDIR .

# Install dependencies
RUN dos2unix *

# Create necessary directories
RUN mkdir -p ./backend/db ./backend/uploads

# Expose ports
EXPOSE 3002 8080

