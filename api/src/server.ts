import express from "express";
import { pool } from "./db/index.js";
import userRoutes from "./routes/users.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/healthz", (_req, res) => {
  // Liveness - is server running normally?
  res.json({ status: "ok" });
});

app.get("/readyz", async (_req, res) => {
  // Readiness - are dependencies running normally?
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok" });
  } catch (err) {
    console.error("readyz failed:", err);
    res.status(503).json({ status: "not ok" });
  }
});

app.use("/users", userRoutes);

app.listen(PORT, () => {
  console.log(`Server running at localhost:${PORT}`);
});
