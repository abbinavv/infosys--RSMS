-- ============================================================
-- MAISON LUXE RSMS — COMPLETE FIX (v4)
-- Run in: Supabase Dashboard → SQL Editor → New Query → Run
-- ============================================================


-- ─────────────────────────────────────────────
-- STEP 0: FIX ROLE CONSTRAINT
-- ─────────────────────────────────────────────
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE users ADD CONSTRAINT users_role_check CHECK (
  role IN ('corporate_admin','boutique_manager','sales_associate',
           'inventory_controller','service_technician','client')
);


-- ─────────────────────────────────────────────
-- STEP 1: DROP ALL BROKEN RLS POLICIES
-- ─────────────────────────────────────────────
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Staff can read all users" ON users;
DROP POLICY IF EXISTS "Allow all authenticated users to read users" ON users;
DROP POLICY IF EXISTS "Corporate admin can insert users" ON users;
DROP POLICY IF EXISTS "Authenticated users read products" ON products;
DROP POLICY IF EXISTS "Authenticated users read categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users read stores" ON stores;
DROP POLICY IF EXISTS "Authenticated users read inventory" ON inventory;
DROP POLICY IF EXISTS "Authenticated users read tax_categories" ON tax_categories;
DROP POLICY IF EXISTS "Authenticated users read tax_rates" ON tax_rates;
DROP POLICY IF EXISTS "Authenticated users read clients" ON clients;


-- ─────────────────────────────────────────────
-- STEP 2: DISABLE RLS FOR SEEDING
-- ─────────────────────────────────────────────
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE stores DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE tax_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE tax_rates DISABLE ROW LEVEL SECURITY;


-- ─────────────────────────────────────────────
-- STEP 3: DELETE EXISTING SEED DATA (clean slate)
-- ─────────────────────────────────────────────
DELETE FROM inventory;
DELETE FROM products;
DELETE FROM tax_rates;
DELETE FROM tax_categories;
DELETE FROM categories;
DELETE FROM users;
DELETE FROM stores;


-- ─────────────────────────────────────────────
-- STEP 4: SEED STORES
-- ─────────────────────────────────────────────
INSERT INTO stores (id, name, country, city, address, currency, timezone, is_active) VALUES
  ('a1000000-0000-4000-8000-000000000001', 'Maison Luxe Mumbai Flagship',  'IN', 'Mumbai',    'Jio World Drive, BKC, Bandra East, Mumbai 400051',                'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000002', 'Maison Luxe Delhi Boutique',   'IN', 'New Delhi', 'DLF Emporio, Nelson Mandela Marg, Vasant Kunj, New Delhi 110070', 'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000003', 'Maison Luxe Bangalore',        'IN', 'Bangalore', 'UB City Mall, Vittal Mallya Road, Bangalore 560001',              'INR', 'Asia/Kolkata', true),
  ('a1000000-0000-4000-8000-000000000004', 'Maison Luxe Chennai',          'IN', 'Chennai',   'Express Avenue Mall, Whites Road, Royapettah, Chennai 600014',    'INR', 'Asia/Kolkata', true);


-- ─────────────────────────────────────────────
-- STEP 5: SEED CATEGORIES
-- ─────────────────────────────────────────────
INSERT INTO categories (id, parent_id, name, description, is_active) VALUES
  ('b1000000-0000-4000-8000-000000000001', NULL, 'Handbags',       'Exquisite leather handbags, clutches and satchels',              true),
  ('b1000000-0000-4000-8000-000000000002', NULL, 'Watches',        'Precision timepieces and luxury Swiss and Japanese watches',     true),
  ('b1000000-0000-4000-8000-000000000003', NULL, 'Jewellery',      'Fine jewellery in gold, platinum, diamonds and precious stones', true),
  ('b1000000-0000-4000-8000-000000000004', NULL, 'Accessories',    'Premium scarves, belts, sunglasses and lifestyle pieces',        true),
  ('b1000000-0000-4000-8000-000000000005', NULL, 'Limited Edition','Exclusive numbered limited edition collections',                 true);


