//
//  LogoutView.swift
//  TestCaliNode
//
//  Fixed version with performLogout method
//

import SwiftUI
import FirebaseSignInWithApple
import FirebaseAuth
import GoogleSignIn

struct LogoutView: View {
    @State private var err: String = ""
    @State private var showingConfirmation = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 🔐 Apple: Sign Out Button
                FirebaseSignOutWithAppleButton {
                    FirebaseSignInWithAppleLabel(.signOut)
                }

                // 🗑 Apple: Delete Account Button
                FirebaseDeleteAccountWithAppleButton {
                    FirebaseSignInWithAppleLabel(.deleteAccount)
                }

                // 🔐 Google: Sign Out Button
                Button {
                    performLogout()
                } label: {
                    Text("Log Out from Google").padding(8)
                }
                .buttonStyle(.borderedProminent)

                // 🧩 Error Display
                if !err.isEmpty {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            .navigationTitle("Sign Out")
        }
    }

    // 🧩 Google Sign-Out Logic with notification
    private func performLogout() {
        Task {
            do {
                try await logoutFromGoogle()
            } catch {
                err = error.localizedDescription
            }
        }
    }
    
    private func logoutFromGoogle() async throws {
        GIDSignIn.sharedInstance.signOut()

        do {
            try Auth.auth().signOut()
            print("✅ Google sign-out successful")

            // Force refresh of auth state (for MainView)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("AuthChanged"), object: nil)
            }
        } catch {
            print("❌ Error signing out:", error.localizedDescription)
            throw error
        }
    }
}
