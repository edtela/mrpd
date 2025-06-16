FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    sudo \
    vim \
    tmux \
    build-essential \
    python3 \
    python3-pip \
    locales \
    openssh-client \
    gnupg \
    ca-certificates \
    lsb-release \
    jq \
    ripgrep \
    fd-find \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Create developer user with sudo privileges
RUN useradd -m -s /bin/bash -u 1000 developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create application directory structure BEFORE switching user
RUN mkdir -p /opt/mrpd && chown -R developer:developer /opt/mrpd

# Switch to developer user
USER developer
WORKDIR /opt/mrpd

# Configure npm to use user directory for global packages
ENV NPM_CONFIG_PREFIX=/home/developer/.npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH
RUN mkdir -p /home/developer/.npm-global

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/opt/mrpd

# Install global npm packages including Claude Code
RUN npm install -g \
    @anthropic-ai/claude-code \
    typescript \
    eslint \
    prettier \
    nodemon

# Copy package files and install dependencies
COPY --chown=developer:developer package*.json ./
RUN npm install

# Copy application files
COPY --chown=developer:developer proxy-server.js ./
COPY --chown=developer:developer docker-entrypoint.sh ./
COPY --chown=developer:developer default-settings.json ./
COPY --chown=developer:developer tmux.conf ./
COPY --chown=developer:developer dev-tools-init.sh ./

# Make scripts executable
RUN chmod +x docker-entrypoint.sh dev-tools-init.sh

# Create necessary directories
RUN mkdir -p /home/developer/.config/code-server \
    && mkdir -p /home/developer/workspace

# Set up code-server config directory
ENV CODE_SERVER_CONFIG=/opt/mrpd/code-server-config.yaml

# Expose ports
EXPOSE 8000

# Set working directory to home for runtime
WORKDIR /home/developer

# Entry point
ENTRYPOINT ["/opt/mrpd/docker-entrypoint.sh"]