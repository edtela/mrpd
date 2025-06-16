const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8000;

// Proxy configuration for code-server (VS Code)
const codeServerProxy = createProxyMiddleware({
  target: 'http://localhost:8080',
  changeOrigin: true,
  ws: true,
  pathRewrite: {
    '^/dev': ''
  },
  logLevel: 'warn'
});

// Proxy configuration for user's development server
const devServerProxy = createProxyMiddleware({
  target: 'http://localhost:3000',
  changeOrigin: true,
  ws: true,
  logLevel: 'warn',
  // Don't fail if dev server is not running
  onError: (err, req, res) => {
    console.log('Dev server not running on port 3000');
    res.status(502).send(`
      <html>
        <body style="font-family: system-ui, sans-serif; padding: 40px; text-align: center;">
          <h1>Development Server Not Running</h1>
          <p>Start your development server on port 3000 to see your application here.</p>
          <p>Access VS Code at <a href="/dev">/dev</a></p>
        </body>
      </html>
    `);
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'mrpd-proxy' });
});

// Serve manifest.json for PWA
app.get('/manifest.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'manifest.json'));
});

// Landing page with PWA meta tags
app.get('/', (req, res, next) => {
  // If requesting the root specifically, show landing page
  if (req.path === '/' && req.headers.accept && req.headers.accept.includes('text/html')) {
    res.send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="apple-mobile-web-app-title" content="MRPD">
        <meta name="theme-color" content="#1e1e1e">
        <link rel="manifest" href="/manifest.json">
        <title>MRPD - Mobile Remote Programming Desktop</title>
        <style>
          body {
            font-family: system-ui, -apple-system, sans-serif;
            background: #1e1e1e;
            color: #fff;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
          }
          h1 { margin-bottom: 10px; }
          p { color: #ccc; margin: 10px 0; }
          a {
            display: inline-block;
            background: #007ACC;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 20px;
          }
          .install-note {
            margin-top: 30px;
            padding: 20px;
            background: #2d2d2d;
            border-radius: 8px;
            max-width: 400px;
          }
        </style>
      </head>
      <body>
        <h1>MRPD</h1>
        <p>Mobile Remote Programming Desktop</p>
        <a href="/dev">Open VS Code</a>
        <div class="install-note">
          <p><strong>Install as App:</strong></p>
          <p>iOS: Tap Share → Add to Home Screen</p>
          <p>Android: Tap Menu → Install App</p>
        </div>
      </body>
      </html>
    `);
  } else {
    // Otherwise, proxy to dev server
    next();
  }
});

// Route /dev/* to code-server
app.use('/dev', codeServerProxy);

// Route everything else to the development server
app.use('/', devServerProxy);

// Start the server
app.listen(PORT, () => {
  console.log(`MRPD Proxy Server running on port ${PORT}`);
  console.log(`- VS Code: http://localhost:${PORT}/dev`);
  console.log(`- Dev Server: http://localhost:${PORT}/`);
});