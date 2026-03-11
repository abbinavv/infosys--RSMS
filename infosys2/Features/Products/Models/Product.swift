//
//  Product.swift
//  infosys2
//
//  SwiftData model for luxury products.
//

import Foundation
import SwiftData

@Model
final class Product {
    var id: UUID
    var name: String
    var brand: String
    var productDescription: String
    var price: Double
    var categoryName: String
    var imageName: String
    var isLimitedEdition: Bool
    var isFeatured: Bool
    var isWishlisted: Bool
    var rating: Double
    var stockCount: Int
    var createdAt: Date

    init(
        name: String,
        brand: String,
        description: String,
        price: Double,
        categoryName: String,
        imageName: String = "bag.fill",
        isLimitedEdition: Bool = false,
        isFeatured: Bool = false,
        rating: Double = 4.5,
        stockCount: Int = 10
    ) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.productDescription = description
        self.price = price
        self.categoryName = categoryName
        self.imageName = imageName
        self.isLimitedEdition = isLimitedEdition
        self.isFeatured = isFeatured
        self.isWishlisted = false
        self.rating = rating
        self.stockCount = stockCount
        self.createdAt = Date()
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
}
