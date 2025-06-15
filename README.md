# MRPD - Mobile Ready Phone Development Environment

A cloud-based development environment with VS Code in your browser, perfect for coding from your phone.

## Features

- **VS Code Server**: Full VS Code in browser (port 8080)
- **Web Terminal**: Alternative via ttyd (port 7681)
- **SSH Access**: Native terminal via Termius/SSH (port 2222)
- **Claude Code**: Pre-installed AI coding assistant
- **Node.js/TypeScript**: Full development stack
- **GitHub Integration**: CLI tools included
- **Docker-based**: Consistent environment everywhere
- **Mobile Optimized**: Touch-friendly with large fonts

## Quick Start

### Local Development
1. Copy `.env.example` to `.env` and add your API keys
2. Run: `docker-compose -f docker-compose.codeserver.yml up -d`
3. Access VS Code at: `http://localhost:8080`

### Deploy to Railway
1. Fork this repository
2. Connect to Railway
3. Add environment variables:
   - `ANTHROPIC_API_KEY`
   - `GITHUB_TOKEN`
   - `CODE_SERVER_PASSWORD` (for VS Code auth)
   - `SSH_PUBLIC_KEY` (optional, for SSH access)
4. Deploy!
5. Access VS Code on port 8080

### Deploy to Other Platforms
The Dockerfile is compatible with most container platforms (Fly.io, Render, etc.)

## What's Included

- Ubuntu 22.04 base
- Node.js 20.x
- TypeScript, ESLint, Prettier
- Claude Code CLI
- GitHub CLI
- ripgrep, git, vim, nano
- VS Code Server (code-server)
- ttyd web terminal (alternative)
- tmux (persistent sessions)

## Security Notes

- VS Code Server requires password authentication
- Store API keys securely as environment variables
- HTTPS recommended for production use

## Usage Tips

1. **From Phone**: Works best with external keyboard or terminal apps
2. **Claude Code**: Run `claude` to start AI assistant
3. **Persistence**: Mount volumes for code that survives container restarts
4. **Session Management**: tmux keeps your session alive when you disconnect
   - Detach: `Ctrl+b d`
   - List sessions: `tmux ls`
   - Reattach: Automatic when reconnecting
5. **Mobile Access**: See [CODESERVER.md](CODESERVER.md) for VS Code tips
6. **SSH Alternative**: See [SSH_SETUP.md](SSH_SETUP.md) for native terminal