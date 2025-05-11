//
//  PullTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PullTreeView: View {
    @State private var deadHangNode = SkillNode(
        id: "deadHang",
        label: "🪢",
        fullLabel: "Dead Hang (30s)",
        unlocked: false
    )

    @State private var scapularPullsNode = SkillNode(
        id: "scapularPulls",
        label: "⬇️",
        fullLabel: "Scapular Pulls (2x6)",
        unlocked: false
    )

    @State private var showingDeadHangAlert = false
    @State private var showingScapularAlert = false
    @State private var prereqMessage: String? = nil

    private let db = Firestore.firestore()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Pull Skill Tree")
                    .font(.title)

                // 🪢 Dead Hang Node
                Button {
                    if !deadHangNode.unlocked {
                        showingDeadHangAlert = true
                    }
                } label: {
                    Text(deadHangNode.label)
                        .font(.system(size: 40))
                        .padding()
                        .background(deadHangNode.unlocked ? Color.green : Color.gray)
                        .clipShape(Circle())
                }
                .alert("Can you Dead Hang for 30s?", isPresented: $showingDeadHangAlert) {
                    Button("Yes") { unlockSkill("deadHang") }
                    Button("Cancel", role: .cancel) {}
                }

                // ⬇️ Scapular Pulls Node
                Button {
                    if !deadHangNode.unlocked {
                        prereqMessage = "To unlock Scapular Pulls, you must first unlock: Dead Hang"
                    } else if !scapularPullsNode.unlocked {
                        showingScapularAlert = true
                    }
                } label: {
                    Text(scapularPullsNode.label)
                        .font(.system(size: 40))
                        .padding()
                        .background(scapularPullsNode.unlocked ? Color.green : Color.gray)
                        .clipShape(Circle())
                }
                .alert("Can you perform Scapular Pulls (2x6)?", isPresented: $showingScapularAlert) {
                    Button("Yes") { unlockSkill("scapularPulls") }
                    Button("Cancel", role: .cancel) {}
                }

                // ❗ Prerequisite warning
                if let message = prereqMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .font(.caption)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                prereqMessage = nil
                            }
                        }
                }

                // 🔁 Reset Button
                Button("Reset All Skills") {
                    resetAllSkills()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding()
        }
        .onAppear {
            loadSkillProgress()
        }
    }

    private func unlockSkill(_ skillID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        switch skillID {
        case "deadHang":
            deadHangNode.unlocked = true
        case "scapularPulls":
            scapularPullsNode.unlocked = true
        default:
            break
        }

        db.collection("profiles").document(uid).setData([
            "skills": [skillID: true]
        ], merge: true)
    }

    private func resetAllSkills() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        deadHangNode.unlocked = false
        scapularPullsNode.unlocked = false

        db.collection("profiles").document(uid).setData([
            "skills": [
                "deadHang": FieldValue.delete(),
                "scapularPulls": FieldValue.delete()
            ]
        ], merge: true)
    }

    private func loadSkillProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let docRef = db.collection("profiles").document(uid)
        docRef.getDocument { document, error in
            guard let data = document?.data(),
                  let skills = data["skills"] as? [String: Bool] else { return }

            deadHangNode.unlocked = skills["deadHang"] == true
            scapularPullsNode.unlocked = skills["scapularPulls"] == true
        }
    }
}
