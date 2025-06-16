# MRPD - Mobile Remote Programming Desktop

A cloud-based VS Code development environment optimized for mobile devices, designed to run on Railway with persistent storage.

## Features

- **Mobile-Optimized Interface**: Larger fonts, touch-friendly UI elements, and mobile keyboard fixes
- **Persistent Terminal Sessions**: tmux integration ensures terminals survive browser disconnects
- **Dual Server Architecture**: VS Code on `/dev/*` and your app on `/`
- **Persistent Storage**: All user files and settings survive redeployments
- **GitHub Integration**: Optional GitHub CLI authentication support

## Quick Start

### Deploy to Railway

1. Fork this repository
2. Connect to Railway and create a new project
3. Add a persistent volume mounted at `/home/developer`
4. Set environment variables:
   - `PASSWORD`: Your code-server password
   - `GITHUB_TOKEN`: (Optional) For GitHub CLI authentication
5. Deploy!

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/mrpd.git
cd mrpd

# Run with Docker Compose
docker-compose up

# Access at http://localhost:8000/dev
```

## Usage

1. **Access VS Code**: Navigate to `https://your-app.railway.app/dev`
2. **Start Development**: Create your project in `/home/developer/workspace`
3. **Run Your App**: Start your dev server on port 3000
4. **View Your App**: Access at `https://your-app.railway.app/`

## Mobile Tips

- Use external keyboard when possible for best experience
- Terminal sessions persist - use tmux shortcuts (Ctrl+a)
- Pinch to zoom is supported
- Copy/paste works with touch selection

## Environment Variables

### Required
- `PASSWORD`: Authentication password for code-server

### Optional
- `GITHUB_TOKEN`: GitHub personal access token for CLI authentication
- `ANTHROPIC_API_KEY`: API key for Claude Code
- `GIT_USER_NAME`: Your name for git commits (default: "Developer")
- `GIT_USER_EMAIL`: Your email for git commits (default: "developer@mrpd.local")
- `PORT`: HTTP port (automatically provided by Railway)

## Architecture

See [CLAUDE.md](CLAUDE.md) for detailed architecture and development notes.

## License

MIT