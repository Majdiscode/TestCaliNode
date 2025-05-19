import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Charts

struct ProgressData: Identifiable {
    let id = UUID()
    let label: String
    let value: Int
}

struct ProgressTab: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var globalLevel = 0
    @State private var pushLevel = 0
    @State private var pullLevel = 0
    @State private var coreLevel = 0
    @State private var legsLevel = 0

    private let db = Firestore.firestore()

    var pieChartData: [ProgressData] {
        [
            ProgressData(label: "Push", value: pushLevel),
            ProgressData(label: "Pull", value: pullLevel),
            ProgressData(label: "Core", value: coreLevel),
            ProgressData(label: "Legs", value: legsLevel)
        ].filter { $0.value > 0 }
    }

    var body: some View {
        TabView {
            // Page 1: Level Bars
            ScrollView {
                VStack(spacing: 28) {
                    Text("Progress")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .padding(.top, 24)

                    Text("Global Level: \(globalLevel)")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Skill Tree Progress")
                            .font(.headline)

                        ProgressItem(label: "Push", value: pushLevel, color: Color(hex: "#A5D8FF"))
                        ProgressItem(label: "Pull", value: pullLevel, color: Color(hex: "#4FC3F7"))
                        ProgressItem(label: "Core", value: coreLevel, color: Color(hex: "#2196F3"))
                        ProgressItem(label: "Legs", value: legsLevel, color: Color(hex: "#1565C0"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // 🔴 Reset Button
                    Button("Reset All Skills") {
                        resetAllSkills()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer(minLength: 40)
                }
            }

            // Page 2: Pie Chart
            ScrollView {
                VStack(spacing: 28) {
                    Text("Skill Distribution")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .padding(.top, 24)

                    if !pieChartData.isEmpty {
                        Chart(pieChartData) { item in
                            SectorMark(
                                angle: .value("Level", item.value),
                                innerRadius: .ratio(0.5)
                            )
                            .foregroundStyle(by: .value("Tree", item.label))
                        }
                        .chartForegroundStyleScale([
                            "Push": Color(hex: "#A5D8FF"),
                            "Pull": Color(hex: "#4FC3F7"),
                            "Core": Color(hex: "#2196F3"),
                            "Legs": Color(hex: "#1565C0")
                        ])
                        .chartLegend(position: .bottom, alignment: .center)
                        .frame(height: 260)
                        .padding(.horizontal)
                        .animation(.easeInOut, value: globalLevel)
                    }

                    Spacer(minLength: 60)
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear {
            fetchSkillLevels()
        }
    }

    private func fetchSkillLevels() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No user UID found")
            return
        }

        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { document, error in
            if let error = error {
                print("❌ Firestore fetch error: \(error.localizedDescription)")
                return
            }

            guard let data = document?.data(),
                  let savedSkills = data["skills"] as? [String: Bool] else {
                print("❌ No skills data found in Firestore document")
                return
            }

            let pushIDs = pushSkills.map(\.id)
            let pullIDs = pullSkills.map(\.id)
            let coreIDs = coreSkills.map(\.id)
            let legsIDs = legsSkills.map(\.id)

            let push = savedSkills.filter { pushIDs.contains($0.key) && $0.value }.count
            let pull = savedSkills.filter { pullIDs.contains($0.key) && $0.value }.count
            let core = savedSkills.filter { coreIDs.contains($0.key) && $0.value }.count
            let legs = savedSkills.filter { legsIDs.contains($0.key) && $0.value }.count

            DispatchQueue.main.async {
                pushLevel = push
                pullLevel = pull
                coreLevel = core
                legsLevel = legs
                globalLevel = push + pull + core + legs
            }
        }
    }

    private func resetAllSkills() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let idsToReset = allSkills.map(\.id)
        var updates: [String: Any] = [:]

        for id in idsToReset {
            updates["skills.\(id)"] = FieldValue.delete()
        }

        Firestore.firestore().collection("profiles").document(uid).updateData(updates) { error in
            if let error = error {
                print("❌ Failed to reset skills: \(error.localizedDescription)")
            } else {
                print("✅ All skills reset in Firestore")
                NotificationCenter.default.post(name: Notification.Name("SkillsReset"), object: nil)
                fetchSkillLevels()
            }
        }
    }
}

struct ProgressItem: View {
    let label: String
    let value: Int
    let color: Color
    let maxXP: Int = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(label) Level \(value)")
                    .font(.subheadline)
                    .bold()
                Spacer()
                Text("\(value)/\(maxXP) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)

                GeometryReader { geometry in
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value) / CGFloat(maxXP), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
