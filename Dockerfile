FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    openssh-client \
    ca-certificates \
    gnupg \
    lsb-release \
    tmux \
    ripgrep \
    fd-find \
    build-essential \
    python3 \
    python3-pip \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Create developer user
RUN useradd -m -s /bin/bash -u 1000 developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create application directory
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

# Install global npm packages
RUN npm install -g \
    @anthropic-ai/claude-code \
    typescript \
    eslint \
    prettier

# Copy configuration files
COPY --chown=developer:developer docker-entrypoint.sh ./
COPY --chown=developer:developer default-settings.json ./
COPY --chown=developer:developer tmux.conf /home/developer/.tmux.conf

# Make entrypoint executable
RUN chmod +x docker-entrypoint.sh

# Create necessary directories
RUN mkdir -p /home/developer/.config/code-server \
    && mkdir -p /home/developer/workspace

# Expose port (will use Railway's PORT env var)
EXPOSE 8080

# Set working directory
WORKDIR /home/developer

# Entry point
ENTRYPOINT ["/opt/mrpd/docker-entrypoint.sh"]