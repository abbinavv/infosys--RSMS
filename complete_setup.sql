-- ============================================================
-- MAISON LUXE RSMS — COMPLETE DATABASE SETUP
-- Run this AFTER running seed.sql and creating Auth users
--
-- NOTE: tax_rates.rate uses NUMERIC(5,4) — values stored as
-- decimals (0.28 = 28%, 0.18 = 18%, 0.03 = 3%)
-- ============================================================

-- ─────────────────────────────────────────────
-- SECTION 1: VERIFY DATA EXISTS
-- ─────────────────────────────────────────────
-- Run this first to check if seeding was done:

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

-- ─────────────────────────────────────────────
-- SECTION 2: CHECK UUID MISMATCH
-- ─────────────────────────────────────────────
-- Run this to see if users table IDs match Auth users:

SELECT
    u.email,
    u.id as profile_uuid,
    au.id as auth_uuid,
    CASE
        WHEN u.id = au.id THEN '✅ MATCH'
        WHEN au.id IS NULL THEN '❌ NO AUTH USER'
        ELSE '❌ UUID MISMATCH'
    END as status
FROM users u
LEFT JOIN auth.users au ON LOWER(u.email) = LOWER(au.email)
ORDER BY u.email;

-- If any row shows "UUID MISMATCH" or "NO AUTH USER", you need to:
-- 1. Create the Auth user in Supabase Dashboard → Authentication → Users
-- 2. Run the UPDATE statement in Section 3 below

-- ─────────────────────────────────────────────
-- SECTION 3: FIX UUID MISMATCH (AUTO)
-- ─────────────────────────────────────────────
-- This automatically syncs user UUIDs from auth.users to public.users:

UPDATE users u
SET id = au.id
FROM auth.users au
WHERE LOWER(u.email) = LOWER(au.email)
  AND u.id != au.id;

-- Verify the fix worked:
SELECT
    u.email,
    u.id as profile_uuid,
    au.id as auth_uuid,
    CASE WHEN u.id = au.id THEN '✅ SYNCED' ELSE '❌ STILL MISMATCHED' END as status
FROM users u
LEFT JOIN auth.users au ON LOWER(u.email) = LOWER(au.email)
ORDER BY u.email;

-- ─────────────────────────────────────────────
-- SECTION 4: RLS POLICIES
-- ─────────────────────────────────────────────

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_rates ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first (to avoid conflicts)
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Authenticated users read products" ON products;
DROP POLICY IF EXISTS "Authenticated users read categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users read stores" ON stores;
DROP POLICY IF EXISTS "Authenticated users read inventory" ON inventory;
DROP POLICY IF EXISTS "Authenticated users read tax_categories" ON tax_categories;
DROP POLICY IF EXISTS "Authenticated users read tax_rates" ON tax_rates;
DROP POLICY IF EXISTS "Authenticated users read clients" ON clients;

-- USERS: Allow reading own profile
CREATE POLICY "Users can read own profile"
ON users FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- USERS: Allow inserting own profile (for customer sign up)
CREATE POLICY "Users can insert own profile"
ON users FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- PRODUCTS: Everyone authenticated can read
CREATE POLICY "Authenticated users read products"
ON products FOR SELECT
TO authenticated
USING (true);

-- CATEGORIES: Everyone authenticated can read
CREATE POLICY "Authenticated users read categories"
ON categories FOR SELECT
TO authenticated
USING (true);

-- STORES: Everyone authenticated can read
CREATE POLICY "Authenticated users read stores"
ON stores FOR SELECT
TO authenticated
USING (true);

-- INVENTORY: Everyone authenticated can read
CREATE POLICY "Authenticated users read inventory"
ON inventory FOR SELECT
TO authenticated
USING (true);

-- TAX_CATEGORIES: Everyone authenticated can read
CREATE POLICY "Authenticated users read tax_categories"
ON tax_categories FOR SELECT
TO authenticated
USING (true);

-- TAX_RATES: Everyone authenticated can read
CREATE POLICY "Authenticated users read tax_rates"
ON tax_rates FOR SELECT
TO authenticated
USING (true);

-- CLIENTS: Staff can read clients (associates can view their clients)
CREATE POLICY "Authenticated users read clients"
ON clients FOR SELECT
TO authenticated
USING (true);

-- ─────────────────────────────────────────────
-- SECTION 5: VERIFY POLICIES
-- ─────────────────────────────────────────────

SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ─────────────────────────────────────────────
-- SECTION 6: TEST LOGIN QUERY
-- ─────────────────────────────────────────────
-- Simulates what the app does after auth.signIn():
-- (Replace the UUID with a real auth.users.id to test)

-- SELECT * FROM users WHERE id = 'YOUR-AUTH-USER-UUID-HERE';

-- ─────────────────────────────────────────────
-- DONE!
-- ─────────────────────────────────────────────
-- Test credentials:
-- admin@maisonluxe.in / Admin@1234 → Admin Dashboard
-- manager.mumbai@maisonluxe.in / Manager@1234 → Manager Dashboard
-- sales1.mumbai@maisonluxe.in / Sales@1234 → Sales Dashboard
