# Terminal Theme Configuration

## Method 1: Browser-based Theme Switching

ttyd respects your browser's color scheme preference. On most phones:
- **iOS**: Settings → Display & Brightness → Light/Dark
- **Android**: Settings → Display → Dark theme

## Method 2: Custom CSS Theme

Add custom CSS to your startup scripts by modifying the ttyd command:

### Light Theme (GitHub Style)
```bash
ttyd --port 7681 --writable --credential "$TTYD_USERNAME:$TTYD_PASSWORD" \
  --client-option fontSize=14 \
  --client-option 'theme={"foreground":"#24292e","background":"#ffffff","cursor":"#24292e","black":"#24292e","red":"#d73a49","green":"#28a745","yellow":"#dbab09","blue":"#0366d6","magenta":"#5a32a3","cyan":"#0598bc","white":"#6a737d","brightBlack":"#959da5","brightRed":"#cb2431","brightGreen":"#22863a","brightYellow":"#b08800","brightBlue":"#005cc5","brightMagenta":"#5a32a3","brightCyan":"#3192aa","brightWhite":"#d1d5da"}' \
  bash
```

### Solarized Light Theme
```bash
ttyd --port 7681 --writable --credential "$TTYD_USERNAME:$TTYD_PASSWORD" \
  --client-option fontSize=14 \
  --client-option 'theme={"foreground":"#657b83","background":"#fdf6e3","cursor":"#586e75","black":"#073642","red":"#dc322f","green":"#859900","yellow":"#b58900","blue":"#268bd2","magenta":"#d33682","cyan":"#2aa198","white":"#eee8d5","brightBlack":"#002b36","brightRed":"#cb4b16","brightGreen":"#586e75","brightYellow":"#657b83","brightBlue":"#839496","brightMagenta":"#6c71c4","brightCyan":"#93a1a1","brightWhite":"#fdf6e3"}' \
  bash
```

## Method 3: Update Startup Script

To make the theme permanent, update the startup-secure.sh file with your preferred theme.