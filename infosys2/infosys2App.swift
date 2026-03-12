//
//  infosys2App.swift
//  infosys2
//
//  Created by user@78 on 10/03/26.
//

import SwiftUI
import SwiftData

@main
struct infosys2App: App {
    @State private var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            User.self,
            Product.self,
            Category.self,
            Order.self,
            CartItem.self,
            ClientProfile.self,
            Appointment.self,
            AfterSalesTicket.self,
            Transfer.self,
            Event.self,
            AppNotification.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .onAppear {
                    seedDataIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    @MainActor
    private func seedDataIfNeeded() {
        let context = sharedModelContainer.mainContext
        SeedData.seedIfNeeded(modelContext: context)
    }
}
