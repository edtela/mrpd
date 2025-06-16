# MRPD - Mobile Remote Programming Desktop

## Project Overview

MRPD (Mobile Remote Programming Desktop) is a cloud-based development environment designed for coding from mobile devices. It provides a full VS Code experience through code-server, accessible via any web browser.

The system consists of:
- **VS Code Server (code-server)** - Running on port 8090 internally
- **Proxy Server** - Running on port 8080 (or Railway's PORT), routing:
  - `/dev/*` → VS Code interface
  - `/` → Your development server (port 3000)

## Architecture

**IMPORTANT: The `/home/developer` directory is persisted as a volume mount!**

### Directory Structure

- **`/home/developer`** (PERSISTENT VOLUME - survives deployments)
  - User's workspace files
  - Git configuration (`.gitconfig`)
  - GitHub CLI authentication
  - VS Code user settings
  - SSH keys
  - Any user data that should persist

- **`/opt/mrpd`** (CONTAINER FILESYSTEM - rebuilt each deployment)
  - Application scripts (`docker-entrypoint.sh`, `proxy-server.js`)
  - Runtime configurations
  - code-server config and data
  - Node modules for proxy server
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
  - `PASSWORD` - For code-server authentication
  - `GITHUB_TOKEN` - For GitHub CLI authentication (optional)
  - `PORT` - Automatically provided by Railway

## Development Workflow

1. Access VS Code at `https://your-app.railway.app/dev`
2. Your files persist in `/workspace` (part of home directory)
3. Start your dev server on port 3000
4. Access your app at `https://your-app.railway.app/`

## Testing Commands

When making changes, always test with:
```bash
npm run lint
npm run typecheck
```