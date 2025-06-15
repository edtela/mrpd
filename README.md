# MRPD - Mobile Ready Phone Development

VS Code in your browser, optimized for mobile development.

## Features

- **VS Code Server**: Full VS Code experience in browser
- **Mobile Optimized**: Large fonts, touch-friendly interface
- **Claude Code**: AI assistant pre-installed
- **Development Tools**: Node.js, TypeScript, Git, GitHub CLI
- **Persistent Workspace**: Code saved in /workspace directory

## Quick Start

### Local
```bash
cp .env.example .env
# Edit .env with your password and API keys
docker-compose up -d
```
Access at: http://localhost:8080

### Railway
1. Fork this repo
2. Connect to Railway
3. Set environment variables:
   - `PASSWORD` (required)
   - `ANTHROPIC_API_KEY` (for Claude)
   - `GITHUB_TOKEN` (for GitHub CLI)
4. Deploy!

## What's Included

- Ubuntu 22.04
- Node.js 20.x
- TypeScript, ESLint, Prettier
- Claude Code CLI
- GitHub CLI
- VS Code extensions (ESLint, Prettier, TypeScript)

## Usage

1. Open http://your-domain:8080
2. Enter password
3. Start coding!
4. Terminal: Use integrated terminal in VS Code
5. Claude: Run `claude` in terminal

## Mobile Tips

- Add to home screen for app-like experience
- Use landscape orientation
- External keyboard recommended
- Pinch to zoom works