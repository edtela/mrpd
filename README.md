# MRPD - Mobile Ready Phone Development Environment

A cloud-based development environment with web terminal access, perfect for coding from your phone.

## Features

- **Web Terminal**: Access via ttyd on port 7681
- **SSH Access**: Native terminal via Termius/SSH (port 2222)
- **Claude Code**: Pre-installed AI coding assistant
- **Node.js/TypeScript**: Full development stack
- **GitHub Integration**: CLI tools included
- **Docker-based**: Consistent environment everywhere

## Quick Start

### Local Development
1. Copy `.env.example` to `.env` and add your API keys
2. Run: `docker-compose up -d`
3. Access terminal at: `http://localhost:7681`

### Deploy to Railway
1. Fork this repository
2. Connect to Railway
3. Add environment variables:
   - `ANTHROPIC_API_KEY`
   - `GITHUB_TOKEN`
   - `TTYD_USERNAME` and `TTYD_PASSWORD` (for web terminal auth)
   - `SSH_PUBLIC_KEY` (for SSH access)
4. Deploy!
5. Connect via SSH on port 2222 or web on port 7681

### Deploy to Other Platforms
The Dockerfile is compatible with most container platforms (Fly.io, Render, etc.)

## What's Included

- Ubuntu 22.04 base
- Node.js 20.x
- TypeScript, ESLint, Prettier
- Claude Code CLI
- GitHub CLI
- ripgrep, git, vim, nano
- ttyd web terminal
- tmux (persistent sessions)

## Security Notes

- ttyd runs with `--writable` flag for full terminal access
- Consider adding authentication for production use
- Store API keys securely as environment variables

## Usage Tips

1. **From Phone**: Works best with external keyboard or terminal apps
2. **Claude Code**: Run `claude` to start AI assistant
3. **Persistence**: Mount volumes for code that survives container restarts
4. **Session Management**: tmux keeps your session alive when you disconnect
   - Detach: `Ctrl+b d`
   - List sessions: `tmux ls`
   - Reattach: Automatic when reconnecting
5. **Mobile Access**: See [SSH_SETUP.md](SSH_SETUP.md) for Termius configuration