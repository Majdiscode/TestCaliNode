import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SkillTreeLayoutView: View {
    @Environment(\.colorScheme) var colorScheme

    let skills: [SkillNode]
    let positions: [String: CGPoint]
    let baseSkillID: String
    let treeName: String

    @State private var engine: SkillTreeEngine
    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil

    init(
        skills: [SkillNode],
        positions: [String: CGPoint],
        baseSkillID: String,
        treeName: String
    ) {
        self.skills = skills
        self.positions = positions
        self.baseSkillID = baseSkillID
        self.treeName = treeName
        _engine = State(initialValue: SkillTreeEngine(skills: skills, treeName: treeName))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    connectorLines

                    // Skill Circles
                    ForEach(engine.skills.filter { $0.id != baseSkillID }) { skill in
                        if let pos = positions[skill.id] {
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
                                            if id == baseSkillID { return nil }
                                            return engine.skills.first { $0.id == id }?.fullLabel.components(separatedBy: " (").first
                                        }
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

                // Confirmation card
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            print("📲 onAppear triggered for \(treeName)")
            reloadSkillState()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SkillsReset"))) { _ in
            print("🔁 SkillsReset notification received in \(treeName)")
            reloadSkillState()
        }
    }

    @ViewBuilder
    private var connectorLines: some View {
        ForEach(engine.skills, id: \.id) { skill in
            ForEach(skill.requires, id: \.self) { reqID in
                if let from = positions[reqID], let to = positions[skill.id] {
                    LineConnector(from: from, to: to)
                }
            }
        }
    }

    private func reloadSkillState() {
        print("⏳ Reloading skill state for \(treeName)")
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

            if let index = updatedSkills.firstIndex(where: { $0.id == baseSkillID }) {
                updatedSkills[index].unlocked = true
            }

            if let unlockedMap = snapshot?.data()?["skills"] as? [String: Bool] {
                for (id, isUnlocked) in unlockedMap {
                    if let index = updatedSkills.firstIndex(where: { $0.id == id }) {
                        updatedSkills[index].unlocked = isUnlocked
                    }
                }
                print("✅ Loaded \(unlockedMap.count) skills from Firestore for \(treeName)")
            } else {
                print("ℹ️ No unlocked skill data found, resetting all except base.")
                for i in updatedSkills.indices {
                    if updatedSkills[i].id != baseSkillID {
                        updatedSkills[i].unlocked = false
                    }
                }
            }

            engine = SkillTreeEngine(skills: updatedSkills, treeName: treeName)
            print("✅ Engine replaced and UI updated for \(treeName)")
        }
    }
}
