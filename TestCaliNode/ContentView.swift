//
//  ContentView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

import SwiftUI
import FirebaseSignInWithApple

struct ContentView: View {
    var body: some View {
        VStack {
            FirebaseSignOutWithAppleButton {
                FirebaseSignInWithAppleLabel(.signOut)
            }
            
            FirebaseDeleteAccountWithAppleButton {
                FirebaseSignInWithAppleLabel(.deleteAccount)
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
