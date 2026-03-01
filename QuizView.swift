import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss   // 🔑 Navigation戻る用
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var questions: [Question] = []
    @State private var textSize: CGFloat = 16
    @State private var selectedAnswers: Set<Int> = []   // 複数対応
    @State private var isCorrect: Bool? = nil
    @State private var showExplanation = false
    @State private var hasScored = false
    @State private var isFinished = false
    
    // MARK: - 初期化
    init(subject: String? = nil, year: String? = nil) {
        _questions = State(initialValue: loadQuestionsFromJSON(subject: subject, year: year))
    }
    init(questions: [Question]) {
        _questions = State(initialValue: questions)
    }
    
    // MARK: - 本体
    var body: some View {
        ZStack(alignment: .topTrailing) {
            backgroundView
            
            if questions.isEmpty {
                emptyView
            } else if isFinished {
                resultView
            } else {
                questionView
            }
            
            fontSizeControl
        }
    }
    
    // MARK: - 背景
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.98, green: 0.96, blue: 0.90),
                Color(red: 0.95, green: 0.92, blue: 0.80)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - 空のとき
    private var emptyView: some View {
        Text("問題が見つかりません")
            .foregroundColor(.red)
            .font(.headline)
    }
    
    // MARK: - 結果画面
    private var resultView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("終了！")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.brown)
            
            Text("スコア: \(score) / \(questions.count)")
                .font(.title)
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                // 🔙 前の画面に戻る
                Button(action: {
                    dismiss()
                }) {
                    Text("◀️ 前の画面に戻る")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.brown)
                        .cornerRadius(10)
                }
                
                // 🔁 もう一回
                Button(action: {
                    currentQuestionIndex = 0
                    score = 0
                    isFinished = false
                    selectedAnswers = []
                    isCorrect = nil
                    hasScored = false
                    showExplanation = false
                }) {
                    Text("🔁 もう一回")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.98, green: 0.96, blue: 0.90))
        .ignoresSafeArea()
    }
    
    // MARK: - 問題ビュー
    private var questionView: some View {
        let question = questions[currentQuestionIndex]
        let isMultiple = question.answerIndex.count > 1
        
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("予備試験 過去問道場")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.brown)
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("進行: \(currentQuestionIndex + 1)/\(questions.count) | スコア: \(score)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.brown)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Q\(question.number) (\(question.subject)・\(question.year))")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.brown)
                
                Text(question.text)
                    .font(.system(size: textSize))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                // 選択肢
                VStack(spacing: 12) {
                    ForEach(0..<question.choices.count, id: \.self) { index in
                        Button(action: {
                            if isMultiple {
                                toggleAnswer(index)
                            } else {
                                selectedAnswers = [index]
                                checkAnswer()
                            }
                        }) {
                            HStack {
                                if isMultiple {
                                    Image(systemName: selectedAnswers.contains(index) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(.brown)
                                }
                                Text("\(index + 1).")
                                    .bold()
                                    .foregroundColor(.brown)
                                    .font(.system(size: textSize))
                                Text(question.choices[index])
                                    .foregroundColor(.black)
                                    .font(.system(size: textSize))
                                Spacer()
                            }
                            .padding()
                            .background(optionBackground(index: index, isMultiple: isMultiple))
                            .cornerRadius(10)
                        }
                    }
                }
                
                // 複数選択用の「解答する」ボタン
                if isMultiple && !selectedAnswers.isEmpty {
                    Button("解答する") {
                        checkAnswer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 10)
                }
                
                // 判定と解説
                explanationView(question: question)
                
                // 次の問題へ
                if isCorrect != nil {
                    Button("次の問題へ") {
                        goToNextQuestion()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 背景色切替
    private func optionBackground(index: Int, isMultiple: Bool) -> Color {
        if isCorrect != nil {
            if questions[currentQuestionIndex].answerIndex.contains(index) {
                return Color.green.opacity(0.7)
            } else if selectedAnswers.contains(index) &&
                        !questions[currentQuestionIndex].answerIndex.contains(index) {
                return Color.red.opacity(0.7)
            }
        }
        return Color(red: 0.98, green: 0.96, blue: 0.90).opacity(0.9)
    }
    
    // MARK: - 判定と解説
    private func explanationView(question: Question) -> some View {
        Group {
            if let correct = isCorrect {
                VStack(alignment: .leading, spacing: 8) {
                    Text(correct ? "正解！" : "不正解…")
                        .foregroundColor(correct ? .green : .red)
                        .font(.system(size: textSize, weight: .bold))
                    
                    Button(action: {
                        withAnimation { showExplanation.toggle() }
                    }) {
                        Text(showExplanation ? "📖 解説を隠す" : "📖 解説を見る")
                            .font(.system(size: textSize, weight: .semibold))
                            .foregroundColor(.brown)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.brown, lineWidth: 1.5)
                            )
                    }
                    .padding(.top, 4)
                    
                    if showExplanation {
                        ExplanationNote(
                            text: question.explanations.joined(separator: "\n"),
                            textSize: textSize
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
    }
    
    // MARK: - 選択処理
    private func toggleAnswer(_ index: Int) {
        if selectedAnswers.contains(index) {
            selectedAnswers.remove(index)
        } else {
            selectedAnswers.insert(index)
        }
    }
    
    private func checkAnswer() {
        let correctSet = Set(questions[currentQuestionIndex].answerIndex)
        isCorrect = (selectedAnswers == correctSet)
        
        if !hasScored {
            if isCorrect == true {
                score += 1
            } else {
                ReviewManager.shared.addWrongQuestion(questions[currentQuestionIndex])
            }
            hasScored = true
        } else {
            if isCorrect == true {
                ReviewManager.shared.removeWrongQuestion(questions[currentQuestionIndex])
            } else {
                ReviewManager.shared.addWrongQuestion(questions[currentQuestionIndex])
            }
        }
    }
    
    private func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswers = []
            isCorrect = nil
            hasScored = false
            showExplanation = false
        } else {
            isFinished = true
        }
    }
    
    // MARK: - 補助ビュー
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
    
    struct ExplanationNote: View {
        let text: String
        let textSize: CGFloat
        
        var body: some View {
            ScrollView {
                Text(text)
                    .foregroundColor(.black)
                    .font(.system(size: textSize))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        ZStack {
                            Color.yellow.opacity(0.6)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Color.orange.opacity(0.3)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Triangle())
                                }
                            }
                        }
                    )
                    .cornerRadius(6)
            }
            .frame(maxHeight: 200)
        }
    }
    
    // MARK: - 文字サイズ調整
    private var fontSizeControl: some View {
        HStack {
            Button(action: {
                textSize = max(8, textSize - 2)
            }) {
                Text("あ-")
                    .font(.system(size: 18, weight: .bold))
                    .padding(4)
                    .background(Color.brown.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Button(action: {
                if textSize < 45 { textSize += 2 }
            }) {
                Text("あ+")
                    .font(.system(size: 18, weight: .bold))
                    .padding(4)
                    .background(Color.brown.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
}
