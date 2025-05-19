//
//  MainView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

import SwiftUI
import FirebaseSignInWithApple   // 🧩 Apple
import FirebaseAuth              // 🧩 Google
import FirebaseFirestore

struct MainView: View {
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple  // 🧩 Apple
    @State private var googleUserLoggedIn = (Auth.auth().currentUser != nil)     // 🧩 Google
    
    var body: some View {
        Group {
            if googleUserLoggedIn {
                // ✅ Show tabs if Google user is logged in
                MainTabView()
            } else {
                switch firebaseSignInWithApple.state {
                case .loading:
                    ProgressView()
                case .authenticating:
                    ProgressView()
                case .notAuthenticated:
                    AuthView()
                case .authenticated:
                    // ✅ Show tabs if Apple user is logged in
                    MainTabView()
                }
            }
        }
        .onAppear {
            // 🧩 Live Google auth state listener
            Auth.auth().addStateDidChangeListener { _, user in
                googleUserLoggedIn = (user != nil)
            }
            
        }
        .onChange(of: firebaseSignInWithApple.state) { oldValue, newValue in
            print("FireBaseSignInWithApple state changed from \(oldValue) to \(newValue)")
            
        }
    }
}
