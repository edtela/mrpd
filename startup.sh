#!/bin/bash

# This script runs when the container starts

echo "🚀 Welcome to your cloud development environment!"
echo ""
echo "Available tools:"
echo "  - Claude Code: Run 'claude' to start"
echo "  - Node.js: $(node --version)"
echo "  - TypeScript: $(tsc --version)"
echo "  - Git: $(git --version)"
echo "  - GitHub CLI: $(gh --version | head -n1)"
echo ""
echo "Web terminal is available on port 7681"
echo ""

# Terminal theme configuration (GitHub Light theme)
LIGHT_THEME='{"foreground":"#24292e","background":"#ffffff","cursor":"#24292e","black":"#24292e","red":"#d73a49","green":"#28a745","yellow":"#dbab09","blue":"#0366d6","magenta":"#5a32a3","cyan":"#0598bc","white":"#6a737d","brightBlack":"#959da5","brightRed":"#cb2431","brightGreen":"#22863a","brightYellow":"#b08800","brightBlue":"#005cc5","brightMagenta":"#5a32a3","brightCyan":"#3192aa","brightWhite":"#d1d5da"}'

# Create tmux config for better experience
echo "set -g mouse on" > ~/.tmux.conf
echo "set -g history-limit 10000" >> ~/.tmux.conf

# Start ttyd with tmux
exec ttyd --port 7681 --writable \
    --client-option fontSize=14 \
    --client-option "theme=${TERMINAL_THEME:-$LIGHT_THEME}" \
    tmux new-session -A -s main