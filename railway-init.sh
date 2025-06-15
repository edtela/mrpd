#!/bin/bash

# This script handles persistence for Railway deployments
# Railway provides persistent storage at /app

# Create persistent directories if using Railway's persistent storage
if [ -d "/app" ]; then
    echo "Railway persistent storage detected at /app"
    
    # Create persistent directories
    mkdir -p /app/workspace
    mkdir -p /app/vscode-config
    mkdir -p /app/vscode-local
    
    # Create symlinks from home to persistent storage
    ln -sfn /app/workspace /workspace
    ln -sfn /app/vscode-config /home/developer/.config
    ln -sfn /app/vscode-local /home/developer/.local
    
    echo "Persistent storage configured"
fi

# Run the main startup script
exec /home/developer/startup.sh