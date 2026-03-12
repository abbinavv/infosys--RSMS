# Maison Luxe — RSMS User Flows
## Sprint 1 Implementation

---

## Pre-Seeded Test Accounts

The app seeds demo accounts on first launch. **Use these to test each role.**

### Corporate Admin
| Field | Value |
|-------|-------|
| **Email / Employee ID** | `admin@maisonluxe.com` |
| **Password** | `admin123` |
| **Name** | Victoria Sterling |
| **Role** | Corporate Admin |

### Boutique Managers
| Email | Password | Name |
|-------|----------|------|
| `manager@maisonluxe.com` | `manager123` | James Beaumont |
| `sophia.l@maisonluxe.com` | `manager123` | Sophia Laurent |

### Sales Associates
| Email | Password | Name |
|-------|----------|------|
| `sales@maisonluxe.com` | `sales123` | Alexander Chase |
| `isabella.m@maisonluxe.com` | `sales123` | Isabella Moreau |

### Inventory Controller
| Email | Password | Name |
|-------|----------|------|
| `inventory@maisonluxe.com` | `inventory123` | Daniel Park |

### Service Technician
| Email | Password | Name |
|-------|----------|------|
| `service@maisonluxe.com` | `service123` | Marcus Webb |

### Demo Customer
| Email | Password | Name |
|-------|----------|------|
| `olivia@example.com` | `customer123` | Olivia Hartwell |

> **Note:** Staff accounts are provisioned by management. Staff do NOT sign up themselves.
> Only customers can create new accounts via the Sign Up screen.
> Any email/password not found in the database will log in as "Guest" (for demo purposes).

---

## Flow 1 — App Launch & Splash Screen

**File:** `Features/Splash/SplashScreenView.swift`
**Trigger:** App opened for the first time (or after a cold start)

```
App Launch
    │
    ▼
┌─────────────────────────────┐
│       SPLASH SCREEN         │
│                             │
│  [Purple outer ring fades]  │
│  [Gold ring + ◆ scales in]  │
│  [MAISON / LUXE fades in]   │
│  [Gold divider extends]     │
│  [Tagline fades in]         │
│                             │
│  Duration: 2.5 seconds      │
└─────────────────────────────┘
    │
    ▼
 AppState.completeSplash()
    │
    ├── First launch? ──▶ Onboarding (Flow 2)
    │
    └── Returning user? ──▶ Login (Flow 3)
```

**Visual:** Deep black background, champagne gold ◆ diamond logo, "MAISON" in ivory Didot, "LUXE" in gold, purple outer glow ring, gold expanding divider, "The Art of Luxury" tagline.

---

## Flow 2 — Onboarding (First Launch Only)

**Files:** `Features/Onboarding/OnboardingView.swift`, `OnboardingPageView.swift`
**Trigger:** `hasCompletedOnboarding == false` (first install)

```
Onboarding Screen 1             Onboarding Screen 2             Onboarding Screen 3
┌───────────────────┐          ┌───────────────────┐          ┌───────────────────┐
│            [Skip] │          │            [Skip] │          │                   │
│                   │          │                   │          │                   │
│    ☆ crown.fill   │   swipe  │  ☆ person.crop    │   swipe  │  ☆ calendar       │
│   (purple ring)   │ ──────▶ │   (purple ring)   │ ──────▶ │   (purple ring)   │
│   (gold rings)    │          │   (gold rings)    │          │   (gold rings)    │
│                   │          │                   │          │                   │
│   COLLECTIONS     │          │   EXPERIENCE      │          │   SERVICES        │
│   Discover Luxury │          │   Personalized    │          │   Book Appts &    │
│   Collections     │          │   Boutique Exp.   │          │   Manage Orders   │
│                   │          │                   │          │                   │
│  ● ○ ○            │          │  ○ ● ○            │          │  ○ ○ ●            │
│  ┌──────────┐     │          │  ┌──────────┐     │          │  ┌──────────┐     │
│  │   NEXT   │     │          │  │   NEXT   │     │          │  │GET STARTED│     │
│  └──────────┘     │          │  └──────────┘     │          │  └──────────┘     │
└───────────────────┘          └───────────────────┘          └───────────────────┘
         │                                                            │
         │ [Skip tapped]                              [Get Started tapped]
         └──────────────────┐        ┌────────────────────────────────┘
                            ▼        ▼
                   AppState.completeOnboarding()
                   hasCompletedOnboarding = true
                            │
                            ▼
                      Login Screen (Flow 3)
```

**Interactions:**
- Swipe left/right between pages
- "Skip" (pages 1-2) → jumps to login
- "Next" (pages 1-2) → advances one page
- "Get Started" (page 3) → completes onboarding, goes to login
- Gold animated page dots (active = expanded capsule)

---

## Flow 3 — Authentication

### 3a. Login Screen

**File:** `Features/Auth/Views/LoginView.swift`
**Trigger:** Onboarding complete OR returning user

```
┌──────────────────────────────┐
│                              │
│        ◆ (gold diamond)      │
│        MAISON LUXE           │
│                              │
│       Welcome Back           │
│    Sign in to your account   │
│                              │
│  ✉ [Email or Employee ID]   │
│  🔒 [Password             ]  │
│                              │
│           Forgot Password? → │ ──▶ Flow 3c
│                              │
│  ┌────────────────────────┐  │
│  │       SIGN IN          │  │ ──▶ Validates → Flow 4 (Main App)
│  └────────────────────────┘  │
│                              │
│  ─────── OR ───────          │
│                              │
│  New to Maison Luxe?         │
│  ┌────────────────────────┐  │
│  │    CREATE ACCOUNT      │  │ ──▶ Flow 3b (sheet)
│  └────────────────────────┘  │
│                              │
│  Staff accounts are          │
│  provisioned by management   │
│                              │
└──────────────────────────────┘
```

