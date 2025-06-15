#!/bin/bash

# Create code-server config directory
mkdir -p ~/.config/code-server

# Use PORT from environment or default to 8080
PORT=${PORT:-8080}

# Debug: Show what PORT we're using
echo "PORT environment variable: $PORT"
echo "Railway expects the app to listen on port: ${PORT}"

# Configure code-server with authentication
if [ -n "$PASSWORD" ]; then
    cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${PORT}
auth: password
password: ${PASSWORD}
cert: false
proxy-domain: ${RAILWAY_PUBLIC_DOMAIN}
EOF
else
    # Default password if none provided
    cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${PORT}
auth: password
password: changeme
cert: false
proxy-domain: ${RAILWAY_PUBLIC_DOMAIN}
EOF
    echo "WARNING: Using default password 'changeme'. Set PASSWORD environment variable for security."
fi

echo "Starting code-server on port ${PORT}..."

# Create VS Code user settings for mobile
mkdir -p ~/.local/share/code-server/User
cat > ~/.local/share/code-server/User/settings.json <<EOF
{
  "workbench.colorTheme": "Default Light+",
  "editor.fontSize": 16,
  "terminal.integrated.fontSize": 16,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": false,
  "window.zoomLevel": 0
}
EOF

# Start code-server with verbose logging
exec code-server --verbose