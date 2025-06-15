#!/bin/bash

# Code-server runs on internal port 8090
CODE_SERVER_PORT=8090
# Proxy server uses the PORT env var
PROXY_PORT=${PORT:-8080}

echo "Starting services..."
echo "- Code-server on port ${CODE_SERVER_PORT}"
echo "- Proxy server on port ${PROXY_PORT}"

# Configure GitHub CLI if token is provided
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

# Create code-server config directory
mkdir -p ~/.config/code-server

# Create config file
cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${CODE_SERVER_PORT}
auth: password
password: ${PASSWORD:-changeme}
cert: false
EOF

# Create VS Code user settings for mobile with larger fonts
mkdir -p ~/.local/share/code-server/User
cat > ~/.local/share/code-server/User/settings.json <<EOF
{
  "workbench.colorTheme": "Default Light+",
  "editor.fontSize": 20,
  "terminal.integrated.fontSize": 18,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": false,
  "window.zoomLevel": 1,
  "editor.lineHeight": 28,
  "workbench.tree.indent": 20,
  "workbench.activityBar.iconClickBehavior": "toggle",
  "editor.padding.top": 10,
  "editor.padding.bottom": 10,
  "terminal.integrated.lineHeight": 1.2,
  "editor.cursorWidth": 3,
  "workbench.list.horizontalScrolling": false,
  "editor.scrollbar.verticalScrollbarSize": 15,
  "editor.scrollbar.horizontalScrollbarSize": 15,
  "workbench.sideBar.location": "right",
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": false
  },
  "editor.suggest.fontSize": 16,
  "debug.console.fontSize": 16,
  "markdown.preview.fontSize": 18,
  "terminal.integrated.fontWeight": "500",
  "scm.inputFontSize": 16,
  "editor.smoothScrolling": true,
  "workbench.list.smoothScrolling": true,
  "terminal.integrated.smoothScrolling": true,
  "editor.scrollPredominantAxis": false,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.dragAndDrop": false,
  "workbench.list.multiSelectModifier": "ctrlCmd"
}
EOF

# Create a custom CSS file for additional mobile optimizations
mkdir -p ~/.local/share/code-server
cat > ~/.local/share/code-server/custom.css <<EOF
/* Enable smooth touch scrolling */
* {
    -webkit-overflow-scrolling: touch !important;
    scroll-behavior: smooth !important;
}

/* Improve scrolling performance */
.monaco-scrollable-element {
    -webkit-overflow-scrolling: touch !important;
    will-change: transform !important;
}

/* Terminal touch scrolling */
.xterm-viewport {
    -webkit-overflow-scrolling: touch !important;
    overflow-y: auto !important;
}

/* Editor scrolling */
.monaco-editor .overflow-guard {
    -webkit-overflow-scrolling: touch !important;
}

/* Sidebar scrolling */
.monaco-workbench .part.sidebar {
    -webkit-overflow-scrolling: touch !important;
}

/* Larger touch targets for mobile */
.monaco-workbench .part.activitybar > .content .monaco-action-bar .action-item {
    width: 60px !important;
    height: 60px !important;
}

/* Bigger file explorer items */
.monaco-list-row {
    height: 40px !important;
    line-height: 40px !important;
}

/* Larger tab height */
.monaco-workbench .part.editor > .content .editor-group-container > .title .tabs-container > .tab {
    height: 45px !important;
}

/* Bigger buttons */
.monaco-button {
    min-height: 40px !important;
    padding: 10px 20px !important;
    font-size: 16px !important;
}

/* Larger context menu items */
.monaco-menu .monaco-action-bar .action-item {
    height: 35px !important;
}

/* Better spacing for touch */
.monaco-editor .margin {
    width: 70px !important;
}

/* Larger breadcrumbs */
.monaco-breadcrumbs {
    height: 35px !important;
    font-size: 16px !important;
}

/* Prevent text selection while scrolling */
.monaco-workbench {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    user-select: none;
}

/* Allow text selection in editor */
.monaco-editor .view-lines {
    -webkit-user-select: text !important;
    user-select: text !important;
}
EOF

# Kill any existing processes on our ports
pkill -f "code-server" || true
pkill -f "node.*proxy-server" || true
sleep 1

# Start code-server in background
if [ -n "$PASSWORD" ]; then
    echo "Starting code-server with password authentication..."
else
    echo "WARNING: Using default password 'changeme'. Set PASSWORD environment variable for security."
fi

code-server \
    --bind-addr 0.0.0.0:${CODE_SERVER_PORT} \
    --disable-update-check \
    --user-data-dir /home/developer/.local/share/code-server \
    --disable-telemetry &

# Wait for code-server to start
echo "Waiting for code-server to start..."
sleep 5

# Verify code-server is running
if ! curl -s http://localhost:${CODE_SERVER_PORT} > /dev/null; then
    echo "Error: code-server failed to start"
    exit 1
fi

echo "Code-server is running on port ${CODE_SERVER_PORT}"

# Start the proxy server
echo "Starting proxy server on port ${PROXY_PORT}..."
PORT=${PROXY_PORT} exec node /home/developer/proxy-server.js