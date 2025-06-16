#!/bin/bash

# This entrypoint handles the persistent/non-persistent directory split
# 
# Directory structure:
# - /home/developer (persistent volume) - User's actual work files and git configs
#   - Git configuration (.gitconfig)
#   - GitHub CLI authentication
#   - User's VS Code settings (optional)
#   - User's project files in /workspace
# - /opt/mrpd (container filesystem) - Application runtime files
#   - code-server config and data
#   - proxy server application
#   - All non-user configuration

# Code-server runs on internal port 8090
export CODE_SERVER_PORT=8090
# Proxy server uses the PORT env var
export PROXY_PORT=${PORT:-8080}

echo "Starting services..."
echo "- Code-server on port ${CODE_SERVER_PORT}"
echo "- Proxy server on port ${PROXY_PORT}"

# Configure GitHub CLI if token is provided (this can be in persistent home)
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub CLI authentication..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    gh auth setup-git
    
    # Get GitHub username and email if not already configured
    if [ -z "$(git config --global user.name)" ]; then
        GH_USERNAME=$(gh api user -q .login 2>/dev/null)
        if [ -n "$GH_USERNAME" ]; then
            git config --global user.name "$GH_USERNAME"
            GH_EMAIL=$(gh api user -q .email 2>/dev/null)
            if [ -z "$GH_EMAIL" ] || [ "$GH_EMAIL" = "null" ]; then
                GH_EMAIL="${GH_USERNAME}@users.noreply.github.com"
            fi
            git config --global user.email "$GH_EMAIL"
            echo "Git configured for user: $GH_USERNAME"
        fi
    fi
    
    echo "GitHub CLI configured successfully"
else
    echo "No GITHUB_TOKEN found. GitHub CLI not configured."
fi

# Create config and data directories in /opt/mrpd
mkdir -p /opt/mrpd/config/code-server
mkdir -p /opt/mrpd/code-server-data

# Kill any existing processes on our ports
pkill -f "code-server" || true
pkill -f "node.*proxy-server" || true
sleep 1

# Start code-server in background with command line args only
echo "Starting code-server..."
if [ -z "$PASSWORD" ]; then
    export PASSWORD=changeme
    echo "WARNING: Using default password 'changeme'. Set PASSWORD environment variable for security."
fi

# Create a minimal config to prevent code-server from creating its own
cat > /opt/mrpd/config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:${CODE_SERVER_PORT}
auth: password
password: ${PASSWORD}
cert: false
EOF

# Set code-server data directory to /opt/mrpd to avoid home directory
export SERVICE_USER_DATA_DIR=/opt/mrpd/code-server-data

code-server \
    --config /opt/mrpd/config/code-server/config.yaml \
    --user-data-dir /opt/mrpd/code-server-data \
    --disable-update-check \
    --disable-telemetry &

# Wait for code-server to start
echo "Waiting for code-server to start..."
for i in {1..10}; do
    if curl -s http://localhost:${CODE_SERVER_PORT} > /dev/null; then
        echo "Code-server is running on port ${CODE_SERVER_PORT}"
        break
    fi
    sleep 1
done

# Start the proxy server from the app directory
echo "Starting proxy server on port ${PROXY_PORT}..."
cd /opt/mrpd
exec node proxy-server.js