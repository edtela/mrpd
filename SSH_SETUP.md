# SSH Setup for Mobile Access with Termius

## 1. Generate SSH Key (if you don't have one)

### On your computer:
```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
cat ~/.ssh/id_rsa.pub
```

### In Termius app:
1. Go to **Keychain** → **Keys**
2. Tap **+** → **Generate Key**
3. Name it and tap **Generate**
4. Copy the public key

## 2. Configure Railway Environment

Add your SSH public key to Railway environment variables:
```
SSH_PUBLIC_KEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... your-full-public-key
```

## 3. Connect with Termius

### Railway Connection:
1. Get your Railway app URL (e.g., `mrpd-production.up.railway.app`)
2. In Termius, create new host:
   - **Host**: Your Railway URL
   - **Port**: 2222 (not 22!)
   - **Username**: developer
   - **Authentication**: Use your SSH key

### Local Development:
```
Host: localhost
Port: 2222
Username: developer
Authentication: SSH key
```

## 4. First Connection

After connecting, you'll be in a tmux session with:
- Full terminal access
- Persistent sessions
- All development tools installed
- Your `/workspace` directory mounted

## Tips for Mobile Usage

1. **Termius Gestures**:
   - Swipe right: Tab completion
   - Swipe left: Escape
   - Two-finger tap: Ctrl+C

2. **tmux shortcuts**:
   - `Ctrl+b d`: Detach session
   - `Ctrl+b c`: New window
   - `Ctrl+b n/p`: Next/previous window

3. **Claude Code**: Just run `claude` in the terminal!

## Security Note

- SSH uses key-based authentication only
- No password authentication allowed
- Each deployment needs the SSH_PUBLIC_KEY env variable