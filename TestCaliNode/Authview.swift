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
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 🧩 Apple Sign-In Button
            FirebaseSignInWithAppleButton {
                FirebaseSignInWithAppleLabel(.continueWithApple)
            }

            // 🧩 Google Sign-In Button
            Button(action: {
                signInWithGoogle()
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Continue with Google")
                        .fontWeight(.medium)
                }
                .frame(width: 280, height: 45)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            }

            Spacer()
        }
        .padding()
    }

    // 🧩 Embedded Google Sign-In Logic (from AuthenticationView)
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
