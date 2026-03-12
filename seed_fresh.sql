-- ============================================================
-- MAISON LUXE RSMS — FRESH SEED (Clean + Insert)
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- This will DELETE existing data and insert fresh seed data
-- ============================================================

-- ─────────────────────────────────────────────
-- STEP 1: CLEAN UP EXISTING PARTIAL DATA
-- ─────────────────────────────────────────────
DELETE FROM clients;
DELETE FROM inventory;
DELETE FROM products;
DELETE FROM tax_rates;
DELETE FROM tax_categories;
DELETE FROM categories;
DELETE FROM users;
DELETE FROM stores;

-- ─────────────────────────────────────────────
-- STEP 2: STORES (4 Indian boutiques)
-- ─────────────────────────────────────────────
INSERT INTO stores (id, name, country, city, address, currency, timezone, is_active) VALUES
  ('a1000000-0000-4000-8000-000000000001', 'Maison Luxe Mumbai Flagship',  'IN', 'Mumbai',    'Jio World Drive, BKC, Bandra East, Mumbai 400051',                     'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000002', 'Maison Luxe Delhi Boutique',   'IN', 'New Delhi', 'DLF Emporio, Nelson Mandela Marg, Vasant Kunj, New Delhi 110070',      'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000003', 'Maison Luxe Bangalore',        'IN', 'Bangalore', 'UB City Mall, Vittal Mallya Road, Bangalore 560001',                   'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000004', 'Maison Luxe Chennai',          'IN', 'Chennai',   'Express Avenue Mall, Whites Road, Royapettah, Chennai 600014',         'INR', 'Asia/Kolkata', true);

-- ─────────────────────────────────────────────
-- STEP 3: CATEGORIES (5 luxury product categories)
-- ─────────────────────────────────────────────
INSERT INTO categories (id, parent_id, name, description, is_active) VALUES
  ('b1000000-0000-4000-8000-000000000001', NULL, 'Handbags',       'Exquisite leather handbags, clutches and satchels',              true),
  ('b1000000-0000-4000-8000-000000000002', NULL, 'Watches',        'Precision timepieces and luxury Swiss and Japanese watches',     true),
  ('b1000000-0000-4000-8000-000000000003', NULL, 'Jewellery',      'Fine jewellery in gold, platinum, diamonds and precious stones', true),
  ('b1000000-0000-4000-8000-000000000004', NULL, 'Accessories',    'Premium scarves, belts, sunglasses and lifestyle pieces',        true),
  ('b1000000-0000-4000-8000-000000000005', NULL, 'Limited Edition','Exclusive numbered limited edition collections',                 true);

-- ─────────────────────────────────────────────
-- STEP 4: TAX CATEGORIES
-- ─────────────────────────────────────────────
INSERT INTO tax_categories (id, name, description) VALUES
  ('d1000000-0000-4000-8000-000000000001', 'Luxury Goods',  'Standard luxury goods — GST 28%'),
  ('d1000000-0000-4000-8000-000000000002', 'Jewellery',     'Gold & precious metal jewellery — GST 3%'),
  ('d1000000-0000-4000-8000-000000000003', 'Watches',       'Wristwatches — GST 18%'),
  ('d1000000-0000-4000-8000-000000000004', 'Accessories',   'Leather goods & accessories — GST 18%');

-- ─────────────────────────────────────────────
-- STEP 5: TAX RATES (rate as decimal: 0.28 = 28%)
-- ─────────────────────────────────────────────
INSERT INTO tax_rates (tax_category_id, country, rate, label, is_active) VALUES
  ('d1000000-0000-4000-8000-000000000001', 'IN', 0.28, 'GST 28% — Luxury Goods',    true),
  ('d1000000-0000-4000-8000-000000000002', 'IN', 0.03, 'GST 3% — Gold Jewellery',   true),
  ('d1000000-0000-4000-8000-000000000003', 'IN', 0.18, 'GST 18% — Watches',         true),
  ('d1000000-0000-4000-8000-000000000004', 'IN', 0.18, 'GST 18% — Accessories',     true);