-- ─────────────────────────────────────────────
-- STEP 6: SEED TAX
-- ─────────────────────────────────────────────
INSERT INTO tax_categories (id, name, description) VALUES
  ('d1000000-0000-4000-8000-000000000001', 'Luxury Goods',  'Standard luxury goods — GST 28%'),
  ('d1000000-0000-4000-8000-000000000002', 'Jewellery',     'Gold & precious metal jewellery — GST 3%'),
  ('d1000000-0000-4000-8000-000000000003', 'Watches',       'Wristwatches — GST 18%'),
  ('d1000000-0000-4000-8000-000000000004', 'Accessories',   'Leather goods & accessories — GST 18%');

INSERT INTO tax_rates (tax_category_id, country, rate, label, is_active) VALUES
  ('d1000000-0000-4000-8000-000000000001', 'IN', 0.28, 'GST 28%', true),
  ('d1000000-0000-4000-8000-000000000002', 'IN', 0.03, 'GST 3%',  true),
  ('d1000000-0000-4000-8000-000000000003', 'IN', 0.18, 'GST 18%', true),
  ('d1000000-0000-4000-8000-000000000004', 'IN', 0.18, 'GST 18%', true);


-- ─────────────────────────────────────────────
-- STEP 7: SEED PRODUCTS
-- ─────────────────────────────────────────────
INSERT INTO products (id, sku, barcode, name, brand, category_id, tax_category_id, description, price, cost_price, image_urls, is_active) VALUES
  ('c1000000-0000-4000-8000-000000000001', 'ML-HB-001', '8901234560001', 'Classic Flap Bag',             'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Timeless quilted lambskin leather bag with signature 24k gold-plated chain strap.', 485000, 180000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000002', 'ML-HB-002', '8901234560002', 'Heritage Leather Tote',        'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Spacious full-grain calfskin leather tote.', 320000, 110000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000003', 'ML-HB-003', '8901234560003', 'Mini Crossbody',               'Maison Luxe', 'b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000001', 'Compact evening crossbody in soft nappa lambskin.', 245000, 85000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000004', 'ML-WT-001', '8901234560004', 'Perpetual Chronograph',        'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Automatic chronograph, 18k rose gold case 42mm.', 1250000, 480000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000005', 'ML-WT-002', '8901234560005', 'Diamond Bezel Ladies Watch',   'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Ladies quartz watch with diamond bezel.', 890000, 320000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000006', 'ML-WT-003', '8901234560006', 'Classic Dress Watch',          'Maison Luxe', 'b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 'Ultra-slim automatic dress watch, 18k yellow gold.', 650000, 240000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000007', 'ML-JW-001', '8901234560007', 'Solitaire Diamond Pendant',    'Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', 'GIA-certified 1.5ct diamond pendant in 18k white gold.', 1580000, 900000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000008', 'ML-JW-002', '8901234560008', 'South Sea Pearl Drop Earrings','Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', '12-13mm South Sea pearls with diamond accent.', 420000, 180000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000009', 'ML-JW-003', '8901234560009', 'Rose Gold Diamond Bracelet',   'Maison Luxe', 'b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000002', '18k rose gold bracelet with pavé diamond clasp.', 750000, 380000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000010', 'ML-AC-001', '8901234560010', 'Silk Twill Scarf',             'Maison Luxe', 'b1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000004', 'Hand-rolled 90x90cm silk twill scarf.', 89000, 22000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000011', 'ML-AC-002', '8901234560011', 'Reversible Leather Belt',      'Maison Luxe', 'b1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000004', 'Reversible calfskin belt with brass buckle.', 65000, 18000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000012', 'ML-LE-001', '8901234560012', 'Heritage Collection Bag',      'Maison Luxe', 'b1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000001', 'Limited edition hand-painted Mughal motif leather bag.', 1850000, 600000, ARRAY[]::text[], true),
  ('c1000000-0000-4000-8000-000000000013', 'ML-LE-002', '8901234560013', 'Artisan Enamel Timepiece',     'Maison Luxe', 'b1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000003', 'Hand-engraved platinum case with enamel dial.', 4500000, 1800000, ARRAY[]::text[], true);


