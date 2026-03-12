# Supabase Integration — Status, Flow Verification & Next Steps

## Maison Luxe RSMS — Database Integration Audit

**Date:** March 12, 2026
**Supabase Project:** `ebodhqmtiyhouezpoibl.supabase.co`
**Status:** ⚠️ SDK Installed, Client Configured — **NOT YET WIRED TO ANY FEATURE**

---

## 1. Current State Summary

### What EXISTS

| Component | Status | Detail |
|-----------|--------|--------|
| Supabase Swift SDK | ✅ Installed | Package added to Xcode project |
| `SupabaseConfig.swift` | ✅ Configured | URL + anon key set |
| `SupabaseManager.swift` | ✅ Created | Singleton `SupabaseClient` instance |
| 13 Supabase tables | ✅ Created | Schema live on Supabase |
| 2 RPC functions | ✅ Created | `get_my_role`, `get_my_store_id` |

### What DOES NOT EXIST

| Component | Status | Detail |
|-----------|--------|--------|
| Auth via Supabase | ❌ None | Login uses local SwiftData lookup |
| Product fetch from Supabase | ❌ None | Products read from local `@Query` |
| Any API call to Supabase | ❌ None | Zero views/viewmodels import or call `SupabaseManager` |
| DTO structs for Supabase | ❌ None | No `Codable` structs matching Supabase column names |
| Supabase tables seeded | ❌ Empty | All 13 tables return `[]` |

### Conclusion

**The Supabase database is created but the app doesn't use it at all.** Every feature runs on local SwiftData with seeded mock data. The SDK is installed but no code calls it.

---

## 2. File-by-File Flow Verification

### 2.1 Authentication Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `AuthViewModel.swift` → `login()` | Local SwiftData `FetchDescriptor<User>` | ❌ No |
| `AuthViewModel.swift` → `signUp()` | Local SwiftData `modelContext.insert(User)` | ❌ No |
| `AuthViewModel.swift` → `resetPassword()` | Simulated delay, no actual reset | ❌ No |
| `SeedData.swift` → `seedUsersIfNeeded()` | Inserts users into local SwiftData only | ❌ No |

**Current login flow:**
```
User enters email + password
  → AuthViewModel fetches ALL User records from local SwiftData
  → Filters by email in-memory
  → Compares plain-text passwordHash
  → Routes to role-based dashboard
```

**Problem:** Supabase has `users` table with `first_name`, `last_name` (split), no `passwordHash`. Supabase Auth handles passwords separately. The local `User` model has `name` (single field) + `passwordHash`.

### 2.2 Product Browsing Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `HomeView.swift` | `@Query` on local `Product` + `Category` | ❌ No |
| `CategoriesView.swift` | `@Query(sort: \Category.displayOrder)` | ❌ No |
| `CategoryDetailView.swift` | `@Query` on local `Product` | ❌ No |
| `ProductListView.swift` | `@Query` on local `Product` | ❌ No |
| `ProductDetailView.swift` | Passed local `Product` object | ❌ No |
| `WishlistView.swift` | `@Query(filter: isWishlisted)` | ❌ No |

**Problem:** Supabase `products` has `sku`, `barcode`, `category_id` (UUID FK), `cost_price`, `image_urls` (array). Local `Product` has `categoryName` (string), `imageName` (SF Symbol), `isWishlisted`, `rating`, `stockCount`, `isLimitedEdition`, `isFeatured`. Major schema mismatch.

### 2.3 Cart & Orders Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `CartViewModel.swift` | Local SwiftData `CartItem` | ❌ No |
| `CartView.swift` | Local SwiftData `@Query` | ❌ No |
| `CheckoutView.swift` | Creates local `Order` | ❌ No |
| `OrdersListView.swift` | `@Query` on local `Order` | ❌ No |
| `OrderDetailView.swift` | Passed local `Order` | ❌ No |

**Problem:** Supabase `orders` uses `client_id`, `store_id`, `associate_id` (UUID FKs), `grand_total`, `is_tax_free`. Local `Order` uses `customerEmail` (string), `orderItems` (JSON string), `fulfillmentTypeRaw`. Very different schemas.

