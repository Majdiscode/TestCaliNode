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
    @State private var globallyUnlockedIDs: Set<String> = []

    var body: some View {
        ZStack {
            if let engine = engine {
                ScrollView {
                    let maxY = positions.values.map(\.y).max() ?? 1000
                    let scrollHeight = maxY + 400

                    ZStack {
                        connectorLines(engine: engine)

                        ForEach(engine.skills) { skill in
                            if let pos = positions[skill.id] {
                                SkillCircle(label: skill.label, unlocked: skill.unlocked)
                                    .position(pos)
                                    .id(skill.id)
                                    .onTapGesture {
                                        guard !skill.unlocked else { return }

                                        if skill.requires.allSatisfy({ globallyUnlockedIDs.contains($0) }) {
                                            pendingSkill = skill
                                            showCard = true
                                        } else {
                                            let unmet = skill.requires.filter { !globallyUnlockedIDs.contains($0) }
                                            let names = unmet.compactMap { id in
                                                allSkills.first(where: { $0.id == id })?.fullLabel.components(separatedBy: " (").first
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
                    .frame(minHeight: scrollHeight)
                    .padding(.top, 200)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if showCard, let skill = pendingSkill {
                Color.black.opacity(0.6).ignoresSafeArea()

                ConfirmationCardView(
                    prompt: skill.confirmPrompt,
                    confirmAction: {
                        engine?.unlock(skill.id)
                        showCard = false
                        globallyUnlockedIDs.insert(skill.id)
                    },
                    cancelAction: {
                        showCard = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(10)
            }
        }
        .onAppear {
            reloadSkillState()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SkillsReset"))) { _ in
            engine = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                reloadSkillState()
            }
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
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userRef = Firestore.firestore().collection("profiles").document(uid)
        userRef.getDocument { snapshot, error in
            var updatedSkills = skills
            let skillsMap = snapshot?.data()?["skills"] as? [String: Bool] ?? [:]

            for (id, isUnlocked) in skillsMap {
                if let index = updatedSkills.firstIndex(where: { $0.id == id }) {
                    updatedSkills[index].unlocked = isUnlocked
                }
            }

            DispatchQueue.main.async {
                engine = SkillTreeEngine(skills: updatedSkills, treeName: treeName)
                globallyUnlockedIDs = Set(skillsMap.filter { $0.value }.map { $0.key })
            }
        }
    }
}
