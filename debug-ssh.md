# SSH Connection Debugging

## 1. Check Railway Logs
Look for SSH startup messages in Railway dashboard logs:
- "SSH public key added for user 'developer'"
- Any error messages from sshd

## 2. Common Issues

### Port Mapping
Railway might not expose custom ports. Check if:
- Railway allows port 2222
- The port is actually accessible from outside

### Environment Variable
Verify SSH_PUBLIC_KEY is set correctly:
- No quotes around the key
- Complete key including `ssh-rsa` prefix
- No line breaks (should be one long line)

## 3. Test Locally First

```bash
# Run locally with your key
docker-compose -f docker-compose.prod.yml up -d

# Test SSH connection
ssh -p 2222 developer@localhost
```

## 4. Alternative: Use Web Terminal + SSH Inside

If Railway doesn't expose SSH port:
1. Connect via web terminal (port 7681)
2. Inside the container, check SSH status:
   ```bash
   sudo service ssh status
   ps aux | grep sshd
   cat ~/.ssh/authorized_keys
   ```

## 5. Railway-Specific Solution

Railway might need explicit port configuration. Try adding to railway.json:
```json
{
  "services": {
    "web": {
      "port": 7681
    },
    "ssh": {
      "port": 22
    }
  }
}
```

## 6. Fallback: Tailscale/ngrok

If Railway doesn't support multiple ports:
1. Install Tailscale or ngrok in the container
2. Expose SSH through the tunnel
3. Connect via the tunnel URL