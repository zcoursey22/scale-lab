import express from "express";
import { pool } from "./db/index.js";

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

app.get("/users/:id/orders", async (req, res) => {
  try {
    const userId = Number(req.params.id);
    if (!Number.isSafeInteger(userId) || userId <= 0) {
      res.status(400).json({ message: "Invalid user ID" });
      return;
    }
    const { rows } = await pool.query(
      "SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC LIMIT 50",
      [userId],
    );
    res.json({ orders: rows });
  } catch (err) {
    console.error("orders failed:", err);
    res.status(500).json({ message: "Internal server error" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at localhost:${PORT}`);
});