**Login Logic:**
1. User enters email/Employee ID + password
2. ViewModel checks SwiftData for matching `User`
3. If found → verifies password → `appState.login(name, email)` → Main Tab
4. If not found → logs in as "Guest" (demo mode)
5. Loading spinner shown during 1s simulated network delay

**Employee Login Test:**
- Enter `admin@maisonluxe.com` / `admin123` → logs in as Victoria Sterling (Corporate Admin)
- Enter `manager@maisonluxe.com` / `manager123` → logs in as James Beaumont (Boutique Manager)
- Enter `sales@maisonluxe.com` / `sales123` → logs in as Alexander Chase (Sales Associate)

### 3b. Customer Sign Up

**File:** `Features/Auth/Views/CustomerSignUpView.swift`
**Trigger:** "Create Account" tapped on Login screen (opens as sheet)

```
┌──────────────────────────────┐
│ ✕                            │
│       Create Account         │
│  Join the Maison Luxe exp.   │
│                              │
│  👤 [Full Name             ]  │
│  ✉ [Email Address          ] │
│  📞 [Phone Number          ]  │
│  🔒 [Password              ]  │
│  🛡 [Confirm Password      ]  │
│                              │
│  ⓘ Minimum 6 characters     │
│                              │
│  ┌────────────────────────┐  │
│  │    CREATE ACCOUNT      │  │
│  └────────────────────────┘  │
│                              │
│  Terms of Service notice     │
└──────────────────────────────┘
```

**Sign Up Logic:**
1. All fields validated (name, email, password match, ≥6 chars)
2. New `User` created with `.customer` role in SwiftData
3. Auto-login → Main Tab
4. Error alert if validation fails

**Important:** Only customers use this screen. Staff, managers, admins are pre-provisioned.

### 3c. Forgot Password

**File:** `Features/Auth/Views/ForgotPasswordView.swift`
**Trigger:** "Forgot Password?" tapped on Login screen (opens as sheet)

```
┌──────────────────────────────┐
│ ✕                            │
│                              │
│    (purple ring)             │
│    (gold ring)               │
│       🔑 (rotated key)      │
│                              │
│      Reset Password          │
│  Enter your email and we'll  │
│  send you a reset link       │
│                              │
│  ✉ [Email Address          ] │
│                              │
│  ┌────────────────────────┐  │
│  │   SEND RESET LINK     │  │
│  └────────────────────────┘  │
│                              │
└──────────────────────────────┘
         │
         ▼ (1.5s delay)
   Success Alert: "A password reset link
   has been sent to your email address."
         │
         ▼ [OK]
   Dismisses sheet → back to Login
```

---

## Flow 4 — Main App (Tab Navigation)

**File:** `Navigation/MainTabView.swift`
**Trigger:** Successful login → `AppState.currentFlow = .main`

```
┌─────────────────────────────────────────────┐
│                                             │
│              [Active Tab Content]           │
│                                             │
├─────────────────────────────────────────────┤
│  🏠 Home  │  ▦ Categories │ ♡ Wishlist │ 👤 Profile │
│  (gold)   │              │            │            │
└─────────────────────────────────────────────┘
```

- **Tab bar:** Black background, grey inactive icons, champagne gold active icon + label
- Tabs: Home (0), Categories (1), Wishlist (2), Profile (3)

---

## Flow 5 — Home Screen

**File:** `Features/Home/HomeView.swift`
**Trigger:** Home tab selected (default)

```
┌──────────────────────────────┐
│ MAISON LUXE (gold)     🔔   │  ← Navigation bar
│                              │
│ ┌──────────────────────────┐ │
│ │ NEW COLLECTION           │ │
│ │ Spring 2026              │ │  ← Hero Banner
│ │ Discover the essence...  │ │    (dark gradient + gold accent line)
│ │ Explore →                │ │
│ │              ◇ (faded)   │ │
│ └──────────────────────────┘ │
│                              │
│ Categories          See All  │
│ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐   │
│ │👜│ │⌚│ │✨│ │🕶│ │⭐│   │  ← Horizontal scroll
│ │Bag│ │Wat│ │Jew│ │Acc│ │Ltd│   │
│ └──┘ └──┘ └──┘ └──┘ └──┘   │
│                              │
│ Featured            View All │
│ ┌────────┐ ┌────────┐       │
│ │ [img]  │ │ [img]  │       │  ← Horizontal scroll
│ │ BRAND  │ │ BRAND  │       │    (LuxuryCardView)
│ │ Name   │ │ Name   │       │
│ │ $4,850 │ │$12,500 │       │
│ └────────┘ └────────┘       │
│                              │
│ New Arrivals        View All │
│ ┌──────────────────────────┐ │
│ │ [img] BRAND              │ │  ← Vertical list rows
│ │       Product Name    ▸  │ │
│ │       $4,850             │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ [img] BRAND              │ │
│ │       Product Name    ▸  │ │
│ │       $3,200             │ │
│ └──────────────────────────┘ │
└──────────────────────────────┘
```

