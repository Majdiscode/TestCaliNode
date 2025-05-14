//
//  PushTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/12/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PushTreeView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var engine = SkillTreeEngine(
        skills: [
            SkillNode(id: "pushStart", label: "", fullLabel: "", requires: [], confirmPrompt: "", unlocked: true),
            SkillNode(id: "kneePushup", label: "🦵", fullLabel: "Knee Push-Up (2x10)", requires: ["pushStart"], confirmPrompt: "Can you do 2 sets of 10 Knee Push-Ups?", unlocked: false),
            SkillNode(id: "inclinePushup", label: "📐", fullLabel: "Incline Push-Up (2x8)", requires: ["kneePushup"], confirmPrompt: "Can you do 2 sets of 8 Incline Push-Ups?", unlocked: false),
            SkillNode(id: "pushup", label: "🙌", fullLabel: "Push-Up (2x10)", requires: ["inclinePushup"], confirmPrompt: "Can you do 2 sets of 10 Push-Ups?", unlocked: false)
        ],
        treeName: "push"
    )

    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    let kneePos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.75)
                    let inclinePos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.55)
                    let pushupPos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.35)

                    LineConnector(from: inclinePos, to: kneePos)
                    LineConnector(from: pushupPos, to: inclinePos)

                    ForEach(engine.skills.filter { $0.id != "pushStart" }) { skill in
                        let pos: CGPoint = {
                            switch skill.id {
                            case "kneePushup": return kneePos
                            case "inclinePushup": return inclinePos
                            case "pushup": return pushupPos
                            default: return .zero
                            }
                        }()

                        SkillCircle(label: skill.label, unlocked: skill.unlocked)
                            .position(pos)
                            .onTapGesture {
                                // 🚫 Do nothing if already unlocked
                                guard !skill.unlocked else { return }

                                if engine.canUnlock(skill) {
                                    pendingSkill = skill
                                    showCard = true
                                } else {
                                    let unmet = skill.requires.filter { !engine.isSkillUnlocked($0) }
                                    let names: [String] = unmet.compactMap { id in
                                        guard id != "<treeStart>" else { return nil }  // 🔁 update per tree
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

                VStack {
                    Spacer()
                    Button("Reset All Skills") {
                        resetAll()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.bottom, 80)
                }

                if showCard, let skill = pendingSkill {
                    let backgroundColor = colorScheme == .dark ? Color(white: 0.15) : Color.white

                    Color.black.opacity(0.6)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text(skill.confirmPrompt)
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        HStack {
                            Button("Cancel") {
                                showCard = false
                            }
                            .foregroundColor(.red)

                            Spacer()

                            Button("Yes") {
                                engine.unlock(skill.id)
                                showCard = false
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 320, minHeight: 180)
                    .background(backgroundColor)
                    .cornerRadius(20)
                    .shadow(radius: 12)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            let skill0 = "pushStart"
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

        let ids = engine.skills.map { $0.id }.filter { $0 != "pushStart" }
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
