const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();

const PORT = process.env.PORT || 8080;
const CODE_SERVER_PORT = 8090;
const DEV_SERVER_PORT = 3000;

// Health check endpoint for Railway
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Proxy /dev/* to code-server
app.use('/dev', createProxyMiddleware({
  target: `http://localhost:${CODE_SERVER_PORT}`,
  pathRewrite: { '^/dev': '' },
  ws: true,
  changeOrigin: true,
  logLevel: 'debug',
  onProxyReq: (proxyReq, req, res) => {
    // Handle authentication headers if needed
    if (req.headers.cookie) {
      proxyReq.setHeader('Cookie', req.headers.cookie);
    }
  },
  onError: (err, req, res) => {
    console.error('Code-server proxy error:', err);
    res.status(502).send('Code-server is starting up...');
  }
}));

// Proxy everything else to dev server on port 3000
app.use('/', createProxyMiddleware({
  target: `http://localhost:${DEV_SERVER_PORT}`,
  ws: true,
  changeOrigin: true,
  logLevel: 'debug',
  onError: (err, req, res) => {
    console.error('Dev server proxy error:', err);
    res.status(200).send(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>MRPD - Development Environment</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            text-align: center;
          }
          h1 { color: #007ACC; }
          .button {
            display: inline-block;
            padding: 15px 30px;
            margin: 10px;
            background: #007ACC;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
          }
          .info {
            background: #f0f0f0;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
          }
          code {
            background: #e0e0e0;
            padding: 2px 5px;
            border-radius: 3px;
            font-size: 16px;
          }
        </style>
      </head>
      <body>
        <h1>Welcome to MRPD</h1>
        <div class="info">
          <p>Your development server is not running yet.</p>
          <p>Start your app on port <code>3000</code> to see it here.</p>
        </div>
        <a href="/dev" class="button">Open VS Code</a>
        <p style="margin-top: 30px; color: #666;">
          In the VS Code terminal, run:<br>
          <code>cd /workspace && npm start</code>
        </p>
      </body>
      </html>
    `);
  }
}));

app.listen(PORT, () => {
  console.log(`Proxy server running on port ${PORT}`);
  console.log(`- Code-server: http://localhost:${PORT}/dev`);
  console.log(`- Dev server: http://localhost:${PORT}/`);
});