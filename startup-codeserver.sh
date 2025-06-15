#!/bin/bash

echo "🚀 Welcome to your cloud development environment!"
echo ""
echo "Available tools:"
echo "  - VS Code Server: Starting on port 8080"
echo "  - Claude Code: Run 'claude' in terminal"
echo "  - Node.js: $(node --version)"
echo "  - TypeScript: $(tsc --version)"
echo "  - Git: $(git --version)"
echo "  - GitHub CLI: $(gh --version | head -n1)"
echo ""

# Create code-server config directory
mkdir -p ~/.config/code-server

# Create code-server config with authentication
if [ -n "$CODE_SERVER_PASSWORD" ]; then
    echo "Authentication enabled for code-server"
    cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:8080
auth: password
password: ${CODE_SERVER_PASSWORD}
cert: false
EOF
else
    echo "WARNING: Running without authentication!"
    echo "Set CODE_SERVER_PASSWORD environment variable for security"
    cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:8080
auth: none
cert: false
EOF
fi

# Add user settings for better mobile experience
mkdir -p ~/.local/share/code-server/User
cat > ~/.local/share/code-server/User/settings.json <<EOF
{
  "workbench.colorTheme": "Default Light+",
  "editor.fontSize": 16,
  "terminal.integrated.fontSize": 16,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": false,
  "workbench.activityBar.visible": true,
  "window.zoomLevel": 0,
  "editor.lineNumbers": "on",
  "terminal.integrated.defaultProfile.linux": "tmux",
  "terminal.integrated.profiles.linux": {
    "tmux": {
      "path": "tmux",
      "args": ["new-session", "-A", "-s", "main"]
    }
  }
}
EOF

# Create tmux config for better experience
echo "set -g mouse on" > ~/.tmux.conf
echo "set -g history-limit 10000" >> ~/.tmux.conf

echo ""
echo "Starting VS Code Server..."
echo "Access at: http://your-domain:8080"
echo ""

# Start code-server
exec code-server --host 0.0.0.0