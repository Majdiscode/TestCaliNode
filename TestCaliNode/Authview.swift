//
//  Authview.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

import SwiftUI
import FirebaseSignInWithApple

struct AuthView: View {
   
//    @Environment(\.firebaseSignInWithApple) private var
       // firebaseSignInWithApple
    
    var body: some View {
        VStack {
            Spacer()
            
//            Button {
//                firebaseSignInWithApple.authenticate()
//            } label: {
//                FirebaseSignInWithAppleLabel(.continueWithApple)
//        }
            
            FirebaseSignInWithAppleButton {
                FirebaseSignInWithAppleLabel(.continueWithApple)
            }
            
        }
        Text("Hello, AuthView!")
    }
}

#Preview {
    AuthView()
}
