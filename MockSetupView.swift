import SwiftUI

struct MockSetupView: View {
    @State private var session: ExamSession = .morning90
    @State private var numQuestionsOverride: Int? = nil  // nil = デフォルト数
    @State private var includeAllYears: Bool = true      // 年度横断で出題

    /// デフォルト問題数（科目によって変わる想定）
    private var numQuestions: Int {
        numQuestionsOverride ?? session.subjects.count * 10
    }

    var body: some View {
        Form(content: {
            Section(header: Text("時間帯を選択")) {
                Picker("時間帯", selection: $session) {
                    ForEach(ExamSession.allCases) { s in
                        Text("\(s.title) (\(s.subjects.joined(separator: "・")))")
                            .tag(s)
                    }
                }
            }

            Section(header: Text("出題設定")) {
                Toggle("全年度から出題（推奨）", isOn: $includeAllYears)

                Stepper(
                    "出題数: \(numQuestions)",
                    value: Binding(
                        get: { numQuestionsOverride ?? numQuestions },
                        set: { numQuestionsOverride = $0 }
                    ),
                    in: 5...200
                )
            }

            Section {
                NavigationLink(
                    destination: MockExamView(
                        session: session,
                        numQuestions: numQuestions,
                        includeAllYears: includeAllYears
                    )
                ) {
                    Text("模擬試験を開始")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        })
        .navigationTitle("模擬試験設定")
    }
}

struct MockSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MockSetupView()
        }
    }
}
