# VS Code Server Setup

## Overview

VS Code Server (code-server) provides a full VS Code experience in your browser, perfect for mobile development with:
- Touch-friendly interface
- Integrated terminal with tmux
- File explorer and editor
- Extensions support
- Mobile-optimized settings

## Deployment

### Railway
1. The default `railway.json` now uses `Dockerfile.codeserver`
2. Add environment variable:
   - `CODE_SERVER_PASSWORD=your-secure-password`
3. Deploy and access on port 8080

### Local Testing
```bash
docker-compose -f docker-compose.codeserver.yml up -d
```
Access at: http://localhost:8080

## Mobile Experience

### Features
- **Large fonts**: 16px editor and terminal
- **Light theme**: Better for mobile screens
- **Word wrap**: Enabled by default
- **No minimap**: More screen space
- **Touch gestures**: Pinch to zoom works

### Terminal
- Opens in tmux automatically
- Session persists across reconnects
- Touch-friendly with on-screen keyboard

### Tips
1. **Add to Home Screen**: For app-like experience
2. **Landscape mode**: Best for coding
3. **External keyboard**: Bluetooth keyboards work great
4. **Split view**: Use terminal + editor side by side

## Running Claude Code

In the integrated terminal:
```bash
claude
```

## VS Code Extensions

Pre-installed:
- Python
- ESLint
- Prettier
- GitLens
- TypeScript
- GitHub Copilot (if you have access)

## Security

- Password protected by default
- Set `CODE_SERVER_PASSWORD` in environment
- HTTPS recommended for production