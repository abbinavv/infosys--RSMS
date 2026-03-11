//
//  Category.swift
//  infosys2
//
//  SwiftData model for product categories.
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var categoryDescription: String
    var displayOrder: Int

    init(name: String, icon: String, description: String, displayOrder: Int = 0) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.categoryDescription = description
        self.displayOrder = displayOrder
    }
}
