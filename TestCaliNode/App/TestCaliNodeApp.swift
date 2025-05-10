//
//  TestCaliNodeApp.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

import SwiftUI
import FirebaseSignInWithApple

@main

struct TestCaliNodeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
                .configureFirebaseSignInWithAppleWith(firestoreUserCollectionPath: Path.Firestore.profiles)
        }
    }
}
