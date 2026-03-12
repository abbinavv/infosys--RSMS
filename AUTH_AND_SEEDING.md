# MAISON LUXE RSMS — Authentication & Database Seeding Guide
**Version:** 2.0 | **Date:** March 12, 2026 | **Project:** infosys2 (iOS)

---

## ⚠️ CURRENT STATUS CHECK

| Component | Status | Detail |
|-----------|--------|--------|
| Supabase Project | ✅ Live | `ebodhqmtiyhouezpoibl.supabase.co` |
| Supabase SDK | ✅ Installed | `supabase-swift` via SPM in Xcode |
| `SupabaseConfig.swift` | ✅ Configured | URL + anon key set |
| `SupabaseManager.swift` | ✅ Ready | Singleton client initialized |
| `AuthService.swift` | ✅ Built | signIn / signUp / signOut / resetPassword / restoreSession |
| `AuthViewModel.swift` | ✅ Built | Login / SignUp / ForgotPassword — Supabase-powered |
| `AppState.swift` | ✅ Built | Role-based flow routing + session restore |
| Storage Bucket | ✅ Created | `product-images` (public) — images NOT yet uploaded |
| **Database Seeding** | ⏳ **CHECK** | Run `seed.sql` if tables are empty |
| **Supabase Auth Users** | ⏳ **CHECK** | Must create 8 Auth users in Dashboard |
| **UUID Sync** | ⏳ **CHECK** | Run `complete_setup.sql` Section 3 to auto-sync |
| **RLS Policies** | ⏳ **CHECK** | Run `complete_setup.sql` Section 4 for policies |

---

## 🚨 QUICK FIX CHECKLIST (If Auth Not Working)

**If login fails, work through these steps in order:**

### Step A: Check if database is seeded
```sql
-- Run this in Supabase SQL Editor:
SELECT 'users' AS tbl, COUNT(*) FROM users;
```
- If count = 0 → Run `seed.sql` first
- If count = 8 → Proceed to Step B

### Step B: Check if Auth users exist
Go to **Supabase Dashboard → Authentication → Users**
- If empty → Create 8 Auth users (see list in PART 2 below)
- If 8 users exist → Proceed to Step C

### Step C: Check UUID match
```sql
-- Run this to compare users table with auth.users:
SELECT 
  u.email, 
  u.id as profile_id,
  au.id as auth_id,
  CASE WHEN u.id = au.id THEN '✅ Match' ELSE '❌ MISMATCH' END as status
FROM users u
LEFT JOIN auth.users au ON u.email = au.email
ORDER BY u.email;
```
- If any show `❌ MISMATCH` → Run `update_user_uuids.sql` with correct UUIDs
- If all show `✅ Match` → Proceed to Step D

### Step D: Check RLS policies
```sql
-- Run this to see existing policies:
SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'users';
```
- If empty or missing "Users can read own profile" → Run `setup_auth.sql`

### Step E: Test login
Use these credentials:
```
Email:    admin@maisonluxe.in
Password: Admin@1234
```
Should route to Admin Dashboard.

---

## 📋 PART 1 — DATABASE SEEDING

### What needs to be seeded and why

The entire app depends on Supabase data. Without seeding:
- Login for any staff user will fail (no `users` row to fetch after auth)
- Product catalog will be empty
- Dashboards will show no data
- Inventory, stores, clients — all blank

### Step 1 — Run the SQL Seed File

The complete seed script is at `seed.sql` in the project root.