-- ─────────────────────────────────────────────
-- STEP 6: PRODUCTS (13 products)
-- ─────────────────────────────────────────────
INSERT INTO products (id, sku, barcode, name, brand, category_id, tax_category_id, description, price, cost_price, image_urls, is_active) VALUES
  ('c1000000-0000-4000-8000-000000000001', 'ML-HB-001', '8901234560001', 'Classic Flap Bag', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Timeless quilted lambskin leather bag with signature 24k gold-plated chain strap.', 485000, 180000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000002', 'ML-HB-002', '8901234560002', 'Heritage Leather Tote', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Spacious full-grain calfskin leather tote with suede interior lining.', 320000, 110000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000003', 'ML-HB-003', '8901234560003', 'Mini Crossbody', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Compact evening crossbody in soft nappa lambskin.', 245000, 85000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000004', 'ML-WT-001', '8901234560004', 'Perpetual Chronograph', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Automatic chronograph, 18k rose gold case 42mm, Swiss made.', 1250000, 480000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000005', 'ML-WT-002', '8901234560005', 'Diamond Bezel Ladies Watch', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Ladies quartz watch with diamond bezel, mother-of-pearl dial.', 890000, 320000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000006', 'ML-WT-003', '8901234560006', 'Classic Dress Watch', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Ultra-slim automatic dress watch, 18k yellow gold case.', 650000, 240000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000007', 'ML-JW-001', '8901234560007', 'Solitaire Diamond Pendant', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', 'GIA-certified 1.5ct diamond solitaire in 18k white gold.', 1580000, 900000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000008', 'ML-JW-002', '8901234560008', 'South Sea Pearl Drop Earrings', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', 'South Sea pearls with diamond accent drops, 18k white gold.', 420000, 180000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000009', 'ML-JW-003', '8901234560009', 'Rose Gold Diamond Bracelet', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', 'Woven 18k rose gold bracelet with pavé diamond clasp.', 750000, 380000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000010', 'ML-AC-001', '8901234560010', 'Silk Twill Scarf', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000004', 'Hand-rolled 90x90cm silk twill scarf, original artwork print.', 89000, 22000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000011', 'ML-AC-002', '8901234560011', 'Reversible Leather Belt', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000004', 'Reversible calfskin belt with signature monogram buckle.', 65000, 18000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000012', 'ML-LE-001', '8901234560012', 'Heritage Collection Bag No. 47/100', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000001', 'Numbered limited edition bag, hand-painted Mughal motif.', 1850000, 600000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000013', 'ML-LE-002', '8901234560013', 'Artisan Enamel Timepiece No. 7/25', 'Maison Luxe', 'b1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000003', 'Hand-engraved platinum with grand feu enamel dial.', 4500000, 1800000, ARRAY[]::text[], true);

-- ─────────────────────────────────────────────
-- STEP 7: INVENTORY
-- ─────────────────────────────────────────────
INSERT INTO inventory (store_id, product_id, quantity, reorder_point) VALUES
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000001', 4, 2),
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000002', 6, 3),
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000004', 3, 1),
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000007', 2, 1),
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000010',15, 5),
  ('a1000000-0000-4000-8000-000000000001','c1000000-0000-4000-8000-000000000012', 1, 0),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000001', 5, 2),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000003', 8, 3),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000005', 3, 1),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000008', 4, 2),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000011',20, 8),
  ('a1000000-0000-4000-8000-000000000002','c1000000-0000-4000-8000-000000000013', 1, 0),
  ('a1000000-0000-4000-8000-000000000003','c1000000-0000-4000-8000-000000000002', 4, 2),
  ('a1000000-0000-4000-8000-000000000003','c1000000-0000-4000-8000-000000000003', 6, 3),
  ('a1000000-0000-4000-8000-000000000003','c1000000-0000-4000-8000-000000000006', 5, 2),
  ('a1000000-0000-4000-8000-000000000003','c1000000-0000-4000-8000-000000000009', 3, 1),
  ('a1000000-0000-4000-8000-000000000003','c1000000-0000-4000-8000-000000000010',12, 5),
  ('a1000000-0000-4000-8000-000000000004','c1000000-0000-4000-8000-000000000001', 3, 2),
  ('a1000000-0000-4000-8000-000000000004','c1000000-0000-4000-8000-000000000004', 2, 1),
  ('a1000000-0000-4000-8000-000000000004','c1000000-0000-4000-8000-000000000007', 3, 1),
  ('a1000000-0000-4000-8000-000000000004','c1000000-0000-4000-8000-000000000008', 5, 2),
  ('a1000000-0000-4000-8000-000000000004','c1000000-0000-4000-8000-000000000011',10, 4);

