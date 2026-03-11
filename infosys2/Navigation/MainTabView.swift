//
//  MainTabView.swift
//  infosys2
//
//  Primary tab bar navigation with luxury styling.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0

    init() {
        // Style the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "0A0A0A"))

        // Normal state — muted grey
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color(hex: "555555"))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color(hex: "555555"))
        ]

        // Selected state — champagne gold
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "C9A84C"))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color(hex: "C9A84C"))
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)

            CategoriesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)

            WishlistView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "heart.fill" : "heart")
                    Text("Wishlist")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .modelContainer(for: [Product.self, Category.self, User.self], inMemory: true)
}

