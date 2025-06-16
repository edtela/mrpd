# MRPD - Mobile Ready Phone Development

VS Code in your browser, optimized for mobile development.

## Features

- **VS Code Server**: Full VS Code at `/dev` path
- **Development Proxy**: Your app runs on port 3000, accessible at `/`
- **Mobile Optimized**: Large fonts, touch-friendly interface
- **Claude Code**: AI assistant pre-installed
- **Development Tools**: Node.js, TypeScript, Git, GitHub CLI
- **Persistent Storage**: VS Code settings and workspace preserved

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

1. Open http://your-domain:8080/dev for VS Code
2. Enter password
3. Start your dev server: `npm start` (runs on port 3000)
4. View your app at http://your-domain:8080
5. Claude: Run `claude` in terminal

## Architecture

```
Port 8080 (Railway/Public)
    ├── /dev/* → Code-Server (port 8090)
    └── /* → Your App (port 3000)
```

## Mobile Tips

- Add to home screen for app-like experience
- Use landscape orientation for coding
- External keyboard recommended (or use on-screen)
- Settings optimized: 20px editor font, 18px terminal
- Touch-friendly: larger buttons and touch targets
- Sidebar on right side for easier thumb access
- If fonts still too small: 
  - Use browser zoom (pinch to zoom)
  - Or adjust in Settings > Editor: Font Size

## Persistence

**Local (docker-compose):**
- Workspace files: Named volume `workspace`
- VS Code settings: Named volumes `vscode-config` and `vscode-local`
- Survives container restarts

**Railway:**
- Add persistent volume in Railway dashboard
- Mount to `/home/developer` path
- All VS Code settings, extensions, and configs preserved
- See [CLAUDE.md](CLAUDE.md) for important architecture notes