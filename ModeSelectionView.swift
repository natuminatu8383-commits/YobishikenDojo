import SwiftUI

struct ModeSelectionView: View {
    let mode: QuizMode   // ← Menu/YearSelection から受け取る
    
    var body: some View {
        VStack(spacing: 20) {
            // 見出しタイトル
            Text(titleText())
                .font(.title)
                .foregroundColor(.brown)
                .padding(.bottom, 10)
            
            // 各科目リスト
            ForEach(subjects, id: \.self) { subject in
                NavigationLink(destination: destinationView(for: subject)) {
                    Text(subject)
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                        .frame(maxWidth: 220)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            // ✅ 全科目シャッフル追加
            NavigationLink(destination: destinationView(for: "全科目シャッフル")) {
                Text("🌏 全科目シャッフル")
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                    .frame(maxWidth: 250)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("科目選択")
    }
    
    // MARK: - 科目一覧
    private let subjects = [
        "民法", "憲法", "刑法", "会社法", "行政法",
        "刑事訴訟法", "民事訴訟法", "一般教養"
    ]
    
    // MARK: - 遷移先生成
    @ViewBuilder
    private func destinationView(for subject: String) -> some View {
        switch mode {
        case .year(let y):
            QuizView(questions: loadQuestionsFromJSON(subject: subject == "全科目シャッフル" ? nil : subject, year: y))
            
        case .random:
            let all = loadQuestionsFromJSON(subject: subject == "全科目シャッフル" ? nil : subject, year: nil)
            QuizView(questions: Array(all.shuffled().prefix(10)))
            
        case .mock:
            let all = loadQuestionsFromJSON(subject: subject == "全科目シャッフル" ? nil : subject, year: nil)
            QuizView(questions: Array(all.shuffled().prefix(20))) // 模擬試験用20問
            
        case .ox:
            // ✅ ○×モード（choicesが2択のものだけ抽出）
            let all = loadQuestionsFromJSON(subject: subject == "全科目シャッフル" ? nil : subject, year: nil)
            let oxQuestions = all.filter { $0.choices.count == 2 }
            QuizView(questions: Array(oxQuestions.shuffled().prefix(10)))
        }
    }
    
    // MARK: - タイトル文言
    private func titleText() -> String {
        switch mode {
        case .year(let y): return "\(y) の問題を解く"
        case .random:      return "ランダム出題モード"
        case .mock:        return "模擬試験モード"
        case .ox:          return "⭕️❌モード（正誤問題）"
        }
    }
}

struct ModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionView(mode: .random)
    }
}
