//
//  SkillTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//



import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SkillTreeView: View {
    @State private var level = 0
    private let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Skill Tree")
                .font(.largeTitle)

            Divider()

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
        .padding()
        .onAppear {
            fetchLevel()
        }
    }

    private func fetchLevel() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                level = document.data()?["level"] as? Int ?? 0
            } else {
                docRef.setData(["level": 0])
                level = 0
            }
        }
    }

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
}
