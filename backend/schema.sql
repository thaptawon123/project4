CREATE TABLE IF NOT EXISTS restaurants (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    type TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS menu_items (
    id TEXT PRIMARY KEY,
    restaurant_id TEXT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    price_thb NUMERIC(10, 2) NOT NULL,
    image_url TEXT NOT NULL,
    calories INTEGER NOT NULL,
    carbs_g NUMERIC(10, 2) NOT NULL DEFAULT 0,
    protein_g NUMERIC(10, 2) NOT NULL DEFAULT 0,
    fat_g NUMERIC(10, 2) NOT NULL DEFAULT 0
);

INSERT INTO restaurants (id, name, location, type) VALUES
    ('pra-daeng', 'ร้านกะเพราป้าแดง', 'โรงอาหารกลาง', 'อาหารตามสั่ง'),
    ('green-bowl', 'Green Bowl Salad', 'ตึกวิทยาศาสตร์', 'อาหารเพื่อสุขภาพ'),
    ('noodle-boat', 'เตี๋ยวเรือรสเด็ด', 'อาคารเรียนรวม', 'ก๋วยเตี๋ยว'),
    ('caffeine-lab', 'Caffeine Lab', 'ห้องสมุด', 'เครื่องดื่ม / คาเฟ่')
ON CONFLICT (id) DO NOTHING;

INSERT INTO menu_items (id, restaurant_id, name, description, price_thb, image_url, calories, carbs_g, protein_g, fat_g) VALUES
    ('krapow-gai-khai-dao', 'pra-daeng', 'ข้าวกะเพราไก่ไข่ดาว', 'ข้าวกะเพราไก่รสจัดจ้าน เสิร์ฟพร้อมไข่ดาว', 50, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800', 520, 65, 28, 14),
    ('omelet-pork', 'pra-daeng', 'ข้าวไข่เจียวหมูสับ', 'ไข่เจียวหมูสับเสิร์ฟพร้อมข้าวหอมมะลิ', 45, 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800', 480, 52, 22, 20),
    ('tom-yum-goong', 'pra-daeng', 'ต้มยำกุ้ง', 'ต้มยำกุ้งรสเปรี้ยวเผ็ดแบบไทย', 60, 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', 280, 18, 25, 12),
    ('khao-pad-moo', 'pra-daeng', 'ข้าวผัดหมู', 'ข้าวผัดหมูพร้อมผักสด', 50, 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800', 560, 78, 24, 18),
    ('green-bowl-salad', 'green-bowl', 'สลัดผักกรีนโบวล์', 'ผักสดหลากชนิดพร้อมน้ำสลัดสูตรเบา', 65, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', 240, 24, 10, 12),
    ('quinoa-bowl', 'green-bowl', 'ควินัวโบวล์', 'ควินัวและผักย่างพร้อมโปรตีน', 85, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800', 390, 48, 18, 14),
    ('fruit-salad', 'green-bowl', 'สลัดผลไม้', 'ผลไม้สดตามฤดูกาล', 45, 'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=800', 180, 42, 3, 1),
    ('boat-noodle', 'noodle-boat', 'ก๋วยเตี๋ยวเรือ', 'ก๋วยเตี๋ยวเรือน้ำตกพร้อมลูกชิ้นและเนื้อ', 50, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800', 410, 55, 24, 12),
    ('yen-ta-fo', 'noodle-boat', 'เย็นตาโฟ', 'เส้นพร้อมเครื่องเย็นตาโฟและซอสแดง', 55, 'https://images.unsplash.com/photo-1557872943-16a5ac26437e?w=800', 380, 58, 18, 9),
    ('tom-yum-noodle', 'noodle-boat', 'บะหมี่ต้มยำ', 'บะหมี่ต้มยำรสเข้มข้น', 50, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800', 430, 60, 20, 14),
    ('iced-latte', 'caffeine-lab', 'ลาเต้เย็น', 'กาแฟนมเย็นหอมละมุน', 55, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800', 160, 18, 6, 7),
    ('matcha-latte', 'caffeine-lab', 'มัทฉะลาเต้', 'มัทฉะนมเย็นรสนุ่ม', 60, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=800', 210, 28, 8, 7),
    ('cold-brew', 'caffeine-lab', 'โคลด์บรูว์', 'กาแฟสกัดเย็นไม่เติมน้ำตาล', 50, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=800', 15, 3, 1, 0)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price_thb = EXCLUDED.price_thb,
    image_url = EXCLUDED.image_url,
    calories = EXCLUDED.calories,
    carbs_g = EXCLUDED.carbs_g,
    protein_g = EXCLUDED.protein_g,
    fat_g = EXCLUDED.fat_g;
