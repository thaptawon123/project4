import cors from 'cors';
import express from 'express';
import fs from 'node:fs/promises';
import pg from 'pg';

const app = express();
const port = process.env.PORT || 3000;
const { Pool } = pg;
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

app.use(cors());
app.use(express.json());

app.get('/api/health', (_request, response) => {
  response.json({ status: 'ok', service: 'campus-nutrition-backend' });
});

app.get('/api/restaurants', async (_request, response, next) => {
  try {
    const result = await pool.query(
      'SELECT id, name, location, type FROM restaurants ORDER BY name'
    );
    response.json(result.rows);
  } catch (error) {
    next(error);
  }
});

app.get('/api/menu/:restaurantId', async (request, response, next) => {
  try {
    const result = await pool.query(
      `SELECT id, restaurant_id AS "restaurantId", name, description,
              price_thb AS price, image_url AS image, calories AS kcal,
              carbs_g AS carbs, protein_g AS protein, fat_g AS fat
       FROM menu_items
       WHERE restaurant_id = $1
       ORDER BY name`,
      [request.params.restaurantId]
    );
    response.json(result.rows);
  } catch (error) {
    next(error);
  }
});

app.get('/api/menu/item/:id', async (request, response, next) => {
  try {
    const result = await pool.query(
      `SELECT id, restaurant_id AS "restaurantId", name, description,
              price_thb AS price, image_url AS image, calories AS kcal,
              carbs_g AS carbs, protein_g AS protein, fat_g AS fat
       FROM menu_items
       WHERE id = $1`,
      [request.params.id]
    );

    if (result.rowCount === 0) {
      return response.status(404).json({ message: 'ไม่พบเมนูอาหาร' });
    }

    return response.json(result.rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.post('/api/auth/login', (request, response) => {
  const { email } = request.body;

  if (!email) {
    return response.status(400).json({ message: 'กรุณาระบุอีเมล' });
  }

  return response.json({ user: { email }, token: `demo-${Date.now()}` });
});

app.post('/api/auth/register', (request, response) => {
  const { name, email } = request.body;

  if (!name || !email) {
    return response.status(400).json({ message: 'กรุณาระบุชื่อและอีเมล' });
  }

  return response.status(201).json({ user: { name, email }, token: `demo-${Date.now()}` });
});

async function start() {
  const schema = await fs.readFile(new URL('./schema.sql', import.meta.url), 'utf8');
  let lastError;

  for (let attempt = 1; attempt <= 20; attempt += 1) {
    try {
      await pool.query(schema);
      app.listen(port, () => {
        console.log(`Backend listening on port ${port}`);
      });
      return;
    } catch (error) {
      lastError = error;
      await new Promise((resolve) => setTimeout(resolve, 3000));
    }
  }

  throw lastError;
}

start().catch((error) => {
  console.error('Unable to initialize database', error);
  process.exit(1);
});
