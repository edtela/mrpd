#!/bin/bash

# Use PORT from environment or default to 8080
PORT=${PORT:-8080}

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

# Start code-server with simple config
if [ -n "$PASSWORD" ]; then
    exec code-server --bind-addr 0.0.0.0:${PORT} --auth password
else
    echo "WARNING: Using default password. Set PASSWORD environment variable for security."
    PASSWORD=changeme exec code-server --bind-addr 0.0.0.0:${PORT} --auth password
fi