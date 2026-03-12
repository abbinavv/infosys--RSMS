-- ============================================================
-- MAISON LUXE RSMS — AUTH & RLS SETUP
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- Run this AFTER creating Auth users in Authentication → Users
-- ============================================================

-- ─────────────────────────────────────────────
-- STEP 1: Enable RLS on all tables (if not already)
-- ─────────────────────────────────────────────
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_rates ENABLE ROW LEVEL SECURITY;

-- ─────────────────────────────────────────────
-- STEP 2: Drop existing policies (to avoid conflicts)
-- ─────────────────────────────────────────────
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Authenticated users read products" ON products;
DROP POLICY IF EXISTS "Authenticated users read categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users read stores" ON stores;
DROP POLICY IF EXISTS "Authenticated users read inventory" ON inventory;
DROP POLICY IF EXISTS "Authenticated users read tax_categories" ON tax_categories;
DROP POLICY IF EXISTS "Authenticated users read tax_rates" ON tax_rates;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Staff can read all users" ON users;

-- ─────────────────────────────────────────────
-- STEP 3: Create RLS Policies
-- ─────────────────────────────────────────────

-- USERS TABLE - Allow authenticated users to read their own profile
CREATE POLICY "Users can read own profile"
ON users FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- USERS TABLE - Allow inserting own profile (for signup)
CREATE POLICY "Users can insert own profile"
ON users FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- USERS TABLE - Staff with admin/manager role can read all users
CREATE POLICY "Staff can read all users"
ON users FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users u 
    WHERE u.id = auth.uid() 
    AND u.role IN ('corporate_admin', 'boutique_manager')
  )
);

-- PRODUCTS - Public catalog read for authenticated users
CREATE POLICY "Authenticated users read products"
ON products FOR SELECT
TO authenticated
USING (true);

-- CATEGORIES - Public catalog read for authenticated users
CREATE POLICY "Authenticated users read categories"
ON categories FOR SELECT
TO authenticated
USING (true);

-- STORES - Authenticated users can read stores
CREATE POLICY "Authenticated users read stores"
ON stores FOR SELECT
TO authenticated
USING (true);

-- INVENTORY - Authenticated users can read inventory
CREATE POLICY "Authenticated users read inventory"
ON inventory FOR SELECT
TO authenticated
USING (true);

-- TAX CATEGORIES - Authenticated users can read
CREATE POLICY "Authenticated users read tax_categories"
ON tax_categories FOR SELECT
TO authenticated
USING (true);

-- TAX RATES - Authenticated users can read
CREATE POLICY "Authenticated users read tax_rates"
ON tax_rates FOR SELECT
TO authenticated
USING (true);

-- ─────────────────────────────────────────────
-- STEP 4: Verify policies were created
-- ─────────────────────────────────────────────
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
