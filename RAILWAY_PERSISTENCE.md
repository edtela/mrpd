# Railway Persistence Setup

## Option 1: Full Home Directory (Recommended)

In Railway, add a persistent volume:
1. Go to your service settings
2. Add volume mount: `/home/developer`
3. This persists all VS Code settings, extensions, git config, etc.

## Option 2: Selective Persistence

If you want to be more selective, mount these paths:
- `/home/developer/.local` - VS Code data
- `/home/developer/.config` - Configurations  
- `/home/developer/.ssh` - SSH keys
- `/workspace` - Your code

## How It Works

Our entrypoint script (`/opt/mrpd/docker-entrypoint.sh`):
1. Runs from `/opt/mrpd` (not affected by persistence)
2. Cleans up any old code-server config files
3. Starts code-server with command-line args (no config file)
4. Starts the proxy server

This design ensures:
- Your settings persist across restarts
- No conflicts with startup scripts
- Clean startup every time