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

# Start ttyd
exec ttyd --port 7681 --writable bash