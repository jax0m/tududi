# Tududi Development Container
FROM node:22-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    bash \
    procps \
    openssh-client \
    sudo \
    dos2unix \
    sqlite \
    openssl \
    nano

RUN npm install -g npm@11.6.4