### 2.4 Admin Dashboard Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `AdminDashboardView.swift` | `@Query` counts on local `Product` + `User` | ❌ No |
| `CatalogView.swift` | `@Query` on local `Product` + `Category` | ❌ No |
| `OrganizationView.swift` | `@Query` on local `User` | ❌ No |
| `OperationsView.swift` | Hardcoded mock data | ❌ No |
| `InsightsView.swift` | Hardcoded mock data | ❌ No |

### 2.5 Manager Dashboard Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `ManagerDashboardView.swift` | Hardcoded mock + `@Query` | ❌ No |
| `ManagerInventoryView.swift` | `@Query` on local `Product` | ❌ No |
| `ManagerStaffView.swift` | Hardcoded mock data | ❌ No |
| `ManagerOperationsView.swift` | Hardcoded mock data | ❌ No |
| `ManagerInsightsView.swift` | Hardcoded mock data | ❌ No |

### 2.6 Sales Associate Flow

| File | Data Source | Works With Supabase? |
|------|------------|---------------------|
| `SalesDashboardView.swift` | Hardcoded mock data | ❌ No |
| `SalesClientsView.swift` | Placeholder | ❌ No |
| `SalesAppointmentsView.swift` | Placeholder | ❌ No |
| `AssistedSellingView.swift` | Placeholder | ❌ No |
| `SalesAfterSalesView.swift` | Placeholder | ❌ No |

---

## 3. Schema Comparison: Local SwiftData vs Supabase

### 3.1 Users

| Local SwiftData (`User`) | Supabase (`users` table) | Match? |
|--------------------------|--------------------------|--------|
| `id: UUID` | `id: uuid` (PK, linked to auth.users) | ⚠️ Supabase id comes from auth |
| `name: String` | `first_name` + `last_name` (separate) | ❌ Split |
| `email: String` | `email: text` | ✅ |
| `phone: String` | `phone: text` | ✅ |
| `passwordHash: String` | ❌ (handled by Supabase Auth) | ❌ Different system |
| `roleRaw: String` | `role: text` (default "client") | ⚠️ Values differ |
| `isActive: Bool` | `is_active: boolean` | ✅ |
| `createdAt: Date` | `created_at: timestamptz` | ✅ |
| — | `store_id: uuid` (FK to stores) | ❌ Missing locally |
| — | `avatar_url: text` | ❌ Missing locally |
| — | `updated_at: timestamptz` | ❌ Missing locally |

**Role value mismatch:**

| Local Role Enum | Supabase Expected |
|----------------|-------------------|
| `"Customer"` | `"client"` |
| `"Corporate Admin"` | `"corporate_admin"` |
| `"Boutique Manager"` | `"boutique_manager"` |
| `"Sales Associate"` | `"sales_associate"` |
| `"Inventory Controller"` | `"inventory_controller"` |
| `"Service Technician"` | `"service_technician"` |

### 3.2 Products

| Local SwiftData (`Product`) | Supabase (`products` table) | Match? |
|----------------------------|----------------------------|--------|
| `id: UUID` | `id: uuid` | ✅ |
| `name: String` | `name: text` | ✅ |
| `brand: String` | `brand: text` | ✅ |
| `productDescription: String` | `description: text` | ✅ (name differs) |
| `price: Double` | `price: numeric` | ✅ |
| `sku: String` | `sku: text` (unique, required) | ✅ |
| `barcode: String` | `barcode: text` | ✅ |
| `categoryName: String` | `category_id: uuid` (FK) | ❌ String vs UUID FK |
| `imageName: String` (SF Symbol) | `image_urls: text[]` (array) | ❌ Different concept |
| `isLimitedEdition: Bool` | — | ❌ Missing in Supabase |
| `isFeatured: Bool` | — | ❌ Missing in Supabase |
| `isWishlisted: Bool` | — | ❌ Client-side only |
| `rating: Double` | — | ❌ Missing in Supabase |
| `stockCount: Int` | — (in `inventory` table) | ❌ Different table |
| — | `cost_price: numeric` | ❌ Missing locally |
| — | `tax_category_id: uuid` (FK) | ❌ Missing locally |
| — | `is_active: boolean` | ❌ Missing locally |
| — | `created_by: uuid` (FK) | ❌ Missing locally |

### 3.3 Categories

