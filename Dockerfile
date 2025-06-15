FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    sudo \
    locales \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install ripgrep (required by Claude Code and VS Code search)
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb \
    && dpkg -i ripgrep_14.1.0-1_amd64.deb \
    && rm ripgrep_14.1.0-1_amd64.deb

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install global npm packages
RUN npm install -g \
    typescript \
    ts-node \
    nodemon \
    prettier \
    eslint \
    @types/node


# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && chown developer:developer /workspace

# Switch to non-root user
USER developer
WORKDIR /workspace

# Install VS Code extensions
RUN code-server --install-extension dbaeumer.vscode-eslint \
    --install-extension esbenp.prettier-vscode \
    --install-extension ms-vscode.vscode-typescript-next \
    || true

# Copy application files
COPY --chown=developer:developer startup.sh /home/developer/startup.sh
COPY --chown=developer:developer railway-init.sh /home/developer/railway-init.sh
COPY --chown=developer:developer proxy-server.js /home/developer/proxy-server.js
COPY --chown=developer:developer package.json /home/developer/package.json
RUN chmod +x /home/developer/startup.sh /home/developer/railway-init.sh

# Install proxy dependencies
WORKDIR /home/developer
RUN npm install --production
WORKDIR /workspace

# Railway will provide PORT env var, but we expose multiple common ports
EXPOSE 3000 8080

# Start with railway-init for persistence handling
CMD ["/home/developer/railway-init.sh"]