1. Open **Supabase Dashboard** → [app.supabase.com](https://app.supabase.com)
2. Select project **ebodhqmtiyhouezpoibl**
3. Click **SQL Editor** in the left sidebar
4. Click **"+ New Query"**
5. Copy the **entire contents** of `seed.sql` and paste it
6. Click **"Run"** (or Cmd+Enter)
7. You should see: `Success. No rows returned`

### What seed.sql inserts

| Table | Rows | Description |
|-------|------|-------------|
| `stores` | 4 | Mumbai, Delhi, Bangalore, Chennai boutiques |
| `categories` | 5 | Handbags, Watches, Jewellery, Accessories, Limited Edition |
| `tax_categories` | 4 | GST categories for India |
| `tax_rates` | 4 | GST 28%, 18%, 3% rates |
| `products` | 13 | Full luxury catalog with INR pricing |
| `inventory` | 22 | Stock distributed across all 4 stores |
| `users` | 8 | Staff profiles (placeholder UUIDs — must update after Step 3) |
| `clients` | 5 | Sample Indian VIP clients |

### Step 2 — Verify the Seed

After running the script, run these verification queries in the SQL Editor:

```sql
SELECT 'stores'        AS tbl, COUNT(*) FROM stores
UNION ALL
SELECT 'categories',          COUNT(*) FROM categories
UNION ALL
SELECT 'products',            COUNT(*) FROM products
UNION ALL
SELECT 'inventory',           COUNT(*) FROM inventory
UNION ALL
SELECT 'tax_categories',      COUNT(*) FROM tax_categories
UNION ALL
SELECT 'tax_rates',           COUNT(*) FROM tax_rates
UNION ALL
SELECT 'users',               COUNT(*) FROM users
UNION ALL
SELECT 'clients',             COUNT(*) FROM clients;
```

**Expected result:**

| tbl | count |
|-----|-------|
| stores | 4 |
| categories | 5 |
| products | 13 |
| inventory | 22 |
| tax_categories | 4 |
| tax_rates | 4 |
| users | 8 |
| clients | 5 |

---

## 📋 PART 2 — SUPABASE AUTH USER CREATION

> ⚠️ **Critical:** The `users` table profile rows (inserted by seed.sql) use **placeholder UUIDs**.  
> Supabase Auth requires that the `users.id` column matches the **real UUID** assigned by Supabase Auth.  
> You MUST create Auth users first, then update the `users` table with the real UUIDs.

### Step 3 — Create Auth Users in Supabase Dashboard

1. Go to **Supabase Dashboard → Authentication → Users**
2. Click **"Add User"** → **"Create new user"**
3. Enter email + password for each staff member below
4. **Do NOT tick "Auto Confirm User"** — leave email confirmation off for staff

Create these 8 users **in this exact order**:

| # | Full Name | Email | Password | Role |
|---|-----------|-------|----------|------|
| 1 | Arjun Sharma | `admin@maisonluxe.in` | `Admin@1234` | corporate_admin |
| 2 | Priya Nair | `manager.mumbai@maisonluxe.in` | `Manager@1234` | boutique_manager |
| 3 | Rohan Kapoor | `manager.delhi@maisonluxe.in` | `Manager@1234` | boutique_manager |
| 4 | Ananya Iyer | `sales1.mumbai@maisonluxe.in` | `Sales@1234` | sales_associate |
| 5 | Karan Mehta | `sales1.delhi@maisonluxe.in` | `Sales@1234` | sales_associate |
| 6 | Deepak Verma | `inventory.mumbai@maisonluxe.in` | `Inventory@1234` | inventory_controller |
| 7 | Sneha Pillai | `inventory.delhi@maisonluxe.in` | `Inventory@1234` | inventory_controller |
| 8 | Vikram Bose | `service.mumbai@maisonluxe.in` | `Service@1234` | service_technician |

> After creating each user, Supabase assigns a real UUID (e.g. `a7f3c2b1-...`).  
> You will see it in the Users table in the Auth dashboard.

### Step 4 — Update users Table with Real Auth UUIDs

After creating all 8 Auth users, run this update script in the SQL Editor.  
Replace the placeholder UUID values with the real ones from your Auth dashboard:

```sql
-- ⚠️ Replace each 'REAL-AUTH-UUID-HERE' with the actual UUID from Auth → Users

-- 1. Arjun Sharma (Corporate Admin)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'admin@maisonluxe.in';

-- 2. Priya Nair (Manager Mumbai)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'manager.mumbai@maisonluxe.in';

-- 3. Rohan Kapoor (Manager Delhi)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'manager.delhi@maisonluxe.in';

-- 4. Ananya Iyer (Sales Mumbai)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'sales1.mumbai@maisonluxe.in';

-- 5. Karan Mehta (Sales Delhi)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'sales1.delhi@maisonluxe.in';

-- 6. Deepak Verma (Inventory Mumbai)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'inventory.mumbai@maisonluxe.in';

-- 7. Sneha Pillai (Inventory Delhi)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'inventory.delhi@maisonluxe.in';

-- 8. Vikram Bose (Service Mumbai)
UPDATE users SET id = 'REAL-AUTH-UUID-HERE'
WHERE email = 'service.mumbai@maisonluxe.in';
```

### Step 5 — Test a Login

Once seeding + Auth users are done, test login in the app:

```
Email:    admin@maisonluxe.in
Password: Admin@1234
→ Should route to: Admin Dashboard (Enterprise Console)
```

If you see an error, check:
- The UUID in `users` table matches the Auth user UUID exactly
- The `is_active` flag is `true` in the `users` table
- RLS policies allow reading the `users` row (see Part 3)

---

## 📋 PART 3 — ROW LEVEL SECURITY (RLS)

RLS is enabled on all tables. Currently using the **anon key**, which means we need permissive read policies for the app to function.

Run this in the SQL Editor to enable proper RLS policies:

```sql
-- Allow authenticated users to read their own profile
CREATE POLICY "Users can read own profile"
ON users FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Allow authenticated users to read all products (catalog)
CREATE POLICY "Authenticated users read products"
ON products FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to read categories
CREATE POLICY "Authenticated users read categories"
ON categories FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to read stores
CREATE POLICY "Authenticated users read stores"
ON stores FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to read inventory
CREATE POLICY "Authenticated users read inventory"
ON inventory FOR SELECT
TO authenticated
USING (true);

-- Allow clients to read their own orders
CREATE POLICY "Users read own orders"
ON orders FOR SELECT
TO authenticated
USING (auth.uid()::text = client_id::text);

-- Allow staff to insert new users (for admin creating accounts)
CREATE POLICY "Corporate admin can insert users"
ON users FOR INSERT
TO authenticated
WITH CHECK (true);
```

---

## 🔐 PART 4 — COMPLETE AUTH FLOW (How it works in code)

### 4.1 App Launch → Session Restore

```
App launches
  → infosys2App.swift creates ModelContainer + AppState
  → RootView appears
  → .task { await appState.tryRestoreSession() }
  → AppState.tryRestoreSession()
      → AuthService.shared.restoreSession()
          → client.auth.session (checks for valid JWT in Keychain)
          → If valid: fetches users row by auth.uid()
          → Returns UserDTO
      → If UserDTO found: appState.login(profile: userDTO)
          → Routes to correct dashboard based on role
      → If no session: shows SplashScreen → Onboarding / Login
```

### 4.2 Staff Login Flow

```
LoginView
  → User enters email + password
  → Taps "Sign In"
  → AuthViewModel.login(appState:)
      → Validates fields (email not empty, password not empty)
      → AuthService.shared.signIn(email:password:)
          → client.auth.signIn(email:password:)   [Supabase Auth]
          → On success: session.user.id returned
          → Fetches users row: .eq("id", session.user.id)
          → Returns UserDTO
      → appState.login(profile: userDTO)
          → Stores: name, email, role, storeId, full profile
          → Routes based on role:
              .corporateAdmin      → AdminTabView
              .boutiqueManager     → ManagerTabView
              .inventoryController → ManagerTabView
              .salesAssociate      → SalesTabView
              .serviceTechnician   → SalesTabView
              .customer            → MainTabView
```

### 4.3 Customer Sign Up Flow

```
CustomerSignUpView
  → User enters: firstName, lastName, email, phone, password, confirmPassword
  → Taps "Create Account"
  → AuthViewModel.signUp(appState:)
      → Validates: all fields filled, passwords match, min 8 chars
      → AuthService.shared.signUp(firstName:lastName:email:phone:password:)
          → client.auth.signUp(email:password:)   [creates Auth account]
          → On success: authUser.id returned
          → Inserts users row:
              { id: authUser.id, role: "client", firstName, lastName, email, phone }
          → Returns UserDTO
      → appState.login(profile: userDTO)
          → Routes to MainTabView (customer shopping experience)
```

### 4.4 Forgot Password Flow

```
ForgotPasswordView
  → User enters email
  → Taps "Send Reset Link"
  → AuthViewModel.resetPassword()
      → AuthService.shared.resetPassword(email:)
          → client.auth.resetPasswordForEmail(email)
          → Supabase sends password reset email
      → showResetSuccess = true
      → UI shows "Check your email" confirmation
```

### 4.5 Sign Out Flow

```
Any Profile View → "Sign Out" button
  → AuthService.shared.signOut()
      → client.auth.signOut()   [invalidates JWT]
  → appState.logout()
      → Clears: isAuthenticated, name, email, role, storeId, profile
      → currentFlow = .authentication
      → LoginView appears
```

---

## 🏗️ PART 5 — FILE STRUCTURE

### Auth-Related Files

```
infosys2/
├── App/
│   ├── AppState.swift              ← Central state: currentFlow, login(), logout(), tryRestoreSession()
│   └── RootView.swift              ← Switches view based on AppFlow enum
│
├── Services/
│   └── Supabase/
│       ├── SupabaseConfig.swift    ← Project URL + anon key
│       ├── SupabaseManager.swift   ← Singleton SupabaseClient
│       ├── AuthService.swift       ← signIn / signUp / signOut / reset / restore
│       └── DTOs/
│           ├── UserDTO.swift       ← Matches public.users table exactly
│           ├── StoreDTO.swift      ← Matches public.stores
│           ├── ProductDTO.swift    ← Matches public.products
│           ├── CategoryDTO.swift   ← Matches public.categories
│           ├── InventoryDTO.swift  ← Matches public.inventory
│           ├── ClientDTO.swift     ← Matches public.clients
│           ├── OrderDTO.swift      ← Matches public.orders + order_items
│           ├── PaymentDTO.swift    ← Matches public.payments
│           ├── AppointmentDTO.swift← Matches public.appointments
│           ├── ServiceTicketDTO.swift ← Matches public.service_tickets
│           └── TaxDTO.swift        ← Matches public.tax_categories + tax_rates
│
└── Features/
    └── Auth/
        ├── Models/
        │   └── User.swift          ← Local SwiftData model + UserRole enum
        ├── ViewModels/
        │   └── AuthViewModel.swift ← @Observable: login / signUp / resetPassword
        └── Views/
            ├── LoginView.swift
            ├── CustomerSignUpView.swift
            └── ForgotPasswordView.swift
```

### Role → Navigation Routing

```
UserRole.corporateAdmin      → AppFlow.adminDashboard    → AdminTabView
UserRole.boutiqueManager     → AppFlow.managerDashboard  → ManagerTabView
UserRole.inventoryController → AppFlow.managerDashboard  → ManagerTabView
UserRole.salesAssociate      → AppFlow.salesDashboard    → SalesTabView
UserRole.serviceTechnician   → AppFlow.salesDashboard    → SalesTabView
UserRole.customer            → AppFlow.main              → MainTabView
```

---

## 📦 PART 6 — PRODUCT IMAGE SEEDING (Pending)

### Storage Bucket
- **Bucket name:** `product-images`
- **Visibility:** Public ✅
- **Status:** Created, no images uploaded yet

### Steps to add product images

1. Download product images from your Google Drive folder to Mac
2. Open Supabase Dashboard → Storage → `product-images`
3. Create subfolders: `handbags/`, `watches/`, `jewellery/`, `accessories/`, `limited-edition/`
4. Drag-and-drop images into each folder
5. Name images to match products (e.g. `handbags/classic-flap-bag.jpg`)
6. Each image's public URL will be:
   ```
   https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/handbags/classic-flap-bag.jpg
   ```
7. Run this SQL to update image URLs (replace filenames as appropriate):

```sql
-- Update product image URLs after uploading to Supabase Storage
-- Replace filenames to match what you uploaded

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/handbags/classic-flap-bag.jpg'
] WHERE sku = 'ML-HB-001';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/handbags/heritage-tote.jpg'
] WHERE sku = 'ML-HB-002';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/handbags/mini-crossbody.jpg'
] WHERE sku = 'ML-HB-003';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/watches/perpetual-chronograph.jpg'
] WHERE sku = 'ML-WT-001';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/watches/diamond-bezel-ladies.jpg'
] WHERE sku = 'ML-WT-002';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/watches/classic-dress-watch.jpg'
] WHERE sku = 'ML-WT-003';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/jewellery/solitaire-diamond-pendant.jpg'
] WHERE sku = 'ML-JW-001';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/jewellery/south-sea-pearl-earrings.jpg'
] WHERE sku = 'ML-JW-002';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/jewellery/rose-gold-diamond-bracelet.jpg'
] WHERE sku = 'ML-JW-003';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/accessories/silk-twill-scarf.jpg'
] WHERE sku = 'ML-AC-001';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/accessories/reversible-leather-belt.jpg'
] WHERE sku = 'ML-AC-002';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/limited-edition/heritage-collection-bag.jpg'
] WHERE sku = 'ML-LE-001';

UPDATE products SET image_urls = ARRAY[
  'https://ebodhqmtiyhouezpoibl.supabase.co/storage/v1/object/public/product-images/limited-edition/artisan-enamel-timepiece.jpg'
] WHERE sku = 'ML-LE-002';
```

---

## ✅ PART 7 — COMPLETE SEEDING CHECKLIST

Work through this checklist top to bottom:

```
□ Step 1 — Run seed.sql in Supabase SQL Editor
□ Step 2 — Verify all 8 tables have correct row counts
□ Step 3 — Create 8 Auth users in Auth → Users → Add User
□ Step 4 — Update users table UUIDs with real Auth UUIDs
□ Step 5 — Test login: admin@maisonluxe.in / Admin@1234
□ Step 6 — Upload product images to Storage → product-images bucket
□ Step 7 — Run image URL update SQL
□ Step 8 — Run RLS policy SQL (Part 3 above)
□ Step 9 — Test all 6 role logins (see credentials below)
```

---

## 🔑 PART 8 — ALL TEST CREDENTIALS

Once seeding + Auth users are created:

### Staff Accounts

| Role | Email | Password | Routes To |
|------|-------|----------|-----------|
| Corporate Admin | `admin@maisonluxe.in` | `Admin@1234` | Admin Dashboard |
| Boutique Manager (Mumbai) | `manager.mumbai@maisonluxe.in` | `Manager@1234` | Manager Dashboard |
| Boutique Manager (Delhi) | `manager.delhi@maisonluxe.in` | `Manager@1234` | Manager Dashboard |
| Sales Associate (Mumbai) | `sales1.mumbai@maisonluxe.in` | `Sales@1234` | Sales Dashboard |
| Sales Associate (Delhi) | `sales1.delhi@maisonluxe.in` | `Sales@1234` | Sales Dashboard |
| Inventory Controller (Mumbai) | `inventory.mumbai@maisonluxe.in` | `Inventory@1234` | Manager Dashboard |
| Inventory Controller (Delhi) | `inventory.delhi@maisonluxe.in` | `Inventory@1234` | Manager Dashboard |
| Service Technician (Mumbai) | `service.mumbai@maisonluxe.in` | `Service@1234` | Sales Dashboard |

### Customer Accounts (self-registered via app sign up)
Customers register themselves through the app's Sign Up screen. No pre-seeded auth accounts needed.

---

## 🚀 PART 9 — NEXT STEPS AFTER SEEDING

Once seeding is complete and login works, the next sprint tasks are:

### Sprint 2 — Wire Data to Views

| Priority | Task | File(s) to modify |
|----------|------|-------------------|
| P0 | Wire product catalog from Supabase | `HomeView`, `ProductListView`, `ProductDetailView` |
| P0 | Wire categories from Supabase | `CategoriesView` |
| P1 | Wire admin dashboard KPIs from live data | `AdminDashboardView` |
| P1 | Wire manager dashboard from live store data | `ManagerDashboardView` |
| P1 | Wire inventory from Supabase | `ManagerInventoryView` |
| P2 | Wire client orders + wishlist | `WishlistView`, `OrdersListView` |
| P2 | Wire VIP appointments | `ManagerOperationsView` |
| P3 | After-sales tickets CRUD | `SalesTabView` screens |

### Sprint 2 — Service Layer to build

```
Services/
  ProductService.swift     ← fetch products, categories, search, filter
  InventoryService.swift   ← stock levels, reorder alerts
  OrderService.swift       ← create/read/update orders
  ClientService.swift      ← clienteling profiles
  AppointmentService.swift ← VIP bookings
  StoreService.swift       ← boutique config
```

### Known Pending Items

- [ ] **Product images** — upload to Storage + update image_urls in products table
- [ ] **Auth user UUIDs** — update users table after creating Auth accounts
- [ ] **RLS policies** — run policy SQL to allow authenticated reads
- [ ] **Email confirmations** — currently off; enable for production
- [ ] **Push notifications** — not yet implemented
- [ ] **RFID integration** — future sprint
- [ ] **POS / payment gateway** — future sprint (Razorpay for India)
- [ ] **Offline mode** — SwiftData acts as local cache; sync logic to build

---

## 🏛️ ARCHITECTURE SUMMARY

```
┌─────────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                     │
│                                                         │
│  RootView → AppFlow switch                              │
│    ├── SplashScreen                                     │
│    ├── OnboardingView                                   │
│    ├── LoginView / SignUpView / ForgotPasswordView      │
│    ├── MainTabView          (Customer)                  │
│    ├── AdminTabView         (Corporate Admin)           │
│    ├── ManagerTabView       (Manager + Inventory)       │
│    └── SalesTabView         (Sales + Service)           │
│                                                         │
│  AppState (@Observable)                                 │
│    currentFlow / currentUserRole / currentUserProfile   │
│                                                         │
│  AuthService (Supabase)                                 │
│    signIn → auth.signIn() + fetch users row             │
│    signUp → auth.signUp() + insert users row            │
│    restoreSession → auth.session + fetch users row      │
│                                                         │
│  DTOs (11 structs matching Supabase columns exactly)    │
│    UserDTO / ProductDTO / StoreDTO / CategoryDTO /      │
│    InventoryDTO / ClientDTO / OrderDTO / PaymentDTO /   │
│    AppointmentDTO / ServiceTicketDTO / TaxDTO           │
└──────────────────┬──────────────────────────────────────┘
                   │ HTTPS + JWT (Supabase Swift SDK)
┌──────────────────▼──────────────────────────────────────┐
│              Supabase (ebodhqmtiyhouezpoibl)             │
│                                                         │
│  Auth  ──── users (profile rows)                        │
│  Storage ── product-images (public bucket)              │
│                                                         │
│  Tables: stores / categories / products / inventory /   │
│          clients / orders / order_items / payments /    │
│          appointments / service_tickets /               │
│          tax_categories / tax_rates                     │
│                                                         │
│  RLS: Enabled on all tables                             │
│  RPC: get_my_role() / get_my_store_id()                 │
└─────────────────────────────────────────────────────────┘
```

---

*Document generated: March 12, 2026 | Maison Luxe RSMS v2.0*
