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
            setupBaseSkillsIfNeeded()
        }
        .onChange(of: firebaseSignInWithApple.state) { oldValue, newValue in
            print("FireBaseSignInWithApple state changed from \(oldValue) to \(newValue)")
            setupBaseSkillsIfNeeded()
        }
    }

    private func setupBaseSkillsIfNeeded() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No UID found during base skill setup")
            return
        }

        let userRef = Firestore.firestore().collection("profiles").document(uid)

        userRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ Error checking user document: \(error.localizedDescription)")
                return
            }

            let skillsMap = snapshot?.data()?["skills"] as? [String: Bool] ?? [:]
            var skillsToSet: [String: Any] = [:]

            if skillsMap["pullStart"] != true {
                skillsToSet["skills.pullStart"] = true
            }
            if skillsMap["pushStart"] != true {
                skillsToSet["skills.pushStart"] = true
            }
            if skillsMap["coreStart"] != true {
                skillsToSet["skills.coreStart"] = true
            }
            if skillsMap["legsStart"] != true {
                skillsToSet["skills.legsStart"] = true
            }

            if !skillsToSet.isEmpty {
                print("🆕 Initializing base skills in Firestore: \(skillsToSet)")
                userRef.setData(skillsToSet, merge: true) { err in
                    if let err = err {
                        print("❌ Failed to write base skills: \(err.localizedDescription)")
                    } else {
                        print("✅ Successfully initialized base skills in Firestore")
                    }
                }
            } else {
                print("✅ All base skills already initialized.")
            }
        }
    }
}