| Local SwiftData (`Category`) | Supabase (`categories` table) | Match? |
|-----------------------------|-------------------------------|--------|
| `id: UUID` | `id: uuid` | ✅ |
| `name: String` | `name: text` | ✅ |
| `categoryDescription: String` | `description: text` | ✅ |
| `icon: String` | — | ❌ Missing in Supabase |
| `displayOrder: Int` | — | ❌ Missing in Supabase |
| `productTypes: String` | — | ❌ Missing in Supabase |
| — | `parent_id: uuid` (self-FK) | ❌ Missing locally |
| — | `is_active: boolean` | ❌ Missing locally |

### 3.4 Orders

| Local SwiftData (`Order`) | Supabase (`orders` table) | Match? |
|--------------------------|---------------------------|--------|
| `customerEmail: String` | `client_id: uuid` (FK) | ❌ Email vs UUID FK |
| `orderNumber: String` | `order_number: text` | ✅ |
| `total: Double` | `grand_total: numeric` | ⚠️ Name differs |
| `tax: Double` | `tax_total: numeric` | ⚠️ Name differs |
| `orderItems: String` (JSON) | Separate `order_items` table | ❌ Embedded vs relational |
| `fulfillmentTypeRaw` | — | ❌ Missing in Supabase |
| — | `store_id: uuid` (FK, required) | ❌ Missing locally |
| — | `associate_id: uuid` (FK) | ❌ Missing locally |
| — | `channel: text` | ❌ Missing locally |
| — | `currency: char(3)` | ❌ Missing locally |
| — | `is_tax_free: boolean` | ❌ Missing locally |

### 3.5 Tables in Supabase with NO Local Model

| Supabase Table | Local Equivalent | Status |
|---------------|-----------------|--------|
| `stores` | None | ❌ No model |
| `inventory` | `Product.stockCount` (embedded) | ❌ Different architecture |
| `order_items` | Embedded in `Order.orderItems` JSON | ❌ Different architecture |
| `payments` | None | ❌ No model |
| `tax_categories` | None | ❌ No model |
| `tax_rates` | None | ❌ No model |

### 3.6 Local Models with NO Supabase Table

| Local Model | Supabase Equivalent | Status |
|-------------|-------------------|--------|
| `ClientProfile` | `clients` table (partial match) | ⚠️ Schema differs |
| `Appointment` | `appointments` table (partial match) | ⚠️ Schema differs |
| `AfterSalesTicket` | `service_tickets` table (partial match) | ⚠️ Schema differs |
| `Transfer` | None | ❌ No table |
| `Event` | None | ❌ No table |
| `AppNotification` | None | ❌ No table |
| `CartItem` | None (client-side only) | N/A |

---

## 4. What Needs to Happen — Integration Roadmap

### Phase 1: Authentication (PRIORITY — do this first)

**Goal:** Replace local SwiftData login with Supabase Auth

| Step | Task | Effort |
|------|------|--------|
| 1.1 | Create Supabase Auth users (email+password) via dashboard or migration | Small |
| 1.2 | Create `AuthService.swift` that calls `SupabaseManager.shared.client.auth.signIn()` | Medium |
| 1.3 | After auth, fetch user profile from `users` table to get role + store_id | Medium |
| 1.4 | Update `AuthViewModel` to call `AuthService` instead of SwiftData | Medium |
| 1.5 | Update `AppState` to store Supabase session + user profile | Small |
| 1.6 | Customer signup via `client.auth.signUp()` + insert into `users` + `clients` | Medium |
| 1.7 | Forgot password via `client.auth.resetPasswordForEmail()` | Small |

**Key decisions needed:**
- Supabase uses `first_name` + `last_name`. App uses single `name`. Need to split/join.
- Supabase roles use `snake_case` (`corporate_admin`). App uses display strings (`"Corporate Admin"`). Need a mapping layer.
- The `users.id` in Supabase should match `auth.users.id`. Create users via Supabase Auth, then insert profile row.

### Phase 2: Product Catalog (HIGH priority)

**Goal:** Fetch products and categories from Supabase instead of local seed data