-- ─────────────────────────────────────────────
-- STEP 8: SEED INVENTORY
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
-- STEP 9: SEED USERS USING REAL AUTH UUIDs
-- users.id has a FK to auth.users.id, so we MUST use real UUIDs
-- This inserts ONLY for Auth users that exist
-- ─────────────────────────────────────────────

-- Admin
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'corporate_admin', NULL, 'Arjun', 'Sharma', 'admin@maisonluxe.in', '+91-98100-00001', true
FROM auth.users au WHERE LOWER(au.email) = 'admin@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Manager Mumbai
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'boutique_manager', 'a1000000-0000-4000-8000-000000000001', 'Priya', 'Nair', 'manager.mumbai@maisonluxe.in', '+91-98200-00002', true
FROM auth.users au WHERE LOWER(au.email) = 'manager.mumbai@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Manager Delhi
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'boutique_manager', 'a1000000-0000-4000-8000-000000000002', 'Rohan', 'Kapoor', 'manager.delhi@maisonluxe.in', '+91-98200-00003', true
FROM auth.users au WHERE LOWER(au.email) = 'manager.delhi@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Sales Mumbai
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'sales_associate', 'a1000000-0000-4000-8000-000000000001', 'Ananya', 'Iyer', 'sales1.mumbai@maisonluxe.in', '+91-98300-00004', true
FROM auth.users au WHERE LOWER(au.email) = 'sales1.mumbai@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Sales Delhi
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'sales_associate', 'a1000000-0000-4000-8000-000000000002', 'Karan', 'Mehta', 'sales1.delhi@maisonluxe.in', '+91-98300-00005', true
FROM auth.users au WHERE LOWER(au.email) = 'sales1.delhi@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Inventory Mumbai
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'inventory_controller', 'a1000000-0000-4000-8000-000000000001', 'Deepak', 'Verma', 'inventory.mumbai@maisonluxe.in', '+91-98400-00006', true
FROM auth.users au WHERE LOWER(au.email) = 'inventory.mumbai@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Inventory Delhi
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'inventory_controller', 'a1000000-0000-4000-8000-000000000002', 'Sneha', 'Pillai', 'inventory.delhi@maisonluxe.in', '+91-98400-00007', true
FROM auth.users au WHERE LOWER(au.email) = 'inventory.delhi@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;

-- Service Mumbai
INSERT INTO users (id, role, store_id, first_name, last_name, email, phone, is_active)
SELECT au.id, 'service_technician', 'a1000000-0000-4000-8000-000000000001', 'Vikram', 'Bose', 'service.mumbai@maisonluxe.in', '+91-98500-00008', true
FROM auth.users au WHERE LOWER(au.email) = 'service.mumbai@maisonluxe.in'
ON CONFLICT (id) DO NOTHING;


-- (Clients seeding skipped — not needed for auth)


-- ─────────────────────────────────────────────
-- STEP 10: ENABLE RLS + CREATE POLICIES
-- ─────────────────────────────────────────────
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_rates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
ON users FOR SELECT TO authenticated USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
ON users FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

CREATE POLICY "Authenticated users read products"
ON products FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read categories"
ON categories FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read stores"
ON stores FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read inventory"
ON inventory FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read tax_categories"
ON tax_categories FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read tax_rates"
ON tax_rates FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users read clients"
ON clients FOR SELECT TO authenticated USING (true);


-- ─────────────────────────────────────────────
-- STEP 11: CREATE get_my_profile() RPC
-- ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_my_profile()
RETURNS SETOF users
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _uid uuid := auth.uid();
  _profile users%ROWTYPE;
BEGIN
  SELECT * INTO _profile FROM users WHERE id = _uid;
  IF FOUND THEN
    RETURN NEXT _profile;
  END IF;
  RETURN;
END;
$$;

GRANT EXECUTE ON FUNCTION get_my_profile() TO authenticated;


-- ─────────────────────────────────────────────
-- STEP 12: VERIFY
-- ─────────────────────────────────────────────
SELECT 'users' AS tbl, COUNT(*) FROM users
UNION ALL SELECT 'stores', COUNT(*) FROM stores
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory;

SELECT email, role, first_name || ' ' || last_name as name FROM users ORDER BY email;
