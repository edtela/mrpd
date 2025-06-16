# MRPD - Mobile Remote Programming Desktop

## Project Overview

MRPD (Mobile Remote Programming Desktop) is a cloud-based development environment designed for coding from mobile devices. It provides a full VS Code experience through code-server, accessible via any web browser.

The system runs code-server directly on the PORT provided by the hosting platform (Railway or local).

## Architecture

**IMPORTANT: The `/home/developer` directory is persisted as a volume mount!**

### Volume Mount Timing
- The persistent volume is mounted **after** the container image is built but **before** the entrypoint script runs
- This means:
  1. Build phase: Volume is NOT mounted (don't put files in `/home/developer` during build)
  2. Runtime phase: Volume IS mounted (entrypoint can read/write to `/home/developer`)
  3. Our entrypoint script can check if settings exist and copy defaults if needed

### Directory Structure

- **`/home/developer`** (PERSISTENT VOLUME - survives deployments)
  - User's workspace files
  - Git configuration (`.gitconfig`)
  - GitHub CLI authentication
  - VS Code user settings
  - SSH keys
  - Any user data that should persist

- **`/opt/mrpd`** (CONTAINER FILESYSTEM - rebuilt each deployment)
  - Application scripts (`docker-entrypoint.sh`)
  - Runtime configurations
  - code-server installation
  - Default settings and configurations
  - **ALL SCRIPTS AND CONFIGS MUST GO HERE**

## Critical Notes for Development

### **⚠️ NEVER put scripts or configs in the home directory!**

Since `/home/developer` is a persistent volume mount:
1. Files placed there during build will be **hidden** by the volume mount
2. The volume mount happens **after** the container is built
3. Any scripts in `/home/developer` won't be available at runtime

### **✅ ALWAYS use `/opt/mrpd` for:**
- Startup scripts
- Configuration files
- Application code
- Runtime data that shouldn't persist
- Any files needed for the container to function

## Deployment on Railway

This project is designed to run on Railway with:
- A persistent volume mounted at `/home/developer`
- Environment variables:
  - `PASSWORD` - For code-server authentication (required)
  - `GITHUB_TOKEN` - For GitHub CLI authentication (optional)
  - `ANTHROPIC_API_KEY` - For Claude Code (optional)
  - `GIT_USER_NAME` - Git commit author name (optional)
  - `GIT_USER_EMAIL` - Git commit author email (optional)
  - `PORT` - Automatically provided by Railway

## Pre-installed Development Tools

The image includes:
- **Git** - Version control with mobile-friendly aliases
- **GitHub CLI (gh)** - GitHub operations from terminal
- **Claude Code** - AI coding assistant (`claude` or `cc` command)
- **tmux** - Persistent terminal sessions
- **ripgrep (rg)** - Fast file search
- **fd** - User-friendly find alternative
- **Node.js & npm** - JavaScript runtime and package manager
- **TypeScript, ESLint, Prettier** - Development utilities

### Tool Configurations
- Git is pre-configured with sensible defaults
- GitHub CLI auto-authenticates with `GITHUB_TOKEN`
- Claude Code uses `ANTHROPIC_API_KEY` automatically
- Bash aliases for common operations (see `alias` command)
- tmux configured for mobile use (mouse support, Ctrl+a prefix)

## Development Workflow

1. Access VS Code at `https://your-app.railway.app/`
2. Your files persist in `/home/developer/workspace`
3. Use the integrated terminal for all development tasks
4. All development tools are pre-installed and configured

## Mobile/Touch-Friendly Configuration

### VS Code Settings
The system includes mobile-optimized default settings that are copied to the user's settings directory on first run:

- **Default settings location**: `/opt/mrpd/default-settings.json`
- **User settings location**: `/home/developer/.local/share/code-server/User/settings.json`
- **First-run behavior**: Defaults are copied if user settings don't exist (checked at container startup)

### Mobile Optimizations Include:
- Larger terminal font size (16px) for better readability
- Touch-friendly terminal cursor settings
- Increased editor font size
- Simplified UI for smaller screens
- Touch gesture support
- Mobile keyboard workarounds
- Wider scrollbars for touch interaction
- Disabled minimap for more screen space

### Terminal Configuration
Special attention to terminal usability on mobile:
- Larger font size and line height
- Touch-friendly selection
- Copy/paste optimizations
- Keyboard shortcut fixes for mobile browsers

### Persistent Terminal Sessions with tmux
To prevent loss of terminal sessions when browser disconnects (critical for mobile):

- **tmux integration**: All terminals automatically use tmux sessions
- **Session naming**: Each workspace gets its own tmux session
- **Auto-attach**: Reopening terminals reconnects to existing sessions
- **Benefits**:
  - Terminal sessions survive browser refresh/close
  - Long-running processes continue in background
  - Command history preserved across sessions
  - Essential for unstable mobile connections
- **tmux config**: Mouse support, increased scrollback, user-friendly keybindings

## Local Development

To run locally:
```bash
docker-compose up --build
```

Then access code-server at http://localhost:8080 with password "changeme".