**Interactions:**
- Tap category chip → `ProductListView` filtered by that category
- Tap featured product card → `ProductDetailView`
- Tap new arrival row → `ProductDetailView`
- All within a `NavigationStack`

---

## Flow 6 — Categories Screen

**File:** `Features/Categories/CategoriesView.swift`
**Trigger:** Categories tab selected

```
┌──────────────────────────────┐
│         Categories           │  ← Nav bar
│                              │
│ BROWSE                       │
│ Collections                  │
│                              │
│ ┌────────────┐ ┌────────────┐│
│ │  (purple)  │ │  (purple)  ││
│ │  (gold ○)  │ │  (gold ○)  ││  ← 2-column LazyVGrid
│ │   👜       │ │   ⌚       ││    (LuxuryCardView)
│ │ Handbags   │ │ Watches    ││
│ │ Exquisite..│ │ Precision..││
│ └────────────┘ └────────────┘│
│ ┌────────────┐ ┌────────────┐│
│ │  (purple)  │ │  (purple)  ││
│ │  (gold ○)  │ │  (gold ○)  ││
│ │   ✨       │ │   🕶       ││
│ │ Jewelry    │ │ Accessories││
│ │ Fine jewel.│ │ Premium ac.││
│ └────────────┘ └────────────┘│
│ ┌────────────┐               │
│ │  (purple)  │               │
│ │  (gold ○)  │               │
│ │   ⭐       │               │
│ │ Limited Ed.│               │
│ │ Exclusive..│               │
│ └────────────┘               │
└──────────────────────────────┘
```

**Interactions:**
- Tap any category card → pushes `ProductListView(categoryFilter: "Handbags")` etc.

---

## Flow 7 — Product Listing

**File:** `Features/Products/Views/ProductListView.swift`
**Trigger:** Category tapped from Home or Categories

```
┌──────────────────────────────┐
│ ◀ Handbags                   │  ← Large title nav
│                              │
│ 3 items                Sort ↕│  ← Sort menu
│                              │    (Featured / Price ↑ / Price ↓ / Newest)
│ ┌────────────┐ ┌────────────┐│
│ │ [image]  ♡ │ │ [image]  ♡ ││
│ │            │ │            ││  ← 2-column LazyVGrid
│ │ [LIMITED]  │ │            ││    (LuxuryCardView)
│ │ MAISON LUXE│ │ MAISON LUXE││
│ │ Classic Fl.│ │ Leather T. ││
│ │ $4,850     │ │ $3,200     ││
│ └────────────┘ └────────────┘│
│ ┌────────────┐               │
│ │ [image]  ♡ │               │
│ │            │               │
│ │ MAISON LUXE│               │
│ │ Mini Cross.│               │
│ │ $2,450     │               │
│ └────────────┘               │
└──────────────────────────────┘
```

**Interactions:**
- ♡ button toggles wishlist (persisted to SwiftData)
- Sort menu changes ordering
- Tap product → `ProductDetailView`
- LIMITED badge shown on limited edition items

---

## Flow 8 — Product Detail

**File:** `Features/Products/Views/ProductDetailView.swift`
**Trigger:** Product tapped from any listing

```
┌──────────────────────────────┐
│ ◀                            │
│                              │
│        ┌──────────────┐      │
│        │              │      │
│        │   [Product   │      │  ← Large image area (380pt)
│        │    Image]    │      │
│        │              │      │
│        │ [LIMITED ED] │      │
│        └──────────────┘      │
│                              │
│ MAISON LUXE                  │  ← Gold eyebrow
│ Classic Flap Bag             │  ← Didot heading
│ ★★★★★ 4.9                   │  ← Gold stars
│                              │
│ $4,850          ● In Stock   │  ← Price + stock status
│                              │
│ ─── gold divider ───         │
│                              │
│ DESCRIPTION                  │
│ Timeless quilted leather     │
│ bag with signature gold      │
│ chain strap...               │
│                              │
│ ─── gold divider ───         │
│                              │
│ DETAILS                      │
│ Brand        Maison Luxe     │
│ Category     Handbags        │
│ Availability Available       │
│ Collection   Limited Edition │
│                              │
├──────────────────────────────┤
│ [♡]  ┌──────────────────┐   │  ← Sticky bottom bar
│      │    ADD TO BAG     │   │    (shadow overlay)
│      └──────────────────┘   │
└──────────────────────────────┘
```

**Interactions:**
- ♡ toggles wishlist with spring animation (persisted)
- "Add to Bag" → placeholder for future cart feature
- Stock status: "In Stock" (green), "Only X left" (green), "Out of Stock" (red)
- Back navigation via standard iOS nav

---

## Flow 9 — Wishlist

**File:** `Features/Wishlist/WishlistView.swift`
**Trigger:** Wishlist tab selected

### Empty State
```
┌──────────────────────────────┐
│          Wishlist            │
│                              │
│                              │
│       (purple ring)          │
│       (gold ring)            │
│          ♡                   │
│                              │
│   Your Wishlist is Empty     │
│   Save pieces you love to    │
│   revisit them later         │
│                              │
└──────────────────────────────┘
```

### With Items
```
┌──────────────────────────────┐
│          Wishlist            │
│                              │
│ YOUR WISHLIST                │
│ 2 items                      │
│                              │
│ ┌──────────────────────────┐ │
│ │ [img] MAISON LUXE    ♥  │ │  ← Tap ♥ removes from wishlist
│ │       Classic Flap Bag   │ │
│ │       $4,850             │ │
│ │       ● In Stock         │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ [img] MAISON LUXE    ♥  │ │
│ │       Diamond Pendant    │ │
│ │       $15,800            │ │
│ │       ● Only 2 left      │ │
│ └──────────────────────────┘ │
└──────────────────────────────┘
```

