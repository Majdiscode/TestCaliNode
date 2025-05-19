import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SkillTreeLayoutView: View {
    @Environment(\.colorScheme) var colorScheme

    let skills: [SkillNode]
    let positions: [String: CGPoint]
    let treeName: String

    @State private var engine: SkillTreeEngine? = nil
    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil

    var body: some View {
        GeometryReader { geo in
            if let engine = engine {
                ZStack {
                    ZStack {
                        connectorLines(engine: engine)

                        ForEach(engine.skills) { skill in
                            if let pos = positions[skill.id] {
                                SkillCircle(label: skill.label, unlocked: skill.unlocked)
                                    .position(pos)
                                    .onTapGesture {
                                        guard !skill.unlocked else { return }

                                        let engineUnlocked = engine.skills.filter { $0.unlocked }.map(\.id)
                                        print("🧠 Checking unlock for \(skill.id), requires: \(skill.requires), unlocked: \(engineUnlocked)")

                                        if engine.canUnlock(skill) {
                                            print("✅ \(skill.id) can unlock. Showing card.")
                                            pendingSkill = skill
                                            showCard = true
                                        } else {
                                            let unmet = skill.requires.filter { !engine.isSkillUnlocked($0) }
                                            let names = unmet.compactMap { (id: String) -> String? in
                                                return engine.skills.first { $0.id == id }?.fullLabel.components(separatedBy: " (").first
                                            }
                                            print("❌ \(skill.id) prerequisites not met: \(unmet)")
                                            prereqMessage = "To unlock \(skill.fullLabel.components(separatedBy: " (").first!), you must first unlock: \(names.joined(separator: " and "))"
                                        }
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

                    if showCard, let skill = pendingSkill {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()

                        ConfirmationCardView(
                            prompt: skill.confirmPrompt,
                            confirmAction: {
                                print("🟢 Unlocking \(skill.id)")
                                engine.unlock(skill.id)
                                showCard = false
                            },
                            cancelAction: {
                                print("🔴 Cancel unlock of \(skill.id)")
                                showCard = false
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(1)
                    }
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            print("📲 onAppear triggered for tree: \(treeName)")
            reloadSkillState()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SkillsReset"))) { _ in
            reloadSkillState()
        }
    }

    private func connectorLines(engine: SkillTreeEngine) -> some View {
        ForEach(engine.skills, id: \.id) { skill in
            ForEach(skill.requires, id: \.self) { reqID in
                if let from = positions[reqID], let to = positions[skill.id] {
                    LineConnector(from: from, to: to)
                }
            }
        }
    }

    private func reloadSkillState() {
        print("⏳ Reloading skill state for tree: \(treeName)")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No UID found")
            return
        }

        let userRef = Firestore.firestore().collection("profiles").document(uid)

        userRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ Firestore fetch error: \(error.localizedDescription)")
                return
            }

            var updatedSkills = skills
            let skillsMap = snapshot?.data()?["skills"] as? [String: Bool] ?? [:]
            print("📥 Firestore skills map: \(skillsMap)")

            for (id, isUnlocked) in skillsMap {
                if let index = updatedSkills.firstIndex(where: { $0.id == id }) {
                    updatedSkills[index].unlocked = isUnlocked
                    print("↪️ \(id) = \(isUnlocked)")
                }
            }

            DispatchQueue.main.async {
                let currentEngine = SkillTreeEngine(skills: updatedSkills, treeName: treeName)
                engine = currentEngine
                print("✅ Engine fully loaded for tree: \(treeName)")
                currentEngine.skills.forEach { print("🔹 \($0.id): \($0.unlocked)") }
            }
        }
    }
}
