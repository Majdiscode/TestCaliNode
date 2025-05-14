//
//  SkillTreeEngine.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/12/25.
//

//
//  SkillTreeEngine.swift
//  TestCaliNode
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SkillTreeEngine: ObservableObject {
    @Published var skills: [SkillNode]
    private let db = Firestore.firestore()
    private let treeName: String   // e.g., "pull"

    init(skills: [SkillNode], treeName: String) {
        self.skills = skills
        self.treeName = treeName
        loadProgress()
    }

    // ✅ Check if all prerequisites are met
    func canUnlock(_ skill: SkillNode) -> Bool {
        for prereqID in skill.requires {
            if !isSkillUnlocked(prereqID) {
                return false
            }
        }
        return true
    }

    // 🔓 Unlock skill
    func unlock(_ skillID: String) {
        guard let index = skills.firstIndex(where: { $0.id == skillID }) else { return }
        skills[index].unlocked = true
        saveProgress(skillID)
    }

    // ☁️ Load saved unlocks from Firebase
    private func loadProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let docRef = db.collection("profiles").document(uid)
        docRef.getDocument { document, error in
            guard let data = document?.data(),
                  let savedSkills = data["skills"] as? [String: Bool] else { return }

            DispatchQueue.main.async {
                self.skills = self.skills.map { node in
                    var updated = node
                    updated.unlocked = savedSkills[node.id] ?? false
                    return updated
                }
            }
        }
    }

    // 💾 Save unlocked skill to Firestore
    private func saveProgress(_ skillID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("profiles").document(uid).setData([
            "skills": [skillID: true]
        ], merge: true)
    }

    // 🧠 Check by ID if skill is unlocked
    func isSkillUnlocked(_ id: String) -> Bool {
        return skills.first(where: { $0.id == id })?.unlocked == true
    }
}
