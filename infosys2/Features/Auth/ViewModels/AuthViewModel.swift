//
//  AuthViewModel.swift
//  infosys2
//
//  ViewModel handling login, signup, and forgot password logic.
//

import SwiftUI
import SwiftData

@Observable
class AuthViewModel {
    var loginEmail: String = ""
    var loginPassword: String = ""

    var signUpName: String = ""
    var signUpEmail: String = ""
    var signUpPhone: String = ""
    var signUpPassword: String = ""
    var signUpConfirmPassword: String = ""

    var resetEmail: String = ""

    var errorMessage: String = ""
    var showError: Bool = false
    var isLoading: Bool = false
    var showResetSuccess: Bool = false

    // MARK: - Validation

    var isLoginValid: Bool {
        !loginEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        !loginPassword.isEmpty
    }

    var isSignUpValid: Bool {
        !signUpName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !signUpEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        !signUpPassword.isEmpty &&
        signUpPassword == signUpConfirmPassword &&
        signUpPassword.count >= 6
    }

    var isResetValid: Bool {
        !resetEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        resetEmail.contains("@")
    }

    // MARK: - Login

    func login(modelContext: ModelContext, appState: AppState) {
        guard isLoginValid else {
            showErrorMessage("Please enter valid credentials.")
            return
        }

        isLoading = true

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false

            let email = self.loginEmail.trimmingCharacters(in: .whitespaces).lowercased()

            do {
                // Fetch ALL users and filter in-memory.
                // (#Predicate with captured local variables silently fails in SwiftData)
                let descriptor = FetchDescriptor<User>()
                let allUsers = try modelContext.fetch(descriptor)
                let matchedUser = allUsers.first { $0.email.lowercased() == email }

                if let user = matchedUser {
                    if user.passwordHash == self.loginPassword {
                        appState.login(name: user.name, email: user.email, role: user.role)
                    } else {
                        self.showErrorMessage("Invalid password. Please try again.")
                    }
                } else {
                    self.showErrorMessage("No account found with this email. Please check your credentials or create an account.")
                }
            } catch {
                self.showErrorMessage("An error occurred. Please try again.")
            }
        }
    }

    // MARK: - Sign Up

    func signUp(modelContext: ModelContext, appState: AppState) {
        guard isSignUpValid else {
            if signUpPassword != signUpConfirmPassword {
                showErrorMessage("Passwords do not match.")
            } else if signUpPassword.count < 6 {
                showErrorMessage("Password must be at least 6 characters.")
            } else {
                showErrorMessage("Please fill in all fields.")
            }
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false

            let newUser = User(
                name: self.signUpName.trimmingCharacters(in: .whitespaces),
                email: self.signUpEmail.trimmingCharacters(in: .whitespaces).lowercased(),
                phone: self.signUpPhone.trimmingCharacters(in: .whitespaces),
                passwordHash: self.signUpPassword,
                role: .customer
            )

            modelContext.insert(newUser)
            appState.login(name: newUser.name, email: newUser.email, role: newUser.role)
        }
    }

    // MARK: - Forgot Password

    func resetPassword() {
        guard isResetValid else {
            showErrorMessage("Please enter a valid email address.")
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.showResetSuccess = true
        }
    }

    // MARK: - Error Handling

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
