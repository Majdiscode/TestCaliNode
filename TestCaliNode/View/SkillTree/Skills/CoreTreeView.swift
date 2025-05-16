//
//  CoreTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/12/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CoreTreeView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var engine = SkillTreeEngine(
        skills: [
            SkillNode(id: "coreStart", label: "", fullLabel: "", requires: [], confirmPrompt: "", unlocked: true),
            SkillNode(id: "hollowHold", label: "🥚", fullLabel: "Hollow Hold (30s)", requires: ["coreStart"], confirmPrompt: "Can you do a Hollow Hold for 30 seconds?", unlocked: false),
            SkillNode(id: "plank", label: "🧱", fullLabel: "Plank (60s)", requires: ["coreStart"], confirmPrompt: "Can you hold a Plank for 60 seconds?", unlocked: false),
            SkillNode(id: "legRaises", label: "🦵⬆️", fullLabel: "Leg Raises (2x10)", requires: ["hollowHold", "plank"], confirmPrompt: "Can you do 2 sets of 10 Leg Raises?", unlocked: false)
        ],
        treeName: "core"
    )

    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    let hollowPos = CGPoint(x: geo.size.width / 2 - 80, y: geo.size.height * 0.65)
                    let plankPos = CGPoint(x: geo.size.width / 2 + 80, y: geo.size.height * 0.65)
                    let raisePos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.45)

                    LineConnector(from: raisePos, to: hollowPos)
                    LineConnector(from: raisePos, to: plankPos)

                    ForEach(engine.skills.filter { $0.id != "coreStart" }) { skill in
                        let pos: CGPoint = {
                            switch skill.id {
                            case "hollowHold": return hollowPos
                            case "plank": return plankPos
                            case "legRaises": return raisePos
                            default: return .zero
                            }
                        }()

                        SkillCircle(label: skill.label, unlocked: skill.unlocked)
                            .position(pos)
                            .onTapGesture {
                                guard !skill.unlocked else { return }

                                if engine.canUnlock(skill) {
                                    pendingSkill = skill
                                    showCard = true
                                } else {
                                    let unmet = skill.requires.filter { !engine.isSkillUnlocked($0) }
                                    let names: [String] = unmet.compactMap { id in
                                        guard id != "coreStart" else { return nil }
                                        return engine.skills.first { $0.id == id }?.fullLabel.components(separatedBy: " (").first
                                    }
                                    prereqMessage = "To unlock \(skill.fullLabel.components(separatedBy: " (").first!), you must first unlock: \(names.joined(separator: " and "))"
                                }
                            }
                    }

                    if let message = prereqMessage {
                        VStack {
                            Spacer()
                            Text(message)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 40)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        prereqMessage = nil
                                    }
                                }
                        }
                    }
                }

                // ✅ Reusable Reset Button
                ResetSkillsButton(action: resetAll)

                // ✅ Reusable Confirmation Card
                if showCard, let skill = pendingSkill {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()

                    ConfirmationCardView(
                        prompt: skill.confirmPrompt,
                        confirmAction: {
                            engine.unlock(skill.id)
                            showCard = false
                        },
                        cancelAction: {
                            showCard = false
                        }
                    )
                }
            }
        }
        .onAppear {
            let skill0 = "coreStart"
            guard let uid = Auth.auth().currentUser?.uid else { return }

            let userRef = Firestore.firestore().collection("profiles").document(uid)

            userRef.getDocument { snapshot, error in
                var skillsToSet = [String: Any]()

                if let data = snapshot?.data(),
                   let skills = data["skills"] as? [String: Any],
                   skills[skill0] as? Bool != true {
                    skillsToSet["skills.\(skill0)"] = true
                }

                if !skillsToSet.isEmpty {
                    userRef.updateData(skillsToSet)
                }

                if let index = engine.skills.firstIndex(where: { $0.id == skill0 }) {
                    engine.skills[index].unlocked = true
                }

                if let unlockedMap = snapshot?.data()?["skills"] as? [String: Bool] {
                    for (id, isUnlocked) in unlockedMap {
                        if id == skill0 { continue }
                        if let index = engine.skills.firstIndex(where: { $0.id == id }) {
                            engine.skills[index].unlocked = isUnlocked
                        }
                    }
                }
            }
        }
    }

    private func resetAll() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ids = engine.skills.map { $0.id }.filter { $0 != "coreStart" }
        var updates: [String: Any] = [:]
        for id in ids {
            updates["skills.\(id)"] = FieldValue.delete()
        }

        Firestore.firestore().collection("profiles").document(uid).updateData(updates) { error in
            if let error = error {
                print("Reset failed: \(error)")
            } else {
                for id in ids {
                    if let index = engine.skills.firstIndex(where: { $0.id == id }) {
                        engine.skills[index].unlocked = false
                    }
                }
            }
        }
    }
}
