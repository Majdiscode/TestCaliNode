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
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var engine = SkillTreeEngine(
        skills: [
            SkillNode(id: "pullStart", label: "", fullLabel: "", requires: [], confirmPrompt: "", unlocked: true),
            SkillNode(id: "deadHang", label: "🪢", fullLabel: "Dead Hang (10s)", requires: ["pullStart"], confirmPrompt: "Can you Dead Hang for 10 seconds?", unlocked: false),
            SkillNode(id: "scapularPulls", label: "⬇️", fullLabel: "Scapular Pulls (2x6)", requires: ["deadHang"], confirmPrompt: "Can you Dead Hang for 30 seconds?", unlocked: false),
            SkillNode(id: "pullUp", label: "🆙", fullLabel: "Pull-Ups (2x5)", requires: ["scapularPulls"], confirmPrompt: "Can you do 2 sets of 8 reps of Scapular Pulls?", unlocked: false)
        ],
        treeName: "pull"
    )

    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    let deadHangPos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.75)
                    let scapularPos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.55)
                    let pullUpPos = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.35)

                    LineConnector(from: scapularPos, to: deadHangPos)
                    LineConnector(from: pullUpPos, to: scapularPos)

                    ForEach(engine.skills.filter { $0.id != "pullStart" }) { skill in
                        let pos: CGPoint = {
                            switch skill.id {
                            case "deadHang": return deadHangPos
                            case "scapularPulls": return scapularPos
                            case "pullUp": return pullUpPos
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
            let skill0 = "pullStart"
            guard let uid = Auth.auth().currentUser?.uid else { return }

            let userRef = Firestore.firestore().collection("profiles").document(uid)

            userRef.getDocument { snapshot, error in
                var skillsToSet = [String: Any]()

                // Ensure skill 0 is present in Firestore
                if let data = snapshot?.data(),
                   let skills = data["skills"] as? [String: Any],
                   skills[skill0] as? Bool != true {
                    skillsToSet["skills.\(skill0)"] = true
                }

                if !skillsToSet.isEmpty {
                    userRef.updateData(skillsToSet)
                }

                // Always mark pullStart as unlocked locally
                if let index = engine.skills.firstIndex(where: { $0.id == skill0 }) {
                    engine.skills[index].unlocked = true
                }

                // Load all unlocked skills
                if let unlockedMap = snapshot?.data()?["skills"] as? [String: Bool] {
                    for (id, isUnlocked) in unlockedMap {
                        if id == skill0 { continue } // skip pullStart
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

        let ids = engine.skills.map { $0.id }.filter { $0 != "pullStart" } // ⛔ exclude pullStart
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
