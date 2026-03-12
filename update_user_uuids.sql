-- ============================================================
-- MAISON LUXE RSMS — UPDATE USER UUIDs
-- Run this AFTER creating Auth users in Supabase Dashboard
-- Replace the placeholder UUIDs with real Auth user UUIDs
-- ============================================================

-- IMPORTANT: Go to Supabase Dashboard → Authentication → Users
-- Copy each user's UUID and paste it below

-- ─────────────────────────────────────────────
-- UPDATE TEMPLATE (Replace UUIDs after creating Auth users)
-- ─────────────────────────────────────────────

-- 1. Arjun Sharma - Corporate Admin
-- Email: admin@maisonluxe.in | Password: Admin@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'admin@maisonluxe.in';

-- 2. Priya Nair - Boutique Manager Mumbai
-- Email: manager.mumbai@maisonluxe.in | Password: Manager@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'manager.mumbai@maisonluxe.in';

-- 3. Rohan Kapoor - Boutique Manager Delhi
-- Email: manager.delhi@maisonluxe.in | Password: Manager@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'manager.delhi@maisonluxe.in';

-- 4. Ananya Iyer - Sales Associate Mumbai
-- Email: sales1.mumbai@maisonluxe.in | Password: Sales@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'sales1.mumbai@maisonluxe.in';

-- 5. Karan Mehta - Sales Associate Delhi
-- Email: sales1.delhi@maisonluxe.in | Password: Sales@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'sales1.delhi@maisonluxe.in';

-- 6. Deepak Verma - Inventory Controller Mumbai
-- Email: inventory.mumbai@maisonluxe.in | Password: Inventory@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'inventory.mumbai@maisonluxe.in';

-- 7. Sneha Pillai - Inventory Controller Delhi
-- Email: inventory.delhi@maisonluxe.in | Password: Inventory@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'inventory.delhi@maisonluxe.in';

-- 8. Vikram Bose - Service Technician Mumbai
-- Email: service.mumbai@maisonluxe.in | Password: Service@1234
UPDATE users 
SET id = 'PASTE-REAL-UUID-HERE'  -- Replace this!
WHERE email = 'service.mumbai@maisonluxe.in';

-- ─────────────────────────────────────────────
-- VERIFY: Check that UUIDs were updated
-- ─────────────────────────────────────────────
SELECT id, email, first_name, last_name, role 
FROM users 
ORDER BY role, email;
