//
//  Authview.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//


import SwiftUI
import FirebaseSignInWithApple     // 🧩 Apple Sign-In
import FirebaseAuth                // 🧩 Google Sign-In
import GoogleSignIn                // 🧩 Google Sign-In
import FirebaseCore                // 🧩 Google Sign-In

struct AuthView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true  // 🌗 Theme toggle

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 🧩 Apple Sign-In Button with SF Symbol
            FirebaseSignInWithAppleButton {
                HStack {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Continue with Apple")
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(width: 280, height: 45)
                .foregroundColor(isDarkMode ? .black : .white)
                .background(isDarkMode ? Color.white : Color.black)
                .cornerRadius(15)
                .shadow(radius: 2)
            }

            // 🧩 Google Sign-In Button styled to match
            Button(action: {
                signInWithGoogle()
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("Continue with Google")
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(width: 280, height: 45)
                .foregroundColor(isDarkMode ? .black : .white)
                .background(isDarkMode ? Color.white : Color.black)
                .cornerRadius(15)
                .shadow(radius: 2)
            }


            // 🌗 Light/Dark Mode Toggle
            Toggle(isOn: $isDarkMode) {
                Label("Dark Mode", systemImage: "moon.fill")
            }
            .padding(.top, 30)
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }

    // 🧩 Google Sign-In Logic
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let user = user?.user,
                  let idToken = user.idToken else { return }

            let accessToken = user.accessToken

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else { return }
                print(user)
            }
        }
    }
}

#Preview {
    AuthView()
}
