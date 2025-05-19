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

                    ForEach(engine.skills.filter { $0.id != baseSkillID }) { skill in
                        if let pos = positions[skill.id] {
                            SkillCircle(label: skill.label, unlocked: skill.unlocked)
                                .position(pos)
                                .onTapGesture {
                                    guard !skill.unlocked else { return }

                                    if engine.canUnlock(skill) {
                                        print("✅ \(skill.id) is ready to unlock. Showing card.")
                                        pendingSkill = skill
                                        showCard = true
                                    } else {
                                        let unmet = skill.requires.filter { !engine.isSkillUnlocked($0) }
                                        let names: [String] = unmet.compactMap { id in
                                            if id == baseSkillID { return nil }
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
        }
        .onAppear {
            print("📲 onAppear triggered for tree: \(treeName)")
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
            var skillsToSet: [String: Any] = [:]

            // Always unlock base skill locally
            if let index = updatedSkills.firstIndex(where: { $0.id == baseSkillID }) {
                updatedSkills[index].unlocked = true
                print("✅ Locally unlocked base skill: \(baseSkillID)")
            }

            let skillsMap = snapshot?.data()?["skills"] as? [String: Bool] ?? [:]
            print("📥 Firestore skill data: \(skillsMap)")

            if skillsMap[baseSkillID] != true {
                print("⚠️ Base skill \(baseSkillID) missing in Firestore. Will add.")
                skillsToSet["skills.\(baseSkillID)"] = true
            }

            for (id, isUnlocked) in skillsMap {
                if let index = updatedSkills.firstIndex(where: { $0.id == id }) {
                    updatedSkills[index].unlocked = isUnlocked
                    print("↪️ Setting \(id) = \(isUnlocked)")
                }
            }

            if !skillsToSet.isEmpty {
                print("⬆️ Writing base skill to Firestore: \(skillsToSet)")
                userRef.setData(skillsToSet, merge: true) { err in
                    if let err = err {
                        print("❌ Failed to write base skill: \(err.localizedDescription)")
                    } else {
                        print("✅ Successfully restored base skill \(baseSkillID) to Firestore")
                    }
                }
            }

            engine = SkillTreeEngine(skills: updatedSkills, treeName: treeName)
            print("✅ Engine reloaded and assigned for tree: \(treeName)")
        }
    }
}
