import SwiftUI

struct ReviewQuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var questions: [Question] = []
    @State private var selectedAnswers: Set<Int> = []
    @State private var isCorrect: Bool? = nil
    @State private var isFinished = false
    @State private var removedCount = 0
    @State private var selectedAnswer: Int? = nil   // 選択した解答番号

    init() {
        _questions = State(initialValue: ReviewManager.shared.getWrongQuestions())
    }

    var body: some View {
        VStack(spacing: 20) {
            if isFinished {
                VStack(spacing: 16) {
                    Text("✅ 復習モード終了！")
                        .font(.title)
                        .foregroundColor(.brown)

                    Text("今回削除できた問題数: \(removedCount)")
                        .foregroundColor(.green)

                    Text("残りの復習問題数: \(ReviewManager.shared.getWrongQuestions().count)")
                        .foregroundColor(.red)
                }
            } else if questions.isEmpty {
                VStack {
                    Text("復習する問題はありません")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            } else {
                VStack(spacing: 16) {
                    Text(questions[currentQuestionIndex].title)
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text(questions[currentQuestionIndex].text)
                        .padding()

                    ForEach(0..<questions[currentQuestionIndex].choices.count, id: \.self) { i in
                        Button(action: {
                            selectedAnswer = i
                            checkAnswer(i)   // ← ここで i を渡す！
                        }) {
                            Text(questions[currentQuestionIndex].choices[i])
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedAnswer == i ? Color.yellow : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }

                    if let isCorrect = isCorrect {
                        Text(isCorrect ? "⭕️ 正解！" : "❌ 不正解")
                            .foregroundColor(isCorrect ? .green : .red)
                            .font(.headline)

                        if isCorrect {
                            Button("次へ進む") {
                                removeCurrentQuestion()
                            }
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        } else {
                            Button("次へ進む") {
                                goToNextQuestion()
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - 回答処理
    private func checkAnswer(_ index: Int) {
        guard selectedAnswer != nil else { return }  // ← これでOK
        isCorrect = questions[currentQuestionIndex].answerIndex.contains(index)
        
        // 以降の処理はそのまま
    }

    private func removeCurrentQuestion() {
        // 正解ならリストから削除
        var current = ReviewManager.shared.getWrongQuestions()
        let removed = questions[currentQuestionIndex]
        current.removeAll { $0.id == removed.id }

        if let encoded = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(encoded, forKey: "wrongQuestions")
        }

        removedCount += 1
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            isCorrect = nil
        } else {
            isFinished = true
        }
    }
}
