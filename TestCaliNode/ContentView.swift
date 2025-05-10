import SwiftUI
import FirebaseSignInWithApple      // 🧩 Apple
import FirebaseAuth                 // 🧩 Google
import GoogleSignIn                 // 🧩 Google
import FirebaseFirestore            // 🧩 Firestore

struct ContentView: View {
    @State private var err: String = ""
    @State private var level: Int = 0
    private let db = Firestore.firestore()

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

            Divider().padding(.vertical)

            // 🧬 Level Display + Button
            VStack(spacing: 10) {
                Text("Your Level: \(level)")
                    .font(.title2)

                Button("Level Up") {
                    incrementLevel()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            fetchLevel()
        }
    }

    // 🔼 Firestore: Fetch user level
    private func fetchLevel() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                self.level = document.data()?["level"] as? Int ?? 0
            } else {
                docRef.setData(["level": 0])
                self.level = 0
            }
        }
    }

    // 🔼 Firestore: Increment and update level
    private func incrementLevel() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("profiles").document(uid)

        level += 1
        docRef.updateData(["level": level]) { error in
            if let error = error {
                print("Error updating level: \(error.localizedDescription)")
            } else {
                print("✅ Level updated to \(level)")
            }
        }
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
    ContentView()
}
