#!/bin/bash
set -e

echo "Starting MRPD (Mobile Remote Programming Desktop)..."

# Ensure npm global bin directory is in PATH
export PATH="/home/developer/.npm-global/bin:$PATH"

# Create necessary directories if they don't exist
mkdir -p /home/developer/.local/share/code-server/User
mkdir -p /home/developer/.config/code-server
mkdir -p /home/developer/workspace

# Copy default VS Code settings if they don't exist (first run)
if [ ! -f "/home/developer/.local/share/code-server/User/settings.json" ]; then
    echo "First run detected - copying default mobile-friendly settings..."
    cp /opt/mrpd/default-settings.json /home/developer/.local/share/code-server/User/settings.json
fi

# Copy tmux config if it doesn't exist
if [ ! -f "/home/developer/.tmux.conf" ]; then
    echo "Setting up tmux configuration..."
    cp /opt/mrpd/tmux.conf /home/developer/.tmux.conf
fi

# Create code-server config to ensure it uses port 8081
echo "Creating code-server configuration..."
mkdir -p $(dirname "$CODE_SERVER_CONFIG")
cat > "$CODE_SERVER_CONFIG" <<EOF
bind-addr: 127.0.0.1:8081
auth: password
password: ${PASSWORD:-changeme}
cert: false
EOF

# Configure git global settings if not already configured
if [ ! -f "/home/developer/.gitconfig" ]; then
    echo "Setting up git configuration..."
    git config --global user.name "${GIT_USER_NAME:-Developer}"
    git config --global user.email "${GIT_USER_EMAIL:-developer@mrpd.local}"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "code-server --wait"
fi

# Configure GitHub CLI if GITHUB_TOKEN is provided
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub CLI..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
    # Configure git to use gh for authentication
    gh auth setup-git 2>/dev/null || true
fi

# Configure Claude Code if API key is provided
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "Claude Code API key detected - will be available for use"
    # Claude Code uses ANTHROPIC_API_KEY environment variable automatically
fi

# Create SSH directory if it doesn't exist
mkdir -p /home/developer/.ssh
chmod 700 /home/developer/.ssh

# Run development tools initialization if not already done
if [ ! -f "/home/developer/.mrpd-dev-tools-initialized" ]; then
    echo "Initializing development tools..."
    /opt/mrpd/dev-tools-init.sh
    touch /home/developer/.mrpd-dev-tools-initialized
fi

# Start code-server in the background
echo "Starting code-server on port 8081..."
# Export PASSWORD for code-server to use
export PASSWORD="${PASSWORD:-changeme}"
# Use --disable-update-check to prevent config file auto-creation
/opt/mrpd/bin/code-server \
    --bind-addr 127.0.0.1:8081 \
    --auth password \
    --disable-update-check \
    --user-data-dir /home/developer/.local/share/code-server \
    --extensions-dir /home/developer/.local/share/code-server/extensions \
    /home/developer/workspace &

CODE_SERVER_PID=$!

# Wait for code-server to start
echo "Waiting for code-server to start..."
sleep 5

# Start the proxy server
# Debug: show what PORT is set to
echo "PORT environment variable is: ${PORT}"
echo "Starting proxy server on port ${PORT:-8000}..."
cd /opt/mrpd
exec node proxy-server.js