**Interactions:**
- Tap row → `ProductDetailView`
- Tap red ♥ → removes from wishlist (animated)
- Real-time @Query auto-updates the list

---

## Flow 10 — Profile

**File:** `Features/Profile/ProfileView.swift`
**Trigger:** Profile tab selected

```
┌──────────────────────────────┐
│         Profile          ⚙  │
│                              │
│       (purple ring)          │
│       ┌──────────┐           │
│       │ gold ○   │           │
│       │   VS     │           │  ← Initials from user name
│       └──────────┘           │
│    Victoria Sterling         │
│    admin@maisonluxe.com      │
│                              │
│ ─── gold divider ───         │
│                              │
│ 🛍  My Orders                │
│     Track your orders     ▸  │
│ 📅 Appointments              │
│     Book a boutique visit ▸  │
│ 🔔 Notifications             │
│     Manage preferences    ▸  │
│ 💳 Payment Methods           │
│     Manage cards          ▸  │
│ 📍 Addresses                 │
│     Delivery addresses    ▸  │
│ 🛡  Privacy & Security       │
│     Account settings      ▸  │
│ ❓ Help & Support            │
│     Contact us            ▸  │
│                              │
│ ─── gold divider ───         │
│                              │
│    🚪 Sign Out  (red)        │
│                              │
│       Version 1.0.0          │
└──────────────────────────────┘
         │
    [Sign Out tapped]
         ▼
   Confirmation Alert:
   "Are you sure you want to
    sign out of your account?"
    [Cancel] [Sign Out]
         │
    [Sign Out confirmed]
         ▼
   AppState.logout()
   → Back to Login Screen
```

---

## CORPORATE ADMIN FLOWS (Enterprise Architecture — v2)

> When `admin@maisonluxe.com` / `admin123` logs in, the app routes to `AdminTabView` (5 enterprise modules) instead of `MainTabView`. The Corporate Admin sees a **luxury enterprise control dashboard**, not a shopping app.

### Navigation Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                    [Active Module Content]                     │
├───────────────────────────────────────────────────────────────┤
│ ▦ Dashboard │ 📦 Operations │ 🏷 Catalog │ 🏢 Org │ 📊 Insights │
└───────────────────────────────────────────────────────────────┘
```

Settings/Profile is accessed from the **Dashboard nav bar avatar** (as a sheet), not as a tab.

---

## Flow 11 — Admin Login Routing

```
Login → AuthViewModel detects role == .corporateAdmin
    → AppState.currentFlow = .adminDashboard
    → RootView switches to AdminTabView (5 tabs)
```

---

## Flow 12 — Dashboard (Tab 1)

**File:** `Features/Admin/Dashboard/AdminDashboardView.swift`

```
┌──────────────────────────────┐
│ MAISON LUXE                  │
│ Enterprise Console    🔔 (VS)│ ← avatar opens Settings sheet
│                              │
│ Good Morning,                │
│ Victoria            CORP ADM │
│                    Mar 10, 26│
│                              │
│ KEY METRICS                  │
│ ┌────────┐ ┌────────┐       │
│ │$2.4M   │ │ 13     │       │
│ │Revenue │ │ SKUs   │       │ ← 2x3 grid, live @Query
│ │+12.5%  │ │ 5 cat. │       │
│ ├────────┤ ├────────┤       │
│ │ 8      │ │ 4      │       │
│ │Users   │ │Boutique│       │
│ │7 staff │ │All live│       │
│ ├────────┤ ├────────┤       │
│ │ 3      │ │ 87     │       │
│ │Low Stk │ │Total U │       │
│ │0 out   │ │2 lmtd  │       │
│ └────────┘ └────────┘       │
│                              │
│ ✅API  ✅DB  ✅Pay  ⚠️Sync   │ ← system health pills
│                              │
│ ALERTS                  [3]  │
│ 🔴 Critical: Heritage Bag    │
│ 🟡 Sync Delay — Paris        │ ← color-coded left border
│ 🔵 Access Request — Sophia   │
│                              │
│ QUICK ACTIONS                │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │+SKU│ │+Stf│ │+Str│        │
│ ├────┤ ├────┤ ├────┤        │ ← 2x3 action grid
│ │Xfer│ │Prmo│ │Rpt │        │
│ └────┘ └────┘ └────┘        │
│                              │
│ ACTIVITY         View All    │
│ ● SKU Created — Artisan...   │
│ ● Price Override — Diamond.. │
│ ● Staff Provisioned — Isab. │
│ ● Stock Transfer — NYC→Paris │
└──────────────────────────────┘
```

---

## Flow 13 — Operations (Tab 2)

**File:** `Features/Admin/Operations/OperationsView.swift`
**Segments:** Inventory | Distribution | Transfers

### Inventory
```
┌──────────────────────────────┐
│ [87 Units] [13 SKUs] [3 Low] [0 Out] │ ← live stats
│                              │
│ REQUIRES ATTENTION           │
│ 🔴 Heritage Bag — OUT       │ [Reorder]
│ 🟡 Artisan Timepiece — 1 left│ [Reorder]
│                              │
│ ALL INVENTORY                │
│ [img] Classic Flap Bag    5  │
│ [img] Leather Tote        8  │
│ [img] Mini Crossbody     12  │
│ ...sorted by stock asc      │
└──────────────────────────────┘
```

### Distribution
```
┌──────────────────────────────┐
│ [2 Centers] [43K Cap] [68%]  │
│                              │
│ East Coast Hub — Newark, NJ  │
│ ████████████░░░  73%         │
│ 18,200 / 25,000 units       │
│                              │
│ European Hub — Milan, Italy  │
│ ██████████░░░░░  64%         │
│ 11,500 / 18,000 units       │
└──────────────────────────────┘
```

### Transfers
```
┌──────────────────────────────┐
│ PENDING                      │
│ Classic Flap  ×2 NYC→Paris   │ IN TRANSIT
│ Pearl Earring ×3 Milan→Tokyo │ PACKING
│                              │
│ COMPLETED                    │
│ Diamond Pendant ×1 DC→Rodeo  │ DELIVERED
│ Silk Scarf ×5 Milan→Fifth    │ DELIVERED
└──────────────────────────────┘
```

---

## Flow 14 — Catalog (Tab 3)

**File:** `Features/Admin/Catalog/CatalogView.swift`
**Segments:** Products | Categories | Pricing | Promos

### Products (SKU Management)
- Search bar + category filter chips
- Product rows with: image, name, LTD badge, category, price, stock indicator
- ⋯ menu per row: Edit, Price, Stock, Delete
- + button for new SKU creation

### Categories
- All categories with icon, description, live SKU count
- Drill-down navigation ready

### Pricing
- **Tax Configuration** — US Federal 0%, NY 8.875%, CA 7.25%, EU VAT 20%, Japan 10%
- **Currency Settings** — USD primary, EUR/GBP/JPY auto-convert
- **Discount Rules** — VIP Gold 5%, Platinum 10%, Employee 15%, Loyalty points

### Promotions
- Active / Scheduled / Ended campaign cards
- Each shows: name, discount rule, date range, status badge
- Examples: Spring 2026 Collection, VIP Private Sale, Holiday Clearance

---

## Flow 15 — Organization (Tab 4)

**File:** `Features/Admin/Organization/OrganizationView.swift`
**Segments:** Boutiques | Staff | Roles

### Boutiques
```
[4 Active] [35 Staff] [$2.4M Revenue]