-- ─────────────────────────────────────────────
-- STEP 8: USERS (placeholder IDs — will update after creating Auth users)
-- ─────────────────────────────────────────────
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active) VALUES
  ('00000000-0000-4000-8000-000000000001', 'corporate_admin',      NULL,                                      'Arjun', 'Sharma', 'admin@maisonluxe.in', '+91-98100-00001', true),
  ('00000000-0000-4000-8000-000000000002', 'boutique_manager',     'a1000000-0000-4000-8000-000000000001',     'Priya', 'Nair', 'manager.mumbai@maisonluxe.in', '+91-98200-00002', true),
  ('00000000-0000-4000-8000-000000000003', 'boutique_manager',     'a1000000-0000-4000-8000-000000000002',     'Rohan', 'Kapoor', 'manager.delhi@maisonluxe.in', '+91-98200-00003', true),
  ('00000000-0000-4000-8000-000000000004', 'sales_associate',      'a1000000-0000-4000-8000-000000000001',     'Ananya', 'Iyer', 'sales1.mumbai@maisonluxe.in', '+91-98300-00004', true),
  ('00000000-0000-4000-8000-000000000005', 'sales_associate',      'a1000000-0000-4000-8000-000000000002',     'Karan', 'Mehta', 'sales1.delhi@maisonluxe.in', '+91-98300-00005', true),
  ('00000000-0000-4000-8000-000000000006', 'inventory_controller', 'a1000000-0000-4000-8000-000000000001',     'Deepak', 'Verma', 'inventory.mumbai@maisonluxe.in', '+91-98400-00006', true),
  ('00000000-0000-4000-8000-000000000007', 'inventory_controller', 'a1000000-0000-4000-8000-000000000002',     'Sneha', 'Pillai', 'inventory.delhi@maisonluxe.in', '+91-98400-00007', true),
  ('00000000-0000-4000-8000-000000000008', 'service_technician',   'a1000000-0000-4000-8000-000000000001',     'Vikram', 'Bose', 'service.mumbai@maisonluxe.in', '+91-98500-00008', true);

-- ─────────────────────────────────────────────
-- STEP 9: SAMPLE CLIENTS
-- ─────────────────────────────────────────────
INSERT INTO clients (id, first_name, last_name, email, phone, nationality, preferred_language, city, state, country, segment, gdpr_consent, marketing_opt_in, created_by, is_active) VALUES
  ('e1000000-0000-4000-8000-000000000001', 'Aisha',    'Khan',     'aisha.khan@email.com',     '+91-98600-00001', 'IN', 'en', 'Mumbai',    'Maharashtra', 'IN', 'platinum', true, true,  '00000000-0000-4000-8000-000000000004', true),
  ('e1000000-0000-4000-8000-000000000002', 'Rahul',    'Singhania','rahul.s@email.com',        '+91-98600-00002', 'IN', 'en', 'New Delhi', 'Delhi',       'IN', 'gold',     true, true,  '00000000-0000-4000-8000-000000000005', true),
  ('e1000000-0000-4000-8000-000000000003', 'Meera',    'Reddy',    'meera.reddy@email.com',    '+91-98600-00003', 'IN', 'en', 'Bangalore', 'Karnataka',   'IN', 'standard', true, false, '00000000-0000-4000-8000-000000000004', true),
  ('e1000000-0000-4000-8000-000000000004', 'Siddharth','Malhotra', 'sid.malhotra@email.com',   '+91-98600-00004', 'IN', 'en', 'Mumbai',    'Maharashtra', 'IN', 'prive',    true, true,  '00000000-0000-4000-8000-000000000004', true),
  ('e1000000-0000-4000-8000-000000000005', 'Pooja',    'Agarwal',  'pooja.agarwal@email.com',  '+91-98600-00005', 'IN', 'en', 'Chennai',   'Tamil Nadu',  'IN', 'gold',     true, true,  '00000000-0000-4000-8000-000000000005', true);

-- ─────────────────────────────────────────────
-- VERIFY COUNTS
-- ─────────────────────────────────────────────
SELECT 'stores' AS table_name, COUNT(*) as row_count FROM stores
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'tax_categories', COUNT(*) FROM tax_categories
UNION ALL SELECT 'tax_rates', COUNT(*) FROM tax_rates
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'clients', COUNT(*) FROM clients;

-- Expected: stores=4, categories=5, products=13, inventory=22, 
--           tax_categories=4, tax_rates=4, users=8, clients=5
