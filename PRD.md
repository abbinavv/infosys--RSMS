# Product Requirements Document (PRD)

## Retail Store Management System — iOS Application

**Product Name:** Maison Luxe RSMS
**Platform:** Native iOS (iPhone / iPad)
**Version:** 1.0.0 (Sprint 1 Complete)
**Date:** March 11, 2026
**Team:** Group 2

---

## Table of Contents

1. [Product Vision & Purpose](#1-product-vision--purpose)
2. [Scope & Definitions](#2-scope--definitions)
3. [Target Users & Roles](#3-target-users--roles)
4. [Technical Specifications](#4-technical-specifications)
5. [Architecture & Project Structure](#5-architecture--project-structure)
6. [Design System](#6-design-system)
7. [Data Models](#7-data-models)
8. [Seed Data & Test Accounts](#8-seed-data--test-accounts)
9. [Feature Modules — Detailed Requirements](#9-feature-modules--detailed-requirements)
10. [Screen Inventory](#10-screen-inventory)
11. [User Flows](#11-user-flows)
12. [Sprint Plan](#12-sprint-plan)
13. [Non-Functional Requirements](#13-non-functional-requirements)
14. [Future Roadmap](#14-future-roadmap)
15. [Submission Deliverables](#15-submission-deliverables)

---

## 1. Product Vision & Purpose

### 1.1 Vision

Maison Luxe RSMS is a **native iOS application** designed for a multi-country luxury goods retail chain (jewellery, watches, leather goods, couture). The system unifies store operations, clienteling, product lifecycle, omnichannel fulfilment, and after-sales services while preserving a high-touch luxury brand experience.

### 1.2 Purpose

The application serves as a **configurable product** adaptable to various luxury retail formats, store sizes, and regional compliance needs. Primary objectives:

| # | Objective |
|---|-----------|
| 1 | Centralized platform for product master data, pricing, inventory, and allocations across boutiques |
| 2 | Enable clienteling (client profiles, preferences, purchase history, wishlists) and VIP appointment management |
| 3 | Support retail POS with offline resilience and PCI-DSS compliant payments |
| 4 | Facilitate omnichannel operations: BOPIS, BORIS, endless aisle, ship-from-store |
| 5 | Implement RFID-enabled stock management for real-time visibility and cycle counts |
| 6 | Orchestrate after-sales services: repairs, authentication, warranty, valuations |
| 7 | Analytics and compliance reporting for sales, inventory, and client KPIs |
| 8 | AI-assisted recommendations (cross-sell/up-sell), client segmentation, demand forecasting |

### 1.3 Target Audience

Corporate retail teams, boutique managers, sales associates, inventory controllers, merchandisers, after-sales staff, finance, IT operations, and end customers.

---

## 2. Scope & Definitions

### 2.1 Definitions

| Term | Definition |
|------|-----------|
| **SKU** | Stock Keeping Unit — item-level product identifier |
| **RFID** | Radio Frequency Identification tag for item-level tracking |
| **Clienteling** | Sales approach centered on personal client relationships supported by data |
| **BOPIS** | Buy Online Pick-up In Store |
| **BORIS** | Buy Online Return In Store |
| **Endless Aisle** | Selling inventory not physically in-store via other locations/DC |
| **AST** | After-Sales Ticket (repairs / services / authentications) |
| **POS** | Point of Sale system |
| **OMS** | Order Management System for omnichannel orchestration |
| **RBAC** | Role-Based Access Control |

### 2.2 High-Level Feature Areas

1. **Store / Boutique Admin Management** — Dashboard, staff planning, assortment, inventory ops, client events
2. **Sales Associate & After-Sales Service** — Clienteling, POS, omnichannel, repairs, warranty
3. **Inventory Controller** — RFID scanning, transfers, cycle counts, audit trails, serialization
4. **Customer** — Product browsing, wishlist, orders, appointments, tracking

---

## 3. Target Users & Roles

### 3.1 Role Hierarchy

```
Corporate Admin (Enterprise Level)
├── Creates → Boutique Manager accounts
│   ├── Creates → Sales Associate accounts
│   ├── Creates → Inventory Controller accounts
│   └── Creates → Service Technician accounts
└── Manages → System-wide configuration

Customer (Self-Registration)
└── Signs up independently via the app
```

### 3.2 Role Definitions

| Role | Enum Value | Scope | Login Method |
|------|-----------|-------|-------------|
| **Corporate Admin** | `.corporateAdmin` | Enterprise-wide | Email + password (pre-provisioned) |
| **Boutique Manager** | `.boutiqueManager` | Single assigned boutique | Email + password (created by Admin) |
| **Sales Associate** | `.salesAssociate` | Assigned boutique, client-facing | Email + password (created by Manager) |
| **Inventory Controller** | `.inventoryController` | Assigned boutique, stock operations | Email + password (created by Manager) |
| **Service Technician** | `.serviceTechnician` | After-sales workshop | Email + password (created by Manager) |
| **Customer** | `.customer` | Personal shopping experience | Self-registration via Sign Up |

### 3.3 Authentication Model

- **Staff accounts** are created by admins/managers — staff do NOT self-register
- **Customer accounts** are created via the Sign Up flow
- All roles share a single login screen
- Role is detected from the `User` model after authentication
- Navigation is routed based on `UserRole` enum

---

## 4. Technical Specifications

### 4.1 Platform Requirements

| Specification | Value |
|--------------|-------|
| **Devices** | iPhone, iPad |
| **Minimum OS** | iOS 26+ |
| **Language** | Swift 6 |
| **UI Framework** | SwiftUI |
| **Data Persistence** | SwiftData (Core Data successor) |
| **Architecture** | MVVM with `@Observable` macro |
| **Concurrency** | Swift Concurrency (`@MainActor`) |
| **State Management** | `@Observable` + `@Environment` injection |
| **Build System** | Xcode 26.3+ |

### 4.2 Dependencies

| Dependency | Purpose |
|-----------|---------|
| SwiftUI | Declarative UI framework |
| SwiftData | Persistence and model layer |
| Foundation | Core utilities |

No external third-party dependencies. The application is built entirely with Apple first-party frameworks.

---

## 5. Architecture & Project Structure

### 5.1 MVVM Architecture

```
┌─────────────────────────────────────────────────┐
│                    View Layer                     │
│  SwiftUI Views (declarative, reactive)           │
├─────────────────────────────────────────────────┤
│                 ViewModel Layer                   │
│  @Observable classes (AuthViewModel, etc.)        │
├─────────────────────────────────────────────────┤
│                  Model Layer                      │
│  SwiftData @Model classes (User, Product, etc.)  │
├─────────────────────────────────────────────────┤
│                 Persistence                       │
│  ModelContainer → ModelContext → SQLite           │
└─────────────────────────────────────────────────┘
```

### 5.2 Folder Structure

```
infosys2/
├── infosys2App.swift                    # App entry point, ModelContainer setup
├── ContentView.swift                    # Default (unused)
├── Item.swift                           # Default SwiftData item (unused)
│
├── App/
│   ├── AppState.swift                   # @Observable central state (flow + auth)
│   └── RootView.swift                   # Flow-based root switch view
│
├── DesignSystem/
│   ├── Theme/
│   │   ├── AppColors.swift              # 30+ color tokens (hex-based)
│   │   ├── AppTypography.swift          # 40+ SF Pro font tokens
│   │   └── AppSpacing.swift             # 4pt grid spacing system
│   └── Components/
│       ├── PrimaryButton.swift          # Gold CTA button with loading state
│       ├── SecondaryButton.swift        # Gold-bordered outline button
│       ├── LuxuryTextField.swift        # Underline input with floating label
│       ├── LuxuryCardView.swift         # Elevated card with shadow
│       └── GoldDivider.swift            # Champagne gold separator
│
├── Extensions/
│   └── Color+Hex.swift                  # Hex string → Color initializer
│
├── Features/
│   ├── Splash/
│   │   └── SplashScreenView.swift       # Animated brand intro
│   ├── Onboarding/
│   │   ├── OnboardingView.swift         # 3-page pager with indicators
│   │   └── OnboardingPageView.swift     # Reusable page template
│   ├── Auth/
│   │   ├── Models/
│   │   │   └── User.swift               # @Model with UserRole enum
│   │   ├── ViewModels/
│   │   │   └── AuthViewModel.swift      # Login, signup, reset logic
│   │   └── Views/
│   │       ├── LoginView.swift          # Email + password login
│   │       ├── CustomerSignUpView.swift # Customer self-registration
│   │       └── ForgotPasswordView.swift # Password reset flow
│   ├── Home/
│   │   └── HomeView.swift               # Hero banner, categories, featured
│   ├── Categories/
│   │   └── CategoriesView.swift         # 2-column category grid
│   ├── Products/
│   │   ├── Models/
│   │   │   ├── Product.swift            # @Model for products
│   │   │   ├── Category.swift           # @Model for categories
│   │   │   └── SeedData.swift           # Database seeder
│   │   └── Views/
│   │       ├── ProductListView.swift    # Filtered grid with sort
│   │       └── ProductDetailView.swift  # Full detail with wishlist
│   ├── Wishlist/
│   │   └── WishlistView.swift           # Wishlisted items list
│   ├── Profile/
│   │   └── ProfileView.swift            # Customer profile + settings
│   ├── Admin/
│   │   ├── Dashboard/
│   │   │   └── AdminDashboardView.swift # Enterprise metrics + alerts
│   │   ├── Catalog/
│   │   │   └── CatalogView.swift        # SKUs, categories, pricing, promos
│   │   ├── Operations/
│   │   │   └── OperationsView.swift     # Inventory, DCs, transfers
│   │   ├── Organization/
│   │   │   └── OrganizationView.swift   # Boutiques, staff, RBAC
│   │   ├── Insights/
│   │   │   └── InsightsView.swift       # Analytics, reports, compliance
│   │   ├── Products/
│   │   │   └── ProductManagementView.swift  # (Legacy, replaced by Catalog)
│   │   ├── Users/
│   │   │   └── UserManagementView.swift     # (Legacy, replaced by Org)
│   │   ├── Stores/
│   │   │   └── StoreConfigView.swift        # (Legacy, replaced by Org)
│   │   ├── Reports/
│   │   │   └── AdminReportsView.swift       # (Legacy, replaced by Insights)
│   │   └── Profile/
│   │       └── AdminProfileView.swift       # Admin settings sheet
│   └── Manager/
│       ├── Dashboard/
│       │   └── ManagerDashboardView.swift   # Store KPIs + alerts
│       ├── Operations/
│       │   └── ManagerOperationsView.swift  # Sales, discrepancies, VIP
│       ├── Staff/
│       │   └── ManagerStaffView.swift       # Roster, shifts, performance
│       ├── Inventory/
│       │   └── ManagerInventoryView.swift   # Stock, alerts, transfers
│       ├── Insights/
│       │   └── ManagerInsightsView.swift    # Revenue, products, staff
│       └── Profile/
│           └── ManagerProfileView.swift     # Manager settings sheet
│
└── Navigation/
    ├── MainTabView.swift                # Customer: Home|Categories|Wishlist|Profile
    ├── AdminTabView.swift               # Admin: Dashboard|Operations|Catalog|Org|Insights
    └── ManagerTabView.swift             # Manager: Dashboard|Operations|Staff|Inventory|Insights
```

### 5.3 State Flow Diagram

```
App Launch
    │
    ▼
SplashScreenView (2.5s animated brand intro)
    │
    ▼
[hasCompletedOnboarding?]──No──→ OnboardingView (3 pages)
    │                                   │
   Yes                          completeOnboarding()
    │                                   │
    ▼                                   ▼
LoginView ◄─────────────────────────────┘
    │
    ▼
[AuthViewModel.login()]
    │
    ├── role == .corporateAdmin  ──→ AdminTabView (5 tabs)
    ├── role == .boutiqueManager ──→ ManagerTabView (5 tabs)
    └── role == .customer / other ──→ MainTabView (4 tabs)
```

---

## 6. Design System

### 6.1 Brand Identity

| Attribute | Value |
|-----------|-------|
| **Brand Name** | Maison Luxe |
| **Aesthetic** | Dark luxury — deep blacks, champagne gold, regal purple, ivory |
| **Inspiration** | Tom Ford, Versace, haute couture, Apple HIG |
| **Tagline** | "The Art of Luxury" |
| **Logo** | Diamond icon (SF Symbol: `diamond.fill`) with gold gradient |

### 6.2 Color Palette

#### Primary Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#0A0A0A` | Deep black — brand primary |
| `accent` | `#C9A84C` | Champagne gold — luxury highlight |
| `accentLight` | `#D4BC6A` | Gold for hover/pressed states |
| `accentDark` | `#A8893A` | Dark gold for contrast |

#### Purple Accent

| Token | Hex | Usage |
|-------|-----|-------|
| `purple` | `#6B4C8A` | Regal purple — secondary accent |
| `purpleLight` | `#8B6FAE` | Subtle highlights |
| `purpleDark` | `#4A3066` | Deep plum for depth |

#### Backgrounds

| Token | Hex | Usage |
|-------|-----|-------|
| `backgroundPrimary` | `#0A0A0A` | Screen backgrounds |
| `backgroundSecondary` | `#151515` | Sections / surfaces |
| `backgroundTertiary` | `#1E1A24` | Cards (purple-tinted) |
| `backgroundIvory` | `#FFFFF0` | Contrast highlights |

#### Text Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `textPrimaryDark` | `#FAF8F0` | Ivory — primary text on dark bg |
| `textSecondaryDark` | `#9A9A9A` | Muted grey — secondary text |

#### Semantic Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | `#4CAF7D` | Operational / in-stock |
| `error` | `#E05555` | Errors / out-of-stock |
| `warning` | `#D4A84C` | Low stock / caution |
| `info` | `#5C9BD6` | Informational |

### 6.3 Typography System

All text uses **SF Pro** (`.default` design) — Apple's native iOS typeface. No third-party fonts.

| Token | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 34pt | Bold | Hero headlines |
| `displayMedium` | 28pt | Bold | Section titles |
| `displaySmall` | 24pt | Semibold | Page titles |
| `heading1` | 22pt | Semibold | KPI values |
| `heading2` | 20pt | Semibold | Section headers |
| `heading3` | 18pt | Medium | Sub-headers |
| `bodyLarge` | 17pt | Regular | Long text |
| `bodyMedium` | 15pt | Regular | Standard body |
| `bodySmall` | 13pt | Regular | Compact text |
| `label` | 14pt | Medium | Labels / row titles |
| `caption` | 12pt | Regular | Metadata |
| `overline` | 10pt | Semibold | Tags / badges |
| `buttonPrimary` | 16pt | Semibold | CTA buttons |
| `navTitle` | 18pt | Semibold | Nav bar titles |
| `priceDisplay` | 22pt | Semibold | Hero prices |

40+ total tokens covering display, heading, body, button, price, icon, and utility categories.

### 6.4 Spacing System

4-point grid system following Apple HIG:

| Token | Value | Usage |
|-------|-------|-------|
| `xxs` | 4pt | Minimal gaps |
| `xs` | 8pt | Tight spacing |
| `sm` | 12pt | Compact spacing |
| `md` | 16pt | Standard spacing |
| `lg` | 20pt | Section spacing |
| `xl` | 24pt | Large spacing |
| `xxl` | 32pt | Major sections |
| `xxxl` | 40pt | Hero spacing |
| `touchTarget` | 44pt | Apple minimum touch target |
| `radiusSmall` | 8pt | Small corners |
| `radiusMedium` | 12pt | Standard corners |
| `radiusLarge` | 16pt | Card corners |

### 6.5 Reusable Components

| Component | Description | Key Props |
|-----------|-------------|-----------|
| **PrimaryButton** | Gold-filled CTA | `title`, `isLoading`, `action` |
| **SecondaryButton** | Gold-outlined button | `title`, `action` |
| **LuxuryTextField** | Underline input with floating label | `placeholder`, `text`, `icon`, `isSecure` |
| **LuxuryCardView** | Elevated card wrapper | Generic `content` |
| **GoldDivider** | Thin gold separator | `opacity` |

---

## 7. Data Models

### 7.1 User Model

```
@Model User
├── id: UUID (primary key)
├── name: String
├── email: String (unique, used for login)
├── phone: String
├── passwordHash: String
├── roleRaw: String (persisted enum backing)
├── role: UserRole (computed get/set)
├── createdAt: Date
└── isActive: Bool
```

**UserRole Enum:**

```
enum UserRole: String, Codable, CaseIterable
├── customer = "Customer"
├── salesAssociate = "Sales Associate"
├── inventoryController = "Inventory Controller"
├── boutiqueManager = "Boutique Manager"
├── corporateAdmin = "Corporate Admin"
└── serviceTechnician = "Service Technician"
```

### 7.2 Product Model

```
@Model Product
├── id: UUID (primary key)
├── name: String
├── brand: String
├── productDescription: String
├── price: Double
├── categoryName: String (relationship via name)
├── imageName: String (SF Symbol name)
├── isLimitedEdition: Bool
├── isFeatured: Bool
├── isWishlisted: Bool (user-toggleable)
├── rating: Double (0.0–5.0)
├── stockCount: Int
├── createdAt: Date
└── formattedPrice: String (computed, USD formatter)
```

### 7.3 Category Model

```
@Model Category
├── id: UUID (primary key)
├── name: String
├── icon: String (SF Symbol name)
├── categoryDescription: String
└── displayOrder: Int (sort key)
```

### 7.4 Schema Configuration

```swift
Schema([Item.self, User.self, Product.self, Category.self])
ModelConfiguration(isStoredInMemoryOnly: false)  // Persisted to disk
```

---

## 8. Seed Data & Test Accounts

### 8.1 Seeding Strategy

The `SeedData.seedIfNeeded()` method runs on app launch. It performs two independent checks:

1. **Users seed** — inserts staff accounts if user count == 0
2. **Catalog seed** — inserts categories + products if category count == 0

This ensures users and catalog can be seeded independently.

### 8.2 Pre-Seeded User Accounts

| Name | Email | Password | Role |
|------|-------|----------|------|
| Victoria Sterling | `admin@maisonluxe.com` | `admin123` | Corporate Admin |
| James Beaumont | `manager@maisonluxe.com` | `manager123` | Boutique Manager |
| Sophia Laurent | `sophia.l@maisonluxe.com` | `manager123` | Boutique Manager |
| Alexander Chase | `sales@maisonluxe.com` | `sales123` | Sales Associate |
| Isabella Moreau | `isabella.m@maisonluxe.com` | `sales123` | Sales Associate |
| Daniel Park | `inventory@maisonluxe.com` | `inventory123` | Inventory Controller |
| Marcus Webb | `service@maisonluxe.com` | `service123` | Service Technician |
| Olivia Hartwell | `olivia@example.com` | `customer123` | Customer |

### 8.3 Pre-Seeded Categories

| Category | Icon | Display Order |
|----------|------|--------------|
| Handbags | `bag.fill` | 0 |
| Watches | `clock.fill` | 1 |
| Jewelry | `sparkles` | 2 |
| Accessories | `eyeglasses` | 3 |
| Limited Edition | `star.fill` | 4 |

### 8.4 Pre-Seeded Products (13 SKUs)

| Product | Category | Price | Featured | Limited | Stock |
|---------|----------|-------|----------|---------|-------|
| Classic Flap Bag | Handbags | $4,850 | ✓ | | 5 |
| Leather Tote | Handbags | $3,200 | | | 8 |
| Mini Crossbody | Handbags | $2,450 | | | 12 |
| Perpetual Chronograph | Watches | $12,500 | ✓ | | 3 |
| Diamond Bezel Watch | Watches | $8,900 | | | 4 |
| Sport Diver | Watches | $6,750 | | | 7 |
| Diamond Pendant | Jewelry | $15,800 | ✓ | | 2 |
| Pearl Earrings | Jewelry | $4,200 | | | 6 |
| Gold Bracelet | Jewelry | $7,500 | | | 5 |
| Silk Scarf | Accessories | $890 | | | 15 |
| Leather Belt | Accessories | $650 | | | 20 |
| Heritage Collection Bag | Limited Edition | $18,500 | ✓ | ✓ | 1 |
| Artisan Timepiece | Limited Edition | $45,000 | | ✓ | 1 |

---

## 9. Feature Modules — Detailed Requirements

### 9.1 Entry Experience (All Users)

#### 9.1.1 Splash Screen

| Requirement | Implementation |
|-------------|---------------|
| Display brand logo centered on dark background | Diamond icon with gold gradient on `#0A0A0A` |
| Animated entry (fade + scale) | `scaleEffect`, `opacity`, `rotationEffect` animations |
| Brand name reveal | "MAISON LUXE" with letter tracking |
| Tagline reveal | "The Art of Luxury" fade-in |
| Gold divider animation | Horizontal line width expansion |
| Auto-advance after 2.5s | `DispatchQueue.main.asyncAfter` → `completeSplash()` |

#### 9.1.2 Onboarding (3 Pages)

| Page | Title | Subtitle | Icon |
|------|-------|----------|------|
| 1 | Discover Luxury Collections | Explore curated collections of the finest luxury goods | `diamond.fill` |
| 2 | Personalized Experience | Receive tailored recommendations and exclusive access | `person.crop.circle.fill` |
| 3 | Seamless Management | Book appointments, track orders, manage your collection | `sparkles.rectangle.stack.fill` |

Features:
- Horizontal `TabView` with `.page` style
- Custom gold dot indicators
- "Skip" button (top-right)
- "Get Started" button on final page
- `UserDefaults` persistence for completion state

#### 9.1.3 Authentication

**Login Screen:**
- Email / Employee ID field with `envelope` icon
- Password field (secure) with `lock` icon
- "Sign In" primary button with loading spinner
- "Forgot Password?" link → sheet
- "Create Account" link → sheet (customers only)
- "Employee accounts are created by your organization" notice
- Error handling: invalid credentials, no account found
- Role-based routing on successful authentication

**Customer Sign Up Screen:**
- Full name, email, phone, password, confirm password fields
- Password validation (min 6 chars, match confirmation)
- "Create Account" button → inserts `User` with `.customer` role
- Auto-login after successful registration

**Forgot Password Screen:**
- Email input field
- "Send Reset Link" button
- Success confirmation alert
- Close button (xmark) in toolbar

### 9.2 Customer Experience

#### 9.2.1 Navigation Structure

```
MainTabView (4 tabs)
├── Tab 0: Home (house.fill)
├── Tab 1: Categories (square.grid.2x2.fill)
├── Tab 2: Wishlist (heart.fill)
└── Tab 3: Profile (person.fill)
```

Tab bar: Dark background (`#0A0A0A`), gold selected tint, grey unselected.

#### 9.2.2 Home Screen

| Section | Description |
|---------|-------------|
| **Navigation Bar** | "MAISON LUXE" logo (left), bell icon (right) |
| **Hero Banner** | Linear gradient background, "NEW COLLECTION", "Spring 2026", decorative diamond watermark, "Explore →" CTA |
| **Category Strip** | Horizontal scroll of circle icons with category names |
| **Featured Products** | Horizontal scroll of `LuxuryCardView` product cards |
| **New Arrivals** | Vertical list of product rows with image, brand, name, price |

Data: `@Query(filter: #Predicate<Product> { $0.isFeatured == true })` for featured, `@Query(sort: \Category.displayOrder)` for categories.

#### 9.2.3 Categories Screen

| Feature | Detail |
|---------|--------|
| 2-column LazyVGrid of category cards | Each card: icon circle + gold accent ring + purple outer ring + name + description |
| Navigation | Tap → `ProductListView(categoryFilter: name)` |
| Data | `@Query(sort: \Category.displayOrder)` |

#### 9.2.4 Product List Screen

| Feature | Detail |
|---------|--------|
| **Filter** | By category name passed from parent |
| **Sort** | Menu: Featured First / Price: Low to High / Price: High to Low / Newest |
| **Grid** | 2-column `LazyVGrid` of product tiles |
| **Product Tile** | Image placeholder, wishlist heart (toggleable), LIMITED badge, brand, name, price |
| **Navigation** | Tap → `ProductDetailView(product:)` |

#### 9.2.5 Product Detail Screen

| Section | Detail |
|---------|--------|
| **Hero Image** | Full-width 380pt image area with SF Symbol placeholder |
| **Limited Badge** | Gold "LIMITED EDITION" overlay (if applicable) |
| **Brand & Name** | Overline brand, display title |
| **Rating** | 5-star display with numeric value |
| **Price** | Hero price with stock status indicator (green/yellow/red dot) |
| **Description** | Full product description with line spacing |
| **Details** | Key-value pairs: Brand, Category, Availability, Collection |
| **Action Bar** | Floating bottom bar: wishlist heart + "Add to Bag" primary button |

Wishlist toggle persists via `modelContext.save()`.

#### 9.2.6 Wishlist Screen

| Feature | Detail |
|---------|--------|
| **Empty State** | Heart icon in accent circle, "Your Wishlist is Empty" message |
| **List** | Product rows with image, brand, name, price, stock status |
| **Remove** | Heart.fill button removes from wishlist |
| **Navigate** | Tap row → `ProductDetailView` |
| **Data** | `@Query(filter: #Predicate<Product> { $0.isWishlisted == true })` |

#### 9.2.7 Profile Screen

| Section | Detail |
|---------|--------|
| **Avatar** | Initials circle with gold ring + purple outer ring |
| **User Info** | Name, email, role badge |
| **Menu Items** | Order History, Appointments, Addresses, Payment Methods, Preferences, Help & Support |
| **Sign Out** | Confirmation alert → `appState.logout()` |
| **Version** | "Version 1.0.0" footer |

### 9.3 Corporate Admin Experience

#### 9.3.1 Navigation Structure

```
AdminTabView (5 tabs)
├── Tab 0: Dashboard (chart.bar.fill)
├── Tab 1: Operations (shippingbox.fill)
├── Tab 2: Catalog (tag.fill)
├── Tab 3: Organization (building.2.fill)
└── Tab 4: Insights (chart.pie.fill)
```

Settings accessed as sheet from Dashboard avatar button.

#### 9.3.2 Dashboard (`AdminDashboardView`)

| Section | Content |
|---------|---------|
| **Welcome Header** | "Good Morning/Afternoon/Evening, [FirstName]" + "CORPORATE ADMIN" badge + date |
| **Metrics Grid (2×3)** | Total Revenue ($2.4M), Active SKUs (live `@Query` count), Total Users (live count), Boutiques (4), Low Stock (computed), Total Units (computed) — each with trend badge |
| **System Health** | 4 status pills: API ✓, Database ✓, Payments ✓, Sync ⚠ |
| **Alerts** | 3 priority alerts with color-coded severity bars (Critical/Warning/Info) |
| **Quick Actions (2×3)** | Add SKU, Add Staff, Add Store, Transfer, Promotion, Report |
| **Activity Feed** | Chronological list: SKU Created, Price Override, Staff Provisioned, Stock Transfer |

**Live Data:** Metrics grid uses `@Query` to show real-time product/user counts from SwiftData.

#### 9.3.3 Operations (`OperationsView`)

Segmented: `Inventory` | `Distribution` | `Transfers`

| Segment | Content |
|---------|---------|
| **Inventory** | Searchable product list sorted by stock (ascending), "Reorder" button for low-stock items |
| **Distribution** | 2 DC cards (East Coast Hub, European Hub) with capacity/utilization bars |
| **Transfers** | Transfer tracking cards with status badges (In Transit / Delivered / Pending) |

#### 9.3.4 Catalog (`CatalogView`)

Segmented: `Products` | `Categories` | `Pricing` | `Promos`

| Segment | Content |
|---------|---------|
| **Products** | Searchable SKU list with search bar, category filter chips, stock/price display, ⋯ menu (Edit/Price/Stock/Delete), + create new product sheet |
| **Categories** | Category cards with product count, manage display order |
| **Pricing** | Config cards: Base Currency (USD), Tax Configuration, Discount Rules |
| **Promos** | Promotion cards: Spring Gala (Active), Summer (Scheduled), VIP (Draft) with lifecycle status badges |

**Create Product Sheet:** Full form with category picker, text fields (name, brand, description, price, stock), limited/featured toggles, validation.

#### 9.3.5 Organization (`OrganizationView`)

Segmented: `Boutiques` | `Staff` | `Roles`

| Segment | Content |
|---------|---------|
| **Boutiques** | 4 boutique cards (Fifth Avenue, Rodeo Drive, Champs-Élysées, Ginza) with location, manager, revenue, staff count, status |
| **Staff** | Searchable user list with role filter chips, role-colored avatar circles, ⋯ menu (Edit/Reset Password/Deactivate), + create staff account |
| **Roles** | RBAC permission matrix per role (Admin, Manager, Sales, Inventory, Service) with toggle rows per permission |

#### 9.3.6 Insights (`InsightsView`)

Segmented: `Analytics` | `Reports` | `Compliance`

| Segment | Content |
|---------|---------|
| **Analytics** | Period selector, $2.4M revenue hero, daily bar chart (10 bars), top 5 products, category revenue bars |
| **Reports** | 7 report links: Daily Sales, Monthly Revenue, Inventory Valuation, Staff Performance, Tax Compliance, Shrink Analysis, Audit Trail |
| **Compliance** | 5 audit checks (PCI-DSS, GDPR, Tax Compliance, Inventory Audit, Access Review) with status badges, recent access log entries |

#### 9.3.7 Admin Profile (Sheet)

| Section | Content |
|---------|---------|
| **Profile Header** | Avatar with initials, name, email, "CORPORATE ADMIN" badge |
| **Account** | Edit Profile, Change Password |
| **System Security** | Role-Based Access Control, Access Logs, Audit Trail |
| **System** | Notification Preferences, System Configuration |
| **Sign Out** | Confirmation alert |

### 9.4 Boutique Manager Experience

#### 9.4.1 Navigation Structure

```
ManagerTabView (5 tabs)
├── Tab 0: Dashboard (chart.bar.fill)
├── Tab 1: Operations (bag.fill)
├── Tab 2: Staff (person.2.fill)
├── Tab 3: Inventory (shippingbox.fill)
└── Tab 4: Insights (chart.pie.fill)
```

Profile accessed as sheet from Dashboard avatar button.

#### 9.4.2 Dashboard (`ManagerDashboardView`)

| Section | Content |
|---------|---------|
| **Daily Sales Strip** | 3-stat horizontal strip: Today's Revenue ($42.8K), Transactions (7), Avg. Ticket ($6,114) |
| **Store KPIs (2×2)** | Conversion Rate (38%), Units Sold (23), VIP Appointments (3), Active Staff (5) |
| **Alerts** | Low stock warnings, discrepancy flags, VIP reminders |
| **Top Products Today** | Horizontal scroll of top-selling product chips |
| **Staff on Floor** | Avatar circles of currently active staff with role colors |
| **Quick Actions (2×3)** | View Sales, Resolve Discrepancy, VIP Schedule, Request Transfer, Staff Schedule, Daily Report |

#### 9.4.3 Operations (`ManagerOperationsView`)

Segmented: `Sales` | `Discrepancies` | `VIP Events` | `Activity`

| Segment | Content |
|---------|---------|
| **Sales** | Transaction cards with TXN-ID, customer name, associate, amount, item count |
| **Discrepancies** | System-vs-counted stock discrepancy cards with "Approve" action button |
| **VIP Events** | Appointment cards with client name, date, type, assigned associate |
| **Activity** | Chronological store activity log entries |

#### 9.4.4 Staff (`ManagerStaffView`)

Segmented: `Roster` | `Shifts` | `Performance`

| Segment | Content |
|---------|---------|
| **Roster** | Staff cards with role-colored avatars, name, role, on-floor status indicator |
| **Shifts** | Daily shift schedule cards with time ranges, role, status |
| **Performance** | Sales leaderboard with rank, revenue, transactions, conversion rate |

#### 9.4.5 Inventory (`ManagerInventoryView`)

Segmented: `Stock` | `Alerts` | `Transfers` | `Flagged`

| Segment | Content |
|---------|---------|
| **Stock** | Full inventory list with search, 3 stat cards (Total Units, Low Stock, Out of Stock — all live `@Query`), sorted by stock ascending |
| **Alerts** | Low-stock product cards with "Request Restock" button |
| **Transfers** | Inbound/outbound transfer tracking cards with status |
| **Flagged** | Quality issue cards with "Review" action button |

#### 9.4.6 Insights (`ManagerInsightsView`)

Segmented: `Revenue` | `Products` | `Staff`

| Segment | Content |
|---------|---------|
| **Revenue** | Period selector, $248,600 revenue hero with trend arrow, daily trend bars, target progress bars (Monthly Target, Avg. Ticket, Transactions) |
| **Products** | Top 5 sellers ranked, category mix percentage bars, slow movers with "Low demand" badges |
| **Staff** | Sales leaderboard with revenue/transactions, conversion rates with trend badges, attendance records with late indicators |

#### 9.4.7 Manager Profile (Sheet)

| Section | Content |
|---------|---------|
| **Profile Header** | Avatar with purple ring, name, email, "BOUTIQUE MANAGER" badge, store assignment |
| **Store Info** | Boutique Name, Location, Staff Count |
| **Settings** | Notifications, Shift Preferences, Support |
| **Sign Out** | Confirmation alert |

---

## 10. Screen Inventory

### 10.1 Complete Screen Count

| Category | Screens | Count |
|----------|---------|-------|
| Entry Experience | Splash, Onboarding, Login, Sign Up, Forgot Password | 5 |
| Customer | Home, Categories, ProductList, ProductDetail, Wishlist, Profile | 6 |
| Corporate Admin | Dashboard, Operations, Catalog, Organization, Insights, Profile (sheet) | 6 |
| Boutique Manager | Dashboard, Operations, Staff, Inventory, Insights, Profile (sheet) | 6 |
| **Total** | | **23** |

### 10.2 Navigation Tab Views

| Tab View | Tabs | Target Role |
|----------|------|-------------|
| `MainTabView` | Home \| Categories \| Wishlist \| Profile | Customer (+ Sales, Inventory, Service) |
| `AdminTabView` | Dashboard \| Operations \| Catalog \| Organization \| Insights | Corporate Admin |
| `ManagerTabView` | Dashboard \| Operations \| Staff \| Inventory \| Insights | Boutique Manager |

---

## 11. User Flows

### 11.1 First-Time User Flow

```
App Install → Launch
  → Splash Screen (2.5s animation)
  → Onboarding (3 swipe pages)
  → "Get Started" button
  → Login Screen
  → Create Account (customer) OR Login (all roles)
  → Role-based dashboard
```

### 11.2 Returning User Flow

```
App Launch
  → Splash Screen (2.5s)
  → Login Screen (onboarding skipped)
  → Enter credentials
  → Role-based dashboard
```

### 11.3 Customer Shopping Flow

```
Login → Home
  → Browse hero banner / featured products
  → Tap category → Product List (filtered)
  → Sort by price/featured/newest
  → Tap product → Product Detail
  → Toggle wishlist heart
  → Tap "Add to Bag" (placeholder for Sprint 2)
  → Navigate to Wishlist tab → review saved items
  → Profile → Sign Out
```

### 11.4 Corporate Admin Flow

```
Login (admin@maisonluxe.com)
  → Admin Dashboard
  → Review KPIs, alerts, activity
  → Quick Action: "Add SKU" → Catalog tab → Create Product
  → Quick Action: "Add Staff" → Organization tab → Staff → Create
  → Operations → Inventory → Reorder low-stock items
  → Insights → Reports → Generate report
  → Avatar → Profile sheet → Sign Out
```

### 11.5 Boutique Manager Flow

```
Login (manager@maisonluxe.com)
  → Manager Dashboard
  → Review daily sales, store KPIs, alerts
  → Quick Action: "View Sales" → Operations → Sales tab
  → Quick Action: "Resolve Discrepancy" → Operations → Discrepancies
  → Staff → Roster / Shifts / Performance
  → Inventory → Stock levels / Transfer requests
  → Insights → Revenue trends / Product performance / Staff productivity
  → Avatar → Profile sheet → Sign Out
```

### 11.6 Password Reset Flow

```
Login Screen → "Forgot Password?" link
  → ForgotPasswordView (sheet)
  → Enter email
  → "Send Reset Link"
  → Success alert → Dismiss sheet → Back to Login
```

---

## 12. Sprint Plan

### Sprint 1 — Foundation & Entry Experience ✅ COMPLETE

| Deliverable | Status |
|-------------|--------|
| Design system (colors, typography, spacing, components) | ✅ |
| Splash screen with brand animation | ✅ |
| 3-page onboarding flow | ✅ |
| Login / Sign Up / Forgot Password | ✅ |
| Role-based authentication & routing | ✅ |
| Customer tab navigation (Home, Categories, Wishlist, Profile) | ✅ |
| Product browsing (list + detail) | ✅ |
| Wishlist with SwiftData persistence | ✅ |
| Corporate Admin dashboard (5-tab enterprise console) | ✅ |
| Boutique Manager dashboard (5-tab store operations) | ✅ |
| Seed data (8 users, 5 categories, 13 products) | ✅ |
| SF Pro typography system (40+ tokens, zero inline fonts) | ✅ |

### Sprint 2 — Cart, Checkout & Clienteling (Planned)

| Deliverable | Status |
|-------------|--------|
| Shopping cart model + UI | 🔲 |
| Checkout flow (address, payment method, order confirmation) | 🔲 |
| Order model + order history screen | 🔲 |
| Client profile management (for Sales Associates) | 🔲 |
| Appointment booking system | 🔲 |
| Push notification structure | 🔲 |

### Sprint 3 — Inventory & POS (Planned)

| Deliverable | Status |
|-------------|--------|
| Barcode / RFID scanning (Camera + Vision framework) | 🔲 |
| Stock receiving with ASN verification | 🔲 |
| Cycle count workflow | 🔲 |
| POS checkout (split tenders, tax-free, gift receipts) | 🔲 |
| Exchanges & returns processing | 🔲 |
| Inter-store transfer execution | 🔲 |

### Sprint 4 — After-Sales & Omnichannel (Planned)

| Deliverable | Status |
|-------------|--------|
| After-Sales Ticket (AST) creation | 🔲 |
| Repair workflow (estimation → approval → stages → QA → completion) | 🔲 |
| Warranty validation & authentication | 🔲 |
| BOPIS / BORIS / Endless Aisle flows | 🔲 |
| Ship-from-store packing slips | 🔲 |
| Client notifications (order + repair status) | 🔲 |

### Sprint 5 — Analytics & AI (Planned)

| Deliverable | Status |
|-------------|--------|
| Enterprise analytics with live SwiftData queries | 🔲 |
| Core ML recommendations (cross-sell / up-sell) | 🔲 |
| Client segmentation | 🔲 |
| Demand forecasting | 🔲 |
| Compliance & audit report generation | 🔲 |
| Export functionality (PDF/CSV) | 🔲 |

---

## 13. Non-Functional Requirements

### 13.1 Performance

| Requirement | Target |
|-------------|--------|
| App launch to splash | < 1 second |
| Splash to interactive | < 3 seconds |
| Screen transition | < 300ms |
| SwiftData query response | < 100ms |
| Memory usage | Zero leaks (Instruments validated) |
| Constraint issues | Zero warnings, zero conflicts |
| Scrolling frame rate | 60fps minimum |

### 13.2 Security

| Requirement | Implementation |
|-------------|---------------|
| Secure authentication | Password-based login with hashed storage |
| Role-based access control | `UserRole` enum enforced at routing level |
| Data encryption | SwiftData default encryption at rest |
| No hardcoded secrets | Credentials stored in `User` model only |
| GDPR compliance | User data deletion via profile (planned) |
| Session management | `AppState.logout()` clears all session data |

**Future enhancements:** Passkeys (iOS 26), biometric auth (Face ID / Touch ID), 2FA, PCI-DSS payment compliance.

### 13.3 Usability

| Requirement | Implementation |
|-------------|---------------|
| Apple HIG compliance | Native iOS tab bars, navigation stacks, sheets, alerts |
| Touch targets | Minimum 44pt per Apple HIG (`AppSpacing.touchTarget`) |
| Typography readability | SF Pro at Apple-recommended sizes |
| Color contrast | WCAG AA — ivory text on dark backgrounds |
| Loading states | Button spinners, progress indicators |
| Error feedback | Inline error messages, alert dialogs |
| Empty states | Illustrated empty state views (wishlist, etc.) |

### 13.4 Scalability

| Requirement | Detail |
|-------------|--------|
| Modular architecture | Feature-based folder structure, each feature independent |
| Extensible role system | `UserRole` enum supports adding new roles |
| Navigation scalability | Each role has its own `TabView`; new roles get new tab views |
| Design token system | Colors, fonts, spacing centralized — single-point changes propagate globally |
| SwiftData schema | `@Model` classes support migration via `VersionedSchema` |

### 13.5 Reliability

| Requirement | Target |
|-------------|--------|
| Crash rate | < 0.1% |
| Data persistence | All models persisted to disk via SwiftData |
| Offline support | Core browsing works offline (local data) |
| Error handling | `do/catch` on all SwiftData operations |
| State recovery | `AppState` rebuilt from persisted auth state |

### 13.6 Accessibility

| Requirement | Implementation |
|-------------|---------------|
| VoiceOver support | Native SwiftUI semantic elements |
| Dynamic Type | System font (SF Pro) scales with user preferences |
| Color blind safety | Semantic colors + icon indicators (not color-only) |
| Reduce Motion | SwiftUI `animation` respects system setting |
| Minimum tap targets | 44×44pt enforced via `AppSpacing.touchTarget` |

---

## 14. Future Roadmap

### Phase 2 — Commerce

- Shopping cart + checkout
- Payment integration (Stripe / Apple Pay)
- Order management + tracking
- Digital receipts

### Phase 3 — Clienteling & CRM

- Client profiles with preferences, sizes, anniversaries
- Purchase history analytics
- VIP appointment booking with calendar integration
- Remote selling (video consults, curated carts)

### Phase 4 — Operations

- RFID scanning via NFC
- Barcode scanning via camera + Vision framework
- Real-time inventory sync
- Transfer execution workflow
- POS with split tenders

### Phase 5 — After-Sales

- Repair intake + workflow engine
- Warranty registration + validation
- Authentication certificates
- Service payment collection

### Phase 6 — Intelligence

- Core ML product recommendations
- Client segmentation engine
- Demand forecasting
- Automated reorder suggestions
- Natural language search

---

## 15. Submission Deliverables

| Deliverable | Format | Status |
|-------------|--------|--------|
| **Codebase** | GitHub repository (`abbinavv/infosys--RSMS`) | ✅ Pushed |
| **PRD** | `PRD.md` in repository root | ✅ This document |
| **SRS** | Software Requirements Specification | ✅ Provided |
| **User Flows** | `USER_FLOWS.md` in repository root | ✅ Complete |
| **App Video Demo** | Screen recording of all flows | 🔲 Pending |
| **Memory Profile Screenshot** | Instruments leak/allocation report | 🔲 Pending |
| **Flow Diagram** | Visual navigation + state flow diagram | 🔲 Pending |

---

## Appendix A — File Manifest

| # | File | Lines | Purpose |
|---|------|-------|---------|
| 1 | `infosys2App.swift` | 48 | App entry, ModelContainer, seed |
| 2 | `AppState.swift` | 80 | Observable state, flow routing |
| 3 | `RootView.swift` | 44 | Flow switch view |
| 4 | `AppColors.swift` | 95 | 30+ color tokens |
| 5 | `AppTypography.swift` | 253 | 40+ SF Pro font tokens |
| 6 | `AppSpacing.swift` | 63 | 4pt grid spacing system |
| 7 | `Color+Hex.swift` | 25 | Hex → Color extension |
| 8 | `PrimaryButton.swift` | ~50 | Gold CTA component |
| 9 | `SecondaryButton.swift` | ~45 | Outline button component |
| 10 | `LuxuryTextField.swift` | ~55 | Floating label input |
| 11 | `LuxuryCardView.swift` | ~30 | Elevated card wrapper |
| 12 | `GoldDivider.swift` | ~15 | Gold separator |
| 13 | `User.swift` | 54 | User model + UserRole enum |
| 14 | `Product.swift` | 61 | Product model |
| 15 | `Category.swift` | 27 | Category model |
| 16 | `SeedData.swift` | 104 | Database seeder |
| 17 | `AuthViewModel.swift` | 145 | Login/signup/reset logic |
| 18 | `SplashScreenView.swift` | 129 | Animated brand intro |
| 19 | `OnboardingView.swift` | 107 | 3-page pager |
| 20 | `OnboardingPageView.swift` | 112 | Page template |
| 21 | `LoginView.swift` | 159 | Email + password login |
| 22 | `CustomerSignUpView.swift` | 133 | Customer registration |
| 23 | `ForgotPasswordView.swift` | 105 | Password reset |
| 24 | `HomeView.swift` | 322 | Hero + categories + featured |
| 25 | `CategoriesView.swift` | 118 | Category grid |
| 26 | `ProductListView.swift` | 189 | Filtered product grid |
| 27 | `ProductDetailView.swift` | 205 | Full product detail |
| 28 | `WishlistView.swift` | 162 | Wishlist list |
| 29 | `ProfileView.swift` | 170 | Customer profile |
| 30 | `AdminDashboardView.swift` | 375 | Enterprise metrics dashboard |
| 31 | `OperationsView.swift` | ~280 | Admin inventory/DC/transfers |
| 32 | `CatalogView.swift` | 315 | Admin SKU/category/pricing/promos |
| 33 | `OrganizationView.swift` | ~320 | Admin boutiques/staff/RBAC |
| 34 | `InsightsView.swift` | ~300 | Admin analytics/reports/compliance |
| 35 | `AdminProfileView.swift` | ~120 | Admin settings sheet |
| 36 | `ProductManagementView.swift` | 363 | (Legacy) Product CRUD |
| 37 | `UserManagementView.swift` | ~250 | (Legacy) User CRUD |
| 38 | `StoreConfigView.swift` | 255 | (Legacy) Store config |
| 39 | `AdminReportsView.swift` | ~200 | (Legacy) Reports |
| 40 | `ManagerDashboardView.swift` | ~350 | Store performance dashboard |
| 41 | `ManagerOperationsView.swift` | ~300 | Sales/discrepancies/VIP/activity |
| 42 | `ManagerStaffView.swift` | ~280 | Roster/shifts/performance |
| 43 | `ManagerInventoryView.swift` | ~300 | Stock/alerts/transfers/flagged |
| 44 | `ManagerInsightsView.swift` | 294 | Revenue/products/staff insights |
| 45 | `ManagerProfileView.swift` | 165 | Manager settings sheet |
| 46 | `MainTabView.swift` | ~75 | Customer tab bar |
| 47 | `AdminTabView.swift` | ~75 | Admin tab bar |
| 48 | `ManagerTabView.swift` | ~75 | Manager tab bar |

**Total Swift files:** 48+
**Total lines of code:** ~9,700+

---

*Document generated: March 11, 2026*
*Maison Luxe RSMS v1.0.0 — Sprint 1 Complete*
