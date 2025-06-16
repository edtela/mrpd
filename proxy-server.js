const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

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