┌──────────────────────────────┐
│ Maison Luxe — Fifth Avenue   │
│ New York, NY     OPERATIONAL │
│ ─────────────────────────    │
│ Manager: James Beaumont      │
│ Revenue: $890K  Staff: 12    │
└──────────────────────────────┘
... (Rodeo Drive, Champs-Élysées, Ginza)
```

### Staff Management
- Search bar + role filter chips (excludes customers)
- Staff rows: avatar (role-colored), name, email, role badge
- ⋯ menu: Edit, Reset Password, Deactivate/Reactivate
- Role color coding: Gold=Admin, Purple=Manager, Blue=Sales, Green=Inventory, Orange=Tech

### Roles & Permissions (RBAC)
```
┌──────────────────────────────┐
│ 🛡 Corporate Admin     [Edit]│
│ ─────────────────────────    │
│ ✓ Full system access         │
│ ✓ Create/manage all accounts │
│ ✓ Product catalog CRUD       │
│ ✓ Pricing & tax config       │
│ ✓ All reports & analytics    │
└──────────────────────────────┘
... (Manager, Sales, Inventory, Tech)
```

---

## Flow 16 — Insights (Tab 5)

**File:** `Features/Admin/Insights/InsightsView.swift`
**Segments:** Analytics | Reports | Compliance

### Analytics
- Period selector: Today / Week / Month / Quarter / Year
- Revenue hero card: $2,412,500 (+12.5%)
- Revenue trend bar chart (12 bars)
- Channel breakdown: Online 49%, In-Store 41%, Private 10%
- Category performance bars (Watches, Jewelry, Handbags, Accessories, Limited Ed.)
- Top 5 SKUs by revenue

### Reports Library
- Sales Report — transaction history
- Staff Performance — employee metrics
- Inventory Report — stock levels & turnover
- Boutique Comparison — cross-location KPIs
- Financial Summary — revenue, costs, margins
- Product Mix Analysis — category trends
- Customer Analytics — segments, LTV, retention

### Compliance & Audit
```
[Passed] [98.5% Score] [Next: Apr 15]

AUDIT CHECKS
✅ Access Control Verification    PASSED
✅ Data Encryption Standards      PASSED
✅ Password Policy Compliance     PASSED
⚠️ Inventory Reconciliation      REVIEW
✅ Financial Reporting Accuracy   PASSED
✅ PCI-DSS Compliance            PASSED

