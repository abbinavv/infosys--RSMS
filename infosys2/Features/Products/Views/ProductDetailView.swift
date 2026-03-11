//
//  ProductDetailView.swift
//  infosys2
//
//  Full product detail with image, price, description, and wishlist toggle.
//

import SwiftUI
import SwiftData

struct ProductDetailView: View {
    @Bindable var product: Product
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Product image area
                    ZStack {
                        AppColors.backgroundSecondary
                            .frame(height: 380)

                        Image(systemName: product.imageName)
                            .font(.system(size: 80, weight: .ultraLight))
                            .foregroundColor(AppColors.neutral600)

                        // Limited Edition overlay
                        if product.isLimitedEdition {
                            VStack {
                                HStack {
                                    Text("LIMITED EDITION")
                                        .font(AppTypography.overline)
                                        .tracking(2)
                                        .foregroundColor(AppColors.primary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(AppColors.accent)
                                        .cornerRadius(4)
                                    Spacer()
                                }
                                .padding(AppSpacing.screenHorizontal)
                                Spacer()
                            }
                            .padding(.top, AppSpacing.md)
                        }
                    }

                    // Product info
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        // Brand & name
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(product.brand.uppercased())
                                .font(AppTypography.overline)
                                .tracking(3)
                                .foregroundColor(AppColors.accent)

                            Text(product.name)
                                .font(AppTypography.displaySmall)
                                .foregroundColor(AppColors.textPrimaryDark)

                            // Rating
                            HStack(spacing: AppSpacing.xxs) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.accent)
                                }
                                Text(String(format: "%.1f", product.rating))
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondaryDark)
                            }
                        }

                        // Price
                        HStack(alignment: .bottom) {
                            Text(product.formattedPrice)
                                .font(AppTypography.priceDisplay)
                                .foregroundColor(AppColors.textPrimaryDark)

                            Spacer()

                            // Stock status
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(product.stockCount > 0 ? AppColors.success : AppColors.error)
                                    .frame(width: 6, height: 6)

                                Text(product.stockCount > 5 ? "In Stock" :
                                     product.stockCount > 0 ? "Only \(product.stockCount) left" :
                                     "Out of Stock")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondaryDark)
                            }
                        }

                        GoldDivider()

                        // Description
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("DESCRIPTION")
                                .font(AppTypography.overline)
                                .tracking(2)
                                .foregroundColor(AppColors.accent)

                            Text(product.productDescription)
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondaryDark)
                                .lineSpacing(6)
                        }

                        GoldDivider()

                        // Details
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("DETAILS")
                                .font(AppTypography.overline)
                                .tracking(2)
                                .foregroundColor(AppColors.accent)

                            detailRow(label: "Brand", value: product.brand)
                            detailRow(label: "Category", value: product.categoryName)
                            detailRow(label: "Availability", value: product.stockCount > 0 ? "Available" : "Sold Out")
                            if product.isLimitedEdition {
                                detailRow(label: "Collection", value: "Limited Edition")
                            }
                        }

                        Spacer().frame(height: AppSpacing.xxl)
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    .padding(.top, AppSpacing.xl)
                }
            }

            // Bottom action bar
            VStack {
                Spacer()

                HStack(spacing: AppSpacing.md) {
                    // Wishlist button
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            product.isWishlisted.toggle()
                            try? modelContext.save()
                        }
                    }) {
                        Image(systemName: product.isWishlisted ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(product.isWishlisted ? AppColors.error : AppColors.textPrimaryDark)
                            .frame(width: AppSpacing.touchTarget + 8, height: AppSpacing.touchTarget + 8)
                            .background(AppColors.backgroundTertiary)
                            .cornerRadius(AppSpacing.radiusMedium)
                    }

                    // Add to bag (placeholder)
                    PrimaryButton(title: "Add to Bag") {
                        // Future cart feature
                    }
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.md)
                .background(
                    AppColors.backgroundPrimary
                        .shadow(color: .black.opacity(0.3), radius: 10, y: -5)
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textSecondaryDark)
            Spacer()
            Text(value)
                .font(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textPrimaryDark)
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product(
            name: "Classic Flap Bag",
            brand: "Maison Luxe",
            description: "Timeless quilted leather bag with signature gold chain strap.",
            price: 4850,
            categoryName: "Handbags",
            imageName: "bag.fill",
            isLimitedEdition: true,
            isFeatured: true,
            rating: 4.9,
            stockCount: 3
        ))
    }
    .modelContainer(for: Product.self, inMemory: true)
}
