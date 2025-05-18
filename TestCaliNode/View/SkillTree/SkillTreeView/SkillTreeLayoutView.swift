import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SkillTreeLayoutView: View {
    @Environment(\.colorScheme) var colorScheme

    let skills: [SkillNode]
    let positions: [String: CGPoint]
    let baseSkillID: String
    let treeName: String

    @StateObject private var engine: SkillTreeEngine
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
        _engine = StateObject(wrappedValue: SkillTreeEngine(skills: skills, treeName: treeName))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    // Lines
                    ForEach(engine.skills, id: \.id) { skill in
                        ForEach(skill.requires, id: \.self) { reqID in
                            if let from = positions[reqID], let to = positions[skill.id] {
                                LineConnector(from: from, to: to)
                            }
                        }
                    }

                    // Circles
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

                    // Warning message
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
        .onAppear { reloadSkillState() }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SkillsReset"))) { _ in
            reloadSkillState()
        }
    }

    private func reloadSkillState() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userRef = Firestore.firestore().collection("profiles").document(uid)

        userRef.getDocument { snapshot, error in
            var skillsToSet: [String: Any] = [:]

            if let data = snapshot?.data(),
               let skillMap = data["skills"] as? [String: Any],
               skillMap[baseSkillID] as? Bool != true {
                skillsToSet["skills.\(baseSkillID)"] = true
            }

            if !skillsToSet.isEmpty {
                userRef.updateData(skillsToSet)
            }

            if let index = engine.skills.firstIndex(where: { $0.id == baseSkillID }) {
                engine.skills[index].unlocked = true
            }

            if let unlocked = snapshot?.data()?["skills"] as? [String: Bool] {
                for (id, isUnlocked) in unlocked {
                    if let i = engine.skills.firstIndex(where: { $0.id == id }) {
                        engine.skills[i].unlocked = isUnlocked
                    }
                }
            } else {
                for i in engine.skills.indices {
                    if engine.skills[i].id != baseSkillID {
                        engine.skills[i].unlocked = false
                    }
                }
            }

            engine.objectWillChange.send()
        }
    }
}
