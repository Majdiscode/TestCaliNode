//
//  LogoutConfirmationView.swift
//  TestCaliNode
//
//  Fixed version - standalone component
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct LogoutConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoggingOut = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.xmark")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            VStack(spacing: 12) {
                Text("Sign Out")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Are you sure you want to sign out? Your progress will be saved to your account.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            
            VStack(spacing: 12) {
                Button("Sign Out") {
                    performLogout()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .background(Color.red)
                .disabled(isLoggingOut)
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .disabled(isLoggingOut)
            }
            
            if isLoggingOut {
                ProgressView("Signing out...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
        .navigationTitle("Sign Out")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func performLogout() {
        isLoggingOut = true
        errorMessage = ""
        
        Task {
            do {
                GIDSignIn.sharedInstance.signOut()
                try Auth.auth().signOut()
                
                print("✅ Logout successful")
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("AuthChanged"), object: nil)
                    self.isLoggingOut = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoggingOut = false
                    self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
                    print("❌ Logout error: \(error)")
                }
            }
        }
    }
}
