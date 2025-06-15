# MRPD - Mobile Ready Phone Development Environment

A cloud-based development environment with web terminal access, perfect for coding from your phone.

## Features

- **Web Terminal**: Access via ttyd on port 7681
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
4. Deploy!

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

## Security Notes

- ttyd runs with `--writable` flag for full terminal access
- Consider adding authentication for production use
- Store API keys securely as environment variables

## Usage Tips

1. **From Phone**: Works best with external keyboard or terminal apps
2. **Claude Code**: Run `claude` to start AI assistant
3. **Persistence**: Mount volumes for code that survives container restarts