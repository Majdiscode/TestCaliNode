import SwiftUI
import FirebaseSignInWithApple      // 🧩 Apple
import FirebaseAuth                 // 🧩 Google
import GoogleSignIn                 // 🧩 Google

struct LogoutView: View {
    @State private var err: String = ""

    var body: some View {
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
                Task {
                    do {
                        try await logoutFromGoogle()
                    } catch let e {
                        err = e.localizedDescription
                    }
                }
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
    }

    // 🧩 Google Sign-Out Logic with notification
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

#Preview {
    LogoutView()
}
