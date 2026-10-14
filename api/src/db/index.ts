import { Pool } from "pg";

const pool = new Pool();

pool.on("error", (err: Error) => {
  console.error(err);
});

export { pool };
