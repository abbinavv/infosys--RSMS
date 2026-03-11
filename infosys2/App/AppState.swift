//
//  AppState.swift
//  infosys2
//
//  Central app state managing authentication and navigation flow.
//

import SwiftUI

enum AppFlow {
    case splash
    case onboarding
    case authentication
    case main              // Customer-facing tab bar
    case adminDashboard    // Corporate Admin enterprise panel
    case managerDashboard  // Boutique Manager store operations panel
}

@Observable
class AppState {
    var currentFlow: AppFlow = .splash

    var hasCompletedOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding")
        }
    }
    var isAuthenticated: Bool = false
    var currentUserName: String = ""
    var currentUserEmail: String = ""
    var currentUserRole: UserRole = .customer

    func completeSplash() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if hasCompletedOnboarding {
                currentFlow = .authentication
            } else {
                currentFlow = .onboarding
            }
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.easeInOut(duration: 0.5)) {
            currentFlow = .authentication
        }
    }

    func login(name: String, email: String, role: UserRole = .customer) {
        currentUserName = name
        currentUserEmail = email
        currentUserRole = role
        isAuthenticated = true
        withAnimation(.easeInOut(duration: 0.5)) {
            switch role {
            case .corporateAdmin:
                currentFlow = .adminDashboard
            case .boutiqueManager:
                currentFlow = .managerDashboard
            default:
                currentFlow = .main
            }
        }
    }

    func logout() {
        isAuthenticated = false
        currentUserName = ""
        currentUserEmail = ""
        currentUserRole = .customer
        withAnimation(.easeInOut(duration: 0.5)) {
            currentFlow = .authentication
        }
    }
}
