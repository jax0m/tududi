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
    nano \
    zsh \
    curl \
    github-cli

RUN npm install -g npm@11.6.4

RUN adduser -D app
RUN mkdir /workspaces && chown -R app:app /workspaces
RUN touch /home/app/.zshrc && chown -R app:app /home/app

USER app
RUN /bin/zsh /home/app/.zshrc

ENTRYPOINT [ "/bin/zsh" ]