RECENT ACCESS LOGS
Victoria Sterling  Login       192.168.1.1   2m
James Beaumont     User Edit   192.168.1.45  1h
Sophia Laurent     Report Exp  10.0.0.12     3h
```

---

## Flow 17 — Admin Settings (Sheet from Dashboard)

**File:** `Features/Admin/Profile/AdminProfileView.swift`
**Trigger:** Tap avatar in Dashboard nav bar → opens as sheet

Sections: Account (profile, password, biometrics) → System Security (RBAC, access logs, audit trail, policies) → System (config, notifications, help) → Sign Out

---

## Corporate Admin — Module Summary

| Module | Sub-sections | Key Capabilities |
|--------|-------------|-----------------|
| **Dashboard** | Metrics, Health, Alerts, Actions, Activity | Enterprise KPIs (live @Query), system health monitoring, priority alerts, 6 quick action tiles, chronological activity feed |
| **Operations** | Inventory, Distribution, Transfers | Global stock visibility sorted by urgency, reorder actions, DC utilization bars, transfer tracking with status badges |
| **Catalog** | Products, Categories, Pricing, Promos | Full SKU CRUD, category browsing, tax/currency/discount configuration, campaign lifecycle management |
| **Organization** | Boutiques, Staff, Roles | Location cards with KPIs, staff CRUD with role filtering, RBAC permission matrix with edit capability |
| **Insights** | Analytics, Reports, Compliance | Period-based revenue analytics, 7 report types, audit check matrix, real-time access logs |

---

## BOUTIQUE MANAGER FLOWS (Store Operations — v1)

> When `manager@maisonluxe.com` / `manager123` logs in, the app routes to `ManagerTabView` (5 store-operations modules). The Boutique Manager sees a **store operations dashboard**, not an enterprise admin panel or a shopping app.

### Login Routing

```
Login → AuthViewModel detects role == .boutiqueManager
    → AppState.currentFlow = .managerDashboard
    → RootView switches to ManagerTabView (5 tabs)
