#!/bin/bash

# Use PORT from environment or default to 8080
PORT=${PORT:-8080}

echo "Starting code-server on port ${PORT}..."

# Create code-server config directory
mkdir -p ~/.config/code-server

# Create config file
cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${PORT}
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
  "scm.inputFontSize": 16
}
EOF

# Create a custom CSS file for additional mobile optimizations
mkdir -p ~/.local/share/code-server
cat > ~/.local/share/code-server/custom.css <<EOF
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
EOF

# Start code-server with mobile optimizations
if [ -n "$PASSWORD" ]; then
    echo "Starting with password authentication..."
else
    echo "WARNING: Using default password 'changeme'. Set PASSWORD environment variable for security."
fi

exec code-server \
    --disable-update-check \
    --user-data-dir /home/developer/.local/share/code-server