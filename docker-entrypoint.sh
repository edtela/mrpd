#!/bin/bash
set -e

echo "Starting MRPD (Mobile Remote Programming Desktop)..."

# Ensure npm global bin directory is in PATH
export PATH="/home/developer/.npm-global/bin:$PATH"

# Use Railway's PORT or default to 8080
PORT="${PORT:-8080}"
echo "Using port: $PORT"

# Create necessary directories if they don't exist
mkdir -p /home/developer/.local/share/code-server/User
mkdir -p /home/developer/.config/code-server
mkdir -p /home/developer/workspace

# Copy default VS Code settings if they don't exist (first run)
if [ ! -f "/home/developer/.local/share/code-server/User/settings.json" ]; then
    echo "First run detected - copying default mobile-friendly settings..."
    cp /opt/mrpd/default-settings.json /home/developer/.local/share/code-server/User/settings.json
fi

# Configure git global settings if not already configured
if [ ! -f "/home/developer/.gitconfig" ]; then
    echo "Setting up git configuration..."
    git config --global user.name "${GIT_USER_NAME:-Developer}"
    git config --global user.email "${GIT_USER_EMAIL:-developer@mrpd.local}"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "code --wait"
fi

# Configure GitHub CLI if GITHUB_TOKEN is provided
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub CLI..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
    gh auth setup-git 2>/dev/null || true
fi

# Configure Claude Code if API key is provided
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "Claude Code API key detected - will be available for use"
fi

# Create SSH directory if it doesn't exist
mkdir -p /home/developer/.ssh
chmod 700 /home/developer/.ssh

# Create bash aliases if they don't exist
if [ ! -f "/home/developer/.bash_aliases" ]; then
    cat > /home/developer/.bash_aliases <<'EOF'
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -la'

# Development
alias ns='npm start'
alias ni='npm install'
alias nr='npm run'

# Claude Code
alias cc='claude'

# Quick edit
alias e='code'
EOF
fi

# Start code-server directly on the PORT
echo "Starting code-server on port ${PORT}..."
export PASSWORD="${PASSWORD:-changeme}"

exec /opt/mrpd/bin/code-server \
    --bind-addr 0.0.0.0:${PORT} \
    --auth password \
    --disable-update-check \
    --user-data-dir /home/developer/.local/share/code-server \
    --extensions-dir /home/developer/.local/share/code-server/extensions \
    /home/developer/workspace