# MRPD - Mobile Ready Phone Development

VS Code in your browser, optimized for mobile development.

## Features

- **VS Code Server**: Full VS Code experience in browser
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

1. Open http://your-domain:8080
2. Enter password
3. Start coding!
4. Terminal: Use integrated terminal in VS Code
5. Claude: Run `claude` in terminal

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
- Mount to `/app` path
- All settings and files preserved between deployments