| Step | Task | Effort |
|------|------|--------|
| 2.1 | Create DTO structs: `SupabaseProduct`, `SupabaseCategory` matching Supabase columns | Medium |
| 2.2 | Create `ProductService.swift` with `fetchProducts()`, `fetchCategories()` | Medium |
| 2.3 | Seed Supabase tables with product/category data (via SQL or admin UI) | Small |
| 2.4 | Create `ProductViewModel` that fetches from Supabase and maps DTOs to display models | Medium |
| 2.5 | Update `HomeView`, `CategoriesView`, `ProductListView` to use ViewModel | Large |
| 2.6 | Handle `category_id` (UUID FK) vs current `categoryName` (string) | Medium |
| 2.7 | Handle `image_urls` (remote URLs) vs current `imageName` (SF Symbols) | Medium |
| 2.8 | Wishlist remains client-side (local SwiftData or Supabase `wishlists` table) | Small |

### Phase 3: Store & Inventory

| Step | Task | Effort |
|------|------|--------|
| 3.1 | Create `Store` DTO + `StoreService.swift` | Small |
| 3.2 | Fetch inventory from `inventory` table (store_id + product_id + quantity) | Medium |
| 3.3 | Wire Admin `OperationsView` and Manager `ManagerInventoryView` to live data | Large |

### Phase 4: Orders & Payments

| Step | Task | Effort |
|------|------|--------|
| 4.1 | Create `OrderDTO`, `OrderItemDTO`, `PaymentDTO` | Medium |
| 4.2 | Create `OrderService.swift` with `placeOrder()`, `fetchOrders()` | Medium |
| 4.3 | Wire `CheckoutView` → Supabase order creation (insert `orders` + `order_items`) | Large |
| 4.4 | Wire `OrdersListView` → fetch from Supabase | Medium |

### Phase 5: Appointments, Clients, Service Tickets

| Step | Task | Effort |
|------|------|--------|
| 5.1 | Create DTOs for `appointments`, `clients`, `service_tickets` | Medium |
| 5.2 | Wire Sales Associate views to Supabase | Large |
| 5.3 | Create missing Supabase tables for `transfers`, `events` if needed | Small |

---

## 5. Recommended Next Step (What To Do RIGHT NOW)

### Step 1: Seed the Supabase Database

Before wiring any code, the Supabase tables need data. Run this SQL in the Supabase SQL Editor:

```sql
-- Seed stores
INSERT INTO stores (id, name, country, city, address, currency, timezone)
VALUES
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Fifth Avenue Flagship', 'US', 'New York', '725 Fifth Avenue, NY 10022', 'USD', 'America/New_York'),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Rodeo Drive Boutique', 'US', 'Beverly Hills', '343 Rodeo Drive, CA 90210', 'USD', 'America/Los_Angeles'),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'Champs-Élysées Maison', 'FR', 'Paris', '101 Av. des Champs-Élysées, 75008', 'EUR', 'Europe/Paris'),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'Ginza Boutique', 'JP', 'Tokyo', '4-5-11 Ginza, Chuo-ku', 'JPY', 'Asia/Tokyo');

-- Seed categories
INSERT INTO categories (id, name, description) VALUES
  ('b1b2c3d4-0001-4000-8000-000000000001', 'Handbags', 'Exquisite leather handbags and clutches'),
  ('b1b2c3d4-0002-4000-8000-000000000002', 'Watches', 'Precision timepieces and luxury watches'),
  ('b1b2c3d4-0003-4000-8000-000000000003', 'Jewelry', 'Fine jewelry and precious gemstones'),
  ('b1b2c3d4-0004-4000-8000-000000000004', 'Accessories', 'Premium accessories and lifestyle pieces'),
  ('b1b2c3d4-0005-4000-8000-000000000005', 'Limited Edition', 'Exclusive limited edition collections');

-- Seed products
INSERT INTO products (id, sku, name, brand, description, price, category_id) VALUES
  ('c1b2c3d4-0001-4000-8000-000000000001', 'ML-HB-001', 'Classic Flap Bag', 'Maison Luxe', 'Timeless quilted leather bag with signature gold chain strap.', 4850, 'b1b2c3d4-0001-4000-8000-000000000001'),
  ('c1b2c3d4-0002-4000-8000-000000000002', 'ML-HB-002', 'Leather Tote', 'Maison Luxe', 'Spacious calfskin leather tote with suede interior lining.', 3200, 'b1b2c3d4-0001-4000-8000-000000000001'),
  ('c1b2c3d4-0003-4000-8000-000000000003', 'ML-HB-003', 'Mini Crossbody', 'Maison Luxe', 'Compact crossbody bag in soft lambskin.', 2450, 'b1b2c3d4-0001-4000-8000-000000000001'),
  ('c1b2c3d4-0004-4000-8000-000000000004', 'ML-WT-001', 'Perpetual Chronograph', 'Maison Luxe', 'Automatic chronograph with 18k gold case and Swiss movement.', 12500, 'b1b2c3d4-0002-4000-8000-000000000002'),
  ('c1b2c3d4-0005-4000-8000-000000000005', 'ML-WT-002', 'Diamond Bezel Watch', 'Maison Luxe', 'Ladies watch with diamond-set bezel and mother of pearl dial.', 8900, 'b1b2c3d4-0002-4000-8000-000000000002'),
  ('c1b2c3d4-0006-4000-8000-000000000006', 'ML-JW-001', 'Diamond Pendant', 'Maison Luxe', 'Brilliant-cut diamond pendant on 18k white gold chain.', 15800, 'b1b2c3d4-0003-4000-8000-000000000003'),
  ('c1b2c3d4-0007-4000-8000-000000000007', 'ML-JW-002', 'Pearl Earrings', 'Maison Luxe', 'South Sea pearl drop earrings with diamond accents.', 4200, 'b1b2c3d4-0003-4000-8000-000000000003'),
  ('c1b2c3d4-0008-4000-8000-000000000008', 'ML-JW-003', 'Gold Bracelet', 'Maison Luxe', 'Woven 18k rose gold bracelet with pavé diamond clasp.', 7500, 'b1b2c3d4-0003-4000-8000-000000000003'),
  ('c1b2c3d4-0009-4000-8000-000000000009', 'ML-AC-001', 'Silk Scarf', 'Maison Luxe', 'Hand-rolled silk twill scarf with original artwork print.', 890, 'b1b2c3d4-0004-4000-8000-000000000004'),
  ('c1b2c3d4-0010-4000-8000-000000000010', 'ML-AC-002', 'Leather Belt', 'Maison Luxe', 'Reversible calfskin belt with signature gold buckle.', 650, 'b1b2c3d4-0004-4000-8000-000000000004'),
  ('c1b2c3d4-0011-4000-8000-000000000011', 'ML-LE-001', 'Heritage Collection Bag', 'Maison Luxe', 'Numbered limited edition bag. Only 100 pieces worldwide.', 18500, 'b1b2c3d4-0005-4000-8000-000000000005'),
  ('c1b2c3d4-0012-4000-8000-000000000012', 'ML-LE-002', 'Artisan Timepiece', 'Maison Luxe', 'Hand-engraved platinum watch with enamel dial. Limited to 25 pieces.', 45000, 'b1b2c3d4-0005-4000-8000-000000000005');

-- Seed inventory (products in stores)
INSERT INTO inventory (store_id, product_id, quantity, reorder_point) VALUES
  ('a1b2c3d4-0001-4000-8000-000000000001', 'c1b2c3d4-0001-4000-8000-000000000001', 5, 2),
  ('a1b2c3d4-0001-4000-8000-000000000001', 'c1b2c3d4-0004-4000-8000-000000000004', 3, 1),
  ('a1b2c3d4-0001-4000-8000-000000000001', 'c1b2c3d4-0006-4000-8000-000000000006', 2, 1),
  ('a1b2c3d4-0001-4000-8000-000000000001', 'c1b2c3d4-0011-4000-8000-000000000011', 1, 0),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'c1b2c3d4-0002-4000-8000-000000000002', 8, 3),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'c1b2c3d4-0005-4000-8000-000000000005', 4, 2),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'c1b2c3d4-0009-4000-8000-000000000009', 15, 5),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'c1b2c3d4-0003-4000-8000-000000000003', 12, 4),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'c1b2c3d4-0007-4000-8000-000000000007', 6, 2),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'c1b2c3d4-0012-4000-8000-000000000012', 1, 0),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'c1b2c3d4-0008-4000-8000-000000000008', 5, 2),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'c1b2c3d4-0010-4000-8000-000000000010', 20, 8);

-- Seed tax categories
INSERT INTO tax_categories (id, name, description) VALUES
  ('d1b2c3d4-0001-4000-8000-000000000001', 'Luxury Goods', 'Standard luxury goods tax category'),
  ('d1b2c3d4-0002-4000-8000-000000000002', 'Jewelry', 'Precious metals and gemstones'),
  ('d1b2c3d4-0003-4000-8000-000000000003', 'Watches', 'Timepieces and horology');

-- Seed tax rates
INSERT INTO tax_rates (tax_category_id, country, rate, label) VALUES
  ('d1b2c3d4-0001-4000-8000-000000000001', 'US', 8.875, 'NY Sales Tax'),
  ('d1b2c3d4-0001-4000-8000-000000000001', 'FR', 20.0, 'TVA'),
  ('d1b2c3d4-0001-4000-8000-000000000001', 'JP', 10.0, 'Consumption Tax'),
  ('d1b2c3d4-0002-4000-8000-000000000002', 'US', 8.875, 'NY Sales Tax'),
  ('d1b2c3d4-0002-4000-8000-000000000002', 'FR', 20.0, 'TVA'),
  ('d1b2c3d4-0003-4000-8000-000000000003', 'US', 8.875, 'NY Sales Tax');
```

