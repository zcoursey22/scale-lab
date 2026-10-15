import { Router } from "express";
import { pool } from "../db/index.js";

const router = Router();

router.get("/:id/orders", async (req, res) => {
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

export default router;
