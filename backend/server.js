import express from 'express';
import fs from 'node:fs/promises';
import pg from 'pg';
import cors from 'cors'; // <--- 1. ต้องเพิ่มบรรทัดนี้เพื่อ import cors

const app = express();
const port = process.env.PORT || 3000;
const { Pool } = pg;
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

app.use(cors());
app.use(express.json());

// --- วาง Route ต่างๆ ของคุณไว้ตรงกลางนี้ เช่น app.get(...) หรือ app.post(...) ---

// 2. นำคำสั่ง app.listen มาไว้ที่บรรทัดล่างสุดตรงนี้ครับ
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});