```

### Navigation Architecture

```
┌───────────────────────────────────────────────────────────────────┐
│                     [Active Module Content]                       │
├───────────────────────────────────────────────────────────────────┤
│ ▦ Dashboard │ 📋 Operations │ 👥 Staff │ 📦 Inventory │ 📊 Insights │
└───────────────────────────────────────────────────────────────────┘
```

Profile/Settings accessed from **Dashboard nav bar avatar** (sheet).

---

## Flow 18 — Manager Dashboard (Tab 1)

**File:** `Features/Manager/Dashboard/ManagerDashboardView.swift`

```
┌──────────────────────────────┐
│ MAISON LUXE                  │
│ Fifth Avenue Boutique 🔔 (JB)│ ← avatar opens Profile sheet
│                              │
│ Good Morning,                │
│ James             BOUT. MGR  │
│                    Mar 10, 26│
│                              │
│ TODAY'S PERFORMANCE          │
│ ┌─────────┬─────────┬───────┐│
│ │ $42,800 │    7    │$6,114 ││ ← gold-bordered hero strip
│ │ Today   │  Txns   │Avg Tkt││
│ └─────────┴─────────┴───────┘│
│                              │
│ STORE OVERVIEW               │
│ ┌────────┐ ┌────────┐       │
│ │$248K   │ │ 3      │       │
│ │MTD Rev │ │Staff   │       │ ← 2x2 KPI grid
│ ├────────┤ ├────────┤       │
│ │ 89     │ │ 3      │       │
│ │Units   │ │Low Stk │       │
│ └────────┘ └────────┘       │
│                              │
│ ALERTS                  [3]  │
│ 🔴 Heritage Bag — 1 unit     │
│ 🟡 Discrepancy — Pearl Ear.  │
│ 🔵 VIP — Mrs. Chen 3:00 PM   │
│                              │
│ TOP SELLERS TODAY            │
│ [img][img][img][img][img]    │ ← horizontal scroll cards
│                              │
│ STAFF ON DUTY                │
│ (AC) (IM) (DP) (MW)         │ ← role-colored avatars
│ Alex  Isab  Dan   Marc      │
│ Sales Sales Inv.  Tech      │
│                              │
│ QUICK ACTIONS                │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │Aprv│ │Xfer│ │VIP │        │
│ ├────┤ ├────┤ ├────┤        │
│ │Shft│ │Rpt │ │Flag│        │
│ └────┘ └────┘ └────┘        │
└──────────────────────────────┘
```

---

## Flow 19 — Operations (Tab 2)

**File:** `Features/Manager/Operations/ManagerOperationsView.swift`
**Segments:** Sales | Discrepancies | VIP Events | Activity

### Sales
- Today's summary: $42.8K, 7 txns, $6.1K avg
- Recent transaction cards: TXN ID, customer, items, amount, associate, timestamp

### Discrepancies
- Stats: 2 Pending, 5 Resolved, 0 Escalated
- Pending cards with: SKU, system vs counted, variance, flagged-by, **[Approve]** button
- Resolved history

### VIP Events
- Today + Upcoming appointment cards
- Each shows: client, type (Private Viewing / Consultation / Styling), time, assigned associate, items, status (Confirmed / Pending)

### Activity Log
- Chronological store activity: sales, counts, opens, VIP confirmations, transfers
- Each row: action, detail, by-line, timestamp

---

## Flow 20 — Staff (Tab 3)

**File:** `Features/Manager/Staff/ManagerStaffView.swift`
**Segments:** Roster | Shifts | Performance

### Roster
- Stats: Total / Active / Sales count
- Staff cards: avatar (role-colored), name, email, role, current status (On Floor), shift time
- Store-scoped: only shows Sales Associates, Inventory Controllers, Service Technicians

### Shifts
- Today's schedule: who, shift time, status (On Floor / Stockroom / Service Bay)
- Tomorrow's schedule: Scheduled / Day Off
- Manager can see full week at a glance

### Performance
- **Sales Leaderboard:** rank, name, total sales, txn count, avg ticket, conversion rate
- **Support Staff:** Inventory accuracy %, repairs completed, turnaround time
- All metrics are store-scoped and monthly

---

## Flow 21 — Inventory (Tab 4)

**File:** `Features/Manager/Inventory/ManagerInventoryView.swift`
**Segments:** Stock | Alerts | Transfers | Flagged

### Stock
- Stats: Total units, SKUs, Low count, Out count (all live @Query)
- Search bar for product lookup
- Full inventory list sorted by stock ascending (urgency first)
- Color-coded stock badges: green >5, yellow 1-3, red OUT

### Alerts
- Products with stock ≤ 3 shown with severity indicator
- **[Request]** button per item to initiate transfer request

### Transfers
- Outbound Requests: items this store requested
- Inbound: transfers coming to this store
- Status badges: REQUESTED → IN TRANSIT → DELIVERED

### Flagged Items
- Items flagged for quality issues (scratches, damage, mechanism issues)
- Each shows: item + serial, reason, flagged by, severity, **[Review]** button

---

## Flow 22 — Insights (Tab 5)

**File:** `Features/Manager/Insights/ManagerInsightsView.swift`
**Segments:** Revenue | Products | Staff

### Revenue
- Period selector: Today / This Week / This Month
- Revenue hero: $248,600 (+8.2%)
- Daily trend bar chart (10 days)
- Target progress bars: Monthly Target ($248K/$300K), Avg Ticket ($6.1K/$7K), Transactions (38/50)

### Products
- Top 5 sellers by price/revenue
- Category mix bars (Watches 34%, Jewelry 26%, Handbags 22%, Accessories 12%, Limited 6%)
- Slow movers list

### Staff
- Sales leaderboard with revenue and transaction count
- Conversion rate per associate with trend indicators
- Attendance this month: present/total days, late count

---

## Flow 23 — Manager Profile (Sheet from Dashboard)

**File:** `Features/Manager/Profile/ManagerProfileView.swift`
**Trigger:** Tap avatar in Dashboard nav bar → opens as sheet

```
┌──────────────────────────────┐
│ ✕              Profile       │
│                              │
│       (purple ring)          │
│       ┌──────────┐           │
│       │ purple ○ │           │
│       │   JB     │           │
│       └──────────┘           │
│    James Beaumont            │
│    manager@maisonluxe.com    │
│    🏢 BOUTIQUE MANAGER       │
│                              │
│ ─── gold divider ───         │
│                              │
│ MY BOUTIQUE                  │
│ 🏢 Fifth Avenue — NYC        │
│ 👥 4 Staff Members            │
│ 🕐 10:00 AM – 8:00 PM        │
│                              │
│ ─── gold divider ───         │
│                              │
│ ACCOUNT                      │
│ 👤 Edit Profile           ▸  │
│ 🔑 Change Password        ▸  │
│ 🪪 Biometric Login         ▸  │
│                              │
│ ─── gold divider ───         │
│                              │
│ PREFERENCES                  │
│ 🔔 Notifications           ▸  │
│ 🌐 Language                ▸  │
│ ❓ Help & Support           ▸  │
│                              │
│ ─── gold divider ───         │
│                              │
│    🚪 Sign Out  (red)        │
│ v1.0.0 • Manager Console     │
└──────────────────────────────┘
```

---

## Boutique Manager — Module Summary

| Module | Sub-sections | Key Capabilities |
|--------|-------------|-----------------|
| **Dashboard** | Daily Sales, KPIs, Alerts, Top Products, Staff On Duty, Quick Actions | Store-scoped daily performance strip, 2×2 KPI grid, priority alerts, horizontal top-seller cards, staff avatars, 2×3 action tiles |
| **Operations** | Sales, Discrepancies, VIP Events, Activity | Transaction history with associate attribution, discrepancy approval workflow, VIP appointment management, chronological activity log |
| **Staff** | Roster, Shifts, Performance | Store staff cards with status, shift schedules, sales leaderboard with conversion rates, support staff metrics |
| **Inventory** | Stock, Alerts, Transfers, Flagged | Full inventory with search, critical stock alerts with transfer request, inbound/outbound transfer tracking, quality flag review |
| **Insights** | Revenue, Products, Staff | Revenue vs targets with progress bars, category mix analysis, staff productivity and attendance tracking |

---

## Corporate Admin vs Boutique Manager — Comparison

| Aspect | Corporate Admin | Boutique Manager |
|--------|----------------|-----------------|
| **Scope** | Enterprise-wide | Single boutique |
| **Tab count** | 5 (Dashboard, Operations, Catalog, Organization, Insights) | 5 (Dashboard, Operations, Staff, Inventory, Insights) |
| **Products** | Full CRUD (create, edit, delete SKUs) | View only (stock levels, no catalog editing) |
| **Users** | Create/manage all roles globally | View/supervise assigned store staff |
| **Stores** | Manage all boutiques + DCs | View own store info only |
| **Pricing** | Configure tax, currency, discounts | Not visible |
| **Promotions** | Create/manage campaigns | Not visible |
| **Reports** | Enterprise-wide analytics | Store-scoped analytics + targets |
| **RBAC** | Full permission matrix editing | Not visible |
| **Unique features** | System health, compliance/audit | VIP events, discrepancy approval, shift management, flagged items |


## Complete Navigation Map

```
                         ┌──────────┐
                         │  Launch  │
                         └────┬─────┘
                              │
                         ┌────▼─────┐
                         │  Splash  │ (2.5s)
                         └────┬─────┘
                              │
              ┌───────────────┼───────────────┐
              │ first launch  │               │ returning
         ┌────▼─────┐        │          ┌────▼─────┐
         │Onboarding│        │          │  Login   │
         │ (3 pgs)  │        │          └────┬─────┘
         └────┬─────┘        │               │
              │               │    ┌──────────┼──────────┐
              └───────▶ Login ◀    │          │          │
                        │         Forgot    SignUp    Success
                        │         Password  (customer  │
                        │         (sheet)    sheet)     │
                        │                              │
                        └──────┬───────────────────────┘
                               │
                 AppState.login(role:)
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
   .corporateAdmin       .boutiqueManager        .customer
         │                     │                     │
   ┌─────▼──────┐       ┌─────▼──────┐       ┌─────▼──────┐
   │ AdminTabView│       │ManagerTab  │       │ MainTabView│
   │  (5 tabs)  │       │  (5 tabs)  │       │  (4 tabs)  │
   │            │       │            │       │            │
   │ Dashboard  │       │ Dashboard  │       │ Home       │
   │ Operations │       │ Operations │       │ Categories │
   │ Catalog    │       │ Staff      │       │ Wishlist   │
   │ Organiztn  │       │ Inventory  │       │ Profile    │
   │ Insights   │       │ Insights   │       └────────────┘
   └────────────┘       └────────────┘
         │                     │
   [Settings sheet]     [Profile sheet]
         │                     │
    [Sign Out]           [Sign Out]
         │                     │
         └──────────▶ Login ◀──┘