**For users**, you must create them via **Supabase Auth** (not just the `users` table), then insert the profile row. Use the Supabase Dashboard → Authentication → Users → "Create User" for each staff account.

### Step 2: Create DTO Layer

Create `Codable` structs that match the exact Supabase column names (snake_case):

```
Services/Supabase/DTOs/
  SupabaseUser.swift        → matches users table
  SupabaseProduct.swift     → matches products table
  SupabaseCategory.swift    → matches categories table
  SupabaseStore.swift       → matches stores table
  SupabaseOrder.swift       → matches orders table
  SupabaseInventory.swift   → matches inventory table
```

### Step 3: Create Service Layer

```
Services/Supabase/
  AuthService.swift         → signIn, signUp, signOut, fetchProfile
  ProductService.swift      → fetchProducts, fetchCategories, fetchByCategory
  StoreService.swift        → fetchStores, fetchStoreById
  InventoryService.swift    → fetchInventory, updateStock
  OrderService.swift        → placeOrder, fetchOrders, updateStatus
```

### Step 4: Wire Authentication First

Replace `AuthViewModel` login:
```swift
// BEFORE (local SwiftData):
let allUsers = try modelContext.fetch(FetchDescriptor<User>())
let matched = allUsers.first { $0.email == email }

// AFTER (Supabase Auth):
let session = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
let profile: SupabaseUser = try await SupabaseManager.shared.client
    .from("users").select().eq("id", value: session.user.id).single().execute().value
appState.login(name: "\(profile.firstName) \(profile.lastName)", email: profile.email, role: mapRole(profile.role))
```

### Step 5: Wire Product Browsing

Replace `@Query` in views with ViewModel fetches from Supabase.

---

## 6. Architecture Decision: Hybrid vs Full Supabase

### Option A: Full Supabase (Recommended)
- All data from Supabase, SwiftData used only for client-side cache/wishlist
- Requires DTO layer + Service layer + ViewModel refactor
- Best for production app

### Option B: Hybrid
- Auth via Supabase, products/categories still from local SwiftData seed
- Simpler, faster to implement
- Not production-ready but works for demo

### Option C: Keep SwiftData + Sync Later
- Continue using local SwiftData as primary
- Add background sync to/from Supabase later
- Most complex, least recommended

**Recommendation:** Go with **Option A** starting with Auth (Phase 1) → Products (Phase 2).

---

## 7. Risk Summary

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Schema mismatch between local and Supabase | High — wrong data shapes | Create DTO mapping layer |
| No RLS policies | Medium — data exposed | Add policies after auth works |
| Empty tables | High — app shows nothing | Seed via SQL (provided above) |
| Password stored in SwiftData | Security risk | Move to Supabase Auth ASAP |
| Supabase `users.id` linked to `auth.users` | Must create auth users first | Use Supabase dashboard |

---

*Document generated: March 12, 2026*
*Maison Luxe RSMS — Supabase Integration Audit*
