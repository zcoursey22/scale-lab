import express from "express";
import type { Request, Response } from "express";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (_: Request, res: Response) => {
  res.json({ message: "testing" });
});

app.listen(PORT, () => {
  console.log(`Server running at localhost:${PORT}`);
});