```

---

## Authentication Hierarchy (Role-Based Access)

```
Corporate Admin (admin@maisonluxe.com)
    │
    ├── Creates ──▶ Boutique Manager accounts
    │                    │
    │                    ├── Creates ──▶ Sales Associate accounts
    │                    │
    │                    └── Creates ──▶ Inventory Controller accounts
    │
    └── Creates ──▶ Service Technician accounts

Customers ──▶ Self-register via Sign Up screen
```

**Key Rule:** Staff NEVER sign up. They only log in with pre-provisioned credentials.

---

## Design System Summary

### Color Palette
| Token | Hex | Description |
|-------|-----|-------------|
| `primary` | `#0A0A0A` | Deep black |
| `accent` | `#C9A84C` | Champagne gold |
| `accentLight` | `#D4BC6A` | Lighter gold |
| `purple` | `#6B4C8A` | Muted regal purple |
| `purpleLight` | `#8B6FAE` | Light lavender |
| `purpleDark` | `#4A3066` | Deep plum |
| `backgroundPrimary` | `#0A0A0A` | Screen background |
| `backgroundSecondary` | `#151515` | Section background |
| `backgroundTertiary` | `#1E1A24` | Cards (purple tint) |
| `textPrimaryDark` | `#FAF8F0` | Ivory text |
| `textSecondaryDark` | `#9A9A9A` | Muted grey text |

### Typography
- **Display / Headings:** Didot (serif) — 18pt to 34pt
- **Body / Labels:** San Francisco (system) — 12pt to 17pt
- **Buttons:** San Francisco semibold — 14pt to 16pt

### Spacing
- 4pt grid system (xxs=4 → hero=48)
- Touch targets: 44pt minimum (Apple HIG)
- Screen padding: 20pt horizontal

---

## Files Implemented (Sprint 1 + Enterprise Admin v2 + Boutique Manager v1)

| Area | Files | Count |
|------|-------|-------|
| App Core | `infosys2App.swift`, `AppState.swift`, `RootView.swift` | 3 |
| Design System | `AppColors`, `AppTypography`, `AppSpacing`, `Color+Hex` | 4 |
| Components | `PrimaryButton`, `SecondaryButton`, `LuxuryTextField`, `LuxuryCardView`, `GoldDivider` | 5 |
| Splash | `SplashScreenView` | 1 |
| Onboarding | `OnboardingView`, `OnboardingPageView` | 2 |
| Auth | `LoginView`, `CustomerSignUpView`, `ForgotPasswordView`, `AuthViewModel`, `User` | 5 |
| Products | `Product`, `Category`, `SeedData`, `ProductListView`, `ProductDetailView` | 5 |
| Home | `HomeView` | 1 |
| Categories | `CategoriesView` | 1 |
| Wishlist | `WishlistView` | 1 |
| Profile | `ProfileView` | 1 |
| Navigation | `MainTabView`, `AdminTabView`, `ManagerTabView` | 3 |
| Admin Dashboard | `AdminDashboardView` | 1 |
| Admin Operations | `OperationsView` (Inventory, Distribution, Transfers) | 1 |
| Admin Catalog | `CatalogView` (Products, Categories, Pricing, Promos) | 1 |
| Admin Organization | `OrganizationView` (Boutiques, Staff, Roles) | 1 |
| Admin Insights | `InsightsView` (Analytics, Reports, Compliance) | 1 |
| Admin Profile | `AdminProfileView` (sheet from Dashboard) | 1 |
| Manager Dashboard | `ManagerDashboardView` | 1 |
| Manager Operations | `ManagerOperationsView` (Sales, Discrepancies, VIP, Activity) | 1 |
| Manager Staff | `ManagerStaffView` (Roster, Shifts, Performance) | 1 |
| Manager Inventory | `ManagerInventoryView` (Stock, Alerts, Transfers, Flagged) | 1 |
| Manager Insights | `ManagerInsightsView` (Revenue, Products, Staff) | 1 |
| Manager Profile | `ManagerProfileView` (sheet from Dashboard) | 1 |
| Legacy Admin (still in project) | `ProductManagementView`, `UserManagementView`, `StoreConfigView`, `AdminReportsView` | 4 |
| **Total** | | **48** |
