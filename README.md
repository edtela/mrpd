# MRPD - Mobile Remote Programming Desktop

A cloud-based VS Code development environment optimized for mobile devices, powered by code-server.

## Quick Start

### Local Development

1. Clone this repository
2. Run with Docker Compose:
   ```bash
   docker-compose up --build
   ```
3. Access VS Code at http://localhost:8080
4. Login with password: `changeme`

### Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/mrpd)

1. Click the button above
2. Set environment variables:
   - `PASSWORD` (required) - Your login password
   - `GITHUB_TOKEN` (optional) - For GitHub CLI authentication
   - `ANTHROPIC_API_KEY` (optional) - For Claude Code AI assistant
   - `GIT_USER_NAME` (optional) - Your git commit name
   - `GIT_USER_EMAIL` (optional) - Your git commit email
3. Add a persistent volume mounted at `/home/developer`
4. Deploy!

## Features

- **Full VS Code in your browser** - Complete development environment
- **Mobile-optimized** - Touch-friendly UI, larger fonts, better scrollbars
- **Persistent workspace** - Your files survive container restarts
- **Pre-installed tools**:
  - Git & GitHub CLI
  - Claude Code AI assistant
  - Node.js, TypeScript, ESLint, Prettier
  - tmux for persistent terminal sessions
  - ripgrep and fd for fast file searching
- **Bash aliases** - Shortcuts for common commands
- **Auto-configuration** - Git, GitHub CLI, and Claude Code set up automatically

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `PASSWORD` | Yes | Password for code-server authentication |
| `PORT` | Auto | Automatically set by Railway |
| `GITHUB_TOKEN` | No | GitHub personal access token for CLI |
| `ANTHROPIC_API_KEY` | No | API key for Claude Code |
| `GIT_USER_NAME` | No | Default git commit author name |
| `GIT_USER_EMAIL` | No | Default git commit author email |

## Architecture

- **code-server** runs directly on the PORT provided by Railway
- **/home/developer** is persisted as a volume mount
- **/opt/mrpd** contains all application files
- Mobile-friendly VS Code settings are applied on first run

## Tips for Mobile Development

- Use the integrated terminal with tmux for persistent sessions
- Bash aliases make typing easier: `gs` (git status), `ga` (git add), etc.
- Claude Code is available as `claude` or `cc` command
- Touch and hold for right-click context menus
- Pinch to zoom works in the editor

## Support

For issues and feature requests, please use the GitHub issues page.