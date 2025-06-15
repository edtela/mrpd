#!/bin/bash

# This script runs when the container starts with authentication

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

# Check if authentication credentials are provided
if [ -n "$TTYD_USERNAME" ] && [ -n "$TTYD_PASSWORD" ]; then
    echo "Authentication enabled for ttyd"
    exec ttyd --port 7681 --writable --credential "$TTYD_USERNAME:$TTYD_PASSWORD" bash
else
    echo "WARNING: Running without authentication!"
    echo "Set TTYD_USERNAME and TTYD_PASSWORD environment variables for security"
    exec ttyd --port 7681 --writable bash
fi