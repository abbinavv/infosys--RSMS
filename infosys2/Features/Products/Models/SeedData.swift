//
//  SeedData.swift
//  infosys2
//
//  Pre-populates the database with sample luxury products and categories.
//

import Foundation
import SwiftData

struct SeedData {

    static func seedIfNeeded(modelContext: ModelContext) {
        seedUsersIfNeeded(modelContext: modelContext)
        seedCatalogIfNeeded(modelContext: modelContext)
        try? modelContext.save()
    }

    // MARK: - Seed Users (independent check)

    private static func seedUsersIfNeeded(modelContext: ModelContext) {
        let userDescriptor = FetchDescriptor<User>()
        let existingUsers = (try? modelContext.fetchCount(userDescriptor)) ?? 0
        guard existingUsers == 0 else { return }

        let staffAccounts = [
            // Corporate Admin
            User(name: "Victoria Sterling", email: "admin@maisonluxe.com", phone: "+1-800-555-0001", passwordHash: "admin123", role: .corporateAdmin),

            // Boutique Managers
            User(name: "James Beaumont", email: "manager@maisonluxe.com", phone: "+1-800-555-0010", passwordHash: "manager123", role: .boutiqueManager),
            User(name: "Sophia Laurent", email: "sophia.l@maisonluxe.com", phone: "+1-800-555-0011", passwordHash: "manager123", role: .boutiqueManager),

            // Sales Associates
            User(name: "Alexander Chase", email: "sales@maisonluxe.com", phone: "+1-800-555-0020", passwordHash: "sales123", role: .salesAssociate),
            User(name: "Isabella Moreau", email: "isabella.m@maisonluxe.com", phone: "+1-800-555-0021", passwordHash: "sales123", role: .salesAssociate),

            // Inventory Controllers
            User(name: "Daniel Park", email: "inventory@maisonluxe.com", phone: "+1-800-555-0030", passwordHash: "inventory123", role: .inventoryController),

            // Service Technician
            User(name: "Marcus Webb", email: "service@maisonluxe.com", phone: "+1-800-555-0040", passwordHash: "service123", role: .serviceTechnician),

            // Demo Customer
            User(name: "Olivia Hartwell", email: "olivia@example.com", phone: "+1-555-123-4567", passwordHash: "customer123", role: .customer),
        ]

        for user in staffAccounts {
            modelContext.insert(user)
        }
    }

    // MARK: - Seed Catalog (independent check)

    private static func seedCatalogIfNeeded(modelContext: ModelContext) {
        let categoryDescriptor = FetchDescriptor<Category>()
        let existingCategories = (try? modelContext.fetchCount(categoryDescriptor)) ?? 0
        guard existingCategories == 0 else { return }

        // ── Seed categories ──────────────────────────────────────────
        let categories = [
            Category(name: "Handbags", icon: "bag.fill", description: "Exquisite leather handbags and clutches", displayOrder: 0),
            Category(name: "Watches", icon: "clock.fill", description: "Precision timepieces and luxury watches", displayOrder: 1),
            Category(name: "Jewelry", icon: "sparkles", description: "Fine jewelry and precious gemstones", displayOrder: 2),
            Category(name: "Accessories", icon: "eyeglasses", description: "Premium accessories and lifestyle pieces", displayOrder: 3),
            Category(name: "Limited Edition", icon: "star.fill", description: "Exclusive limited edition collections", displayOrder: 4),
        ]

        for category in categories {
            modelContext.insert(category)
        }

        // Seed products
        let products = [
            // Handbags
            Product(name: "Classic Flap Bag", brand: "Maison Luxe", description: "Timeless quilted leather bag with signature gold chain strap. Handcrafted by master artisans in Italian leather.", price: 4850, categoryName: "Handbags", imageName: "bag.fill", isFeatured: true, rating: 4.9, stockCount: 5),
            Product(name: "Leather Tote", brand: "Maison Luxe", description: "Spacious calfskin leather tote with suede interior lining and gold hardware details.", price: 3200, categoryName: "Handbags", imageName: "bag.fill", rating: 4.7, stockCount: 8),
            Product(name: "Mini Crossbody", brand: "Maison Luxe", description: "Compact crossbody bag in soft lambskin with adjustable chain strap.", price: 2450, categoryName: "Handbags", imageName: "bag.fill", rating: 4.8, stockCount: 12),

            // Watches
            Product(name: "Perpetual Chronograph", brand: "Maison Luxe", description: "Automatic chronograph with 18k gold case, sapphire crystal, and Swiss movement.", price: 12500, categoryName: "Watches", imageName: "clock.fill", isFeatured: true, rating: 5.0, stockCount: 3),
            Product(name: "Diamond Bezel Watch", brand: "Maison Luxe", description: "Ladies' watch with diamond-set bezel and mother of pearl dial.", price: 8900, categoryName: "Watches", imageName: "clock.fill", rating: 4.9, stockCount: 4),
            Product(name: "Sport Diver", brand: "Maison Luxe", description: "Professional dive watch with ceramic bezel and titanium case. Water resistant to 300m.", price: 6750, categoryName: "Watches", imageName: "clock.fill", rating: 4.6, stockCount: 7),

            // Jewelry
            Product(name: "Diamond Pendant", brand: "Maison Luxe", description: "Brilliant-cut diamond pendant on 18k white gold chain. 1.5 carat certified diamond.", price: 15800, categoryName: "Jewelry", imageName: "sparkles", isFeatured: true, rating: 5.0, stockCount: 2),
            Product(name: "Pearl Earrings", brand: "Maison Luxe", description: "South Sea pearl drop earrings with diamond accents in platinum setting.", price: 4200, categoryName: "Jewelry", imageName: "sparkles", rating: 4.8, stockCount: 6),
            Product(name: "Gold Bracelet", brand: "Maison Luxe", description: "Woven 18k rose gold bracelet with pavé diamond clasp.", price: 7500, categoryName: "Jewelry", imageName: "sparkles", rating: 4.7, stockCount: 5),

            // Accessories
            Product(name: "Silk Scarf", brand: "Maison Luxe", description: "Hand-rolled silk twill scarf with original artwork print. Made in France.", price: 890, categoryName: "Accessories", imageName: "eyeglasses", rating: 4.5, stockCount: 15),
            Product(name: "Leather Belt", brand: "Maison Luxe", description: "Reversible calfskin belt with signature gold buckle.", price: 650, categoryName: "Accessories", imageName: "eyeglasses", rating: 4.6, stockCount: 20),

            // Limited Edition
            Product(name: "Heritage Collection Bag", brand: "Maison Luxe", description: "Numbered limited edition bag celebrating 50 years of craftsmanship. Only 100 pieces worldwide.", price: 18500, categoryName: "Limited Edition", imageName: "star.fill", isLimitedEdition: true, isFeatured: true, rating: 5.0, stockCount: 1),
            Product(name: "Artisan Timepiece", brand: "Maison Luxe", description: "Hand-engraved platinum watch with enamel dial. Limited to 25 pieces.", price: 45000, categoryName: "Limited Edition", imageName: "star.fill", isLimitedEdition: true, rating: 5.0, stockCount: 1),
        ]

        for product in products {
            modelContext.insert(product)
        }
    }
}
