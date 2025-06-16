#!/bin/bash
# Development tools initialization script
# This script sets up aliases and configurations for development tools

# Create useful aliases for mobile development
cat >> /home/developer/.bashrc << 'EOF'

# Claude Code aliases
alias claude='claude-code'
alias cc='claude-code'

# Git aliases for mobile-friendly usage
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# GitHub CLI aliases
alias ghi='gh issue'
alias ghpr='gh pr'
alias ghrepo='gh repo'

# Directory navigation
alias ws='cd /home/developer/workspace'
alias ..='cd ..'
alias ...='cd ../..'

# Development shortcuts
alias ll='ls -la'
alias cls='clear'

# tmux shortcuts
alias tn='tmux new-session -s'
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'

# Node/npm shortcuts
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'

# Show current git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Mobile-friendly prompt with git branch
export PS1='\[\033[01;32m\]\u@mrpd\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '

# Welcome message
echo "Welcome to MRPD! 🚀"
echo "Quick tips:"
echo "  - Use 'claude' or 'cc' to start Claude Code"
echo "  - Use 'ws' to go to your workspace"
echo "  - Terminal sessions persist with tmux"
echo "  - Type 'alias' to see all shortcuts"
echo ""

EOF

# Create a Claude Code configuration template
cat > /home/developer/.claude-code-tips.md << 'EOF'
# Claude Code Quick Reference

## Starting Claude Code
```bash
claude-code              # Start Claude Code
cc                       # Short alias
export ANTHROPIC_API_KEY=your-key  # Set API key if not done
```

## Common Commands in Claude Code
- `/help` - Show all commands
- `/model` - Switch between Claude models
- `/clear` - Clear the conversation
- `/exit` - Exit Claude Code

## Mobile Tips
- Use external keyboard when possible
- Terminal sessions persist via tmux
- All your work is saved in /home/developer/workspace

## Environment Variables
Set these in Railway for automatic configuration:
- `ANTHROPIC_API_KEY` - Your Claude API key
- `GITHUB_TOKEN` - GitHub personal access token
- `GIT_USER_NAME` - Your git username
- `GIT_USER_EMAIL` - Your git email
EOF

echo "Development tools initialization complete!"