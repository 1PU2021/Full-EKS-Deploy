const express = require("express");
const client = require("prom-client");

const app = express();
const PORT = 3000;

// Prometheus metrics setup
const register = new client.Registry();

// Add default metrics (CPU, memory, etc.)
client.collectDefaultMetrics({ register });

// Create custom metrics
const httpRequestCounter = new client.Counter({
  name: "http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "route", "status_code"],
  registers: [register],
});

const httpRequestDuration = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "Duration of HTTP requests in seconds",
  labelNames: ["method", "route", "status_code"],
  registers: [register],
});

// Middleware to track metrics
app.use((req, res, next) => {
  const start = Date.now();

  res.on("finish", () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestCounter.inc({
      method: req.method,
      route: req.route ? req.route.path : req.path,
      status_code: res.statusCode,
    });
    httpRequestDuration.observe(
      {
        method: req.method,
        route: req.route ? req.route.path : req.path,
        status_code: res.statusCode,
      },
      duration,
    );
  });

  next();
});

app.get("/", (req, res) => {
  res.send("Hello all from Node.js");
});

app.get("/health", (req, res) => {
  res.json({ status: "UP" });
});

// Prometheus metrics endpoint
app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Metrics available at http://localhost:${PORT}/metrics`);
});