import SwiftUI

struct MockExamView: View {
    let session: ExamSession
    let numQuestions: Int
    let includeAllYears: Bool

    @State private var currentSubjectIndex = 0
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    @State private var isBreakTime = false
    @State private var showWarning = false
    @State private var isFinished = false
    @State private var score = 0
    @State private var wrongQuestions: [Question] = []

    var body: some View {
        VStack(spacing: 20) {
            if isFinished {
                VStack(spacing: 16) {
                    Text("模擬試験終了！")
                        .font(.title)
                        .foregroundColor(.brown)

                    Text("合計スコア: \(score)")
                        .foregroundColor(.green)

                    NavigationLink(destination: ReviewQuizView()) {
                        Text("復習モードで間違えた問題を解く")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else if isBreakTime {
                VStack(spacing: 16) {
                    Text("休憩時間")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("残り時間: \(timeString(from: timeRemaining))")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            } else {
                VStack(spacing: 16) {
                    Text("\(session.title) 試験")
                        .font(.title2)
                        .foregroundColor(.brown)

                    Text("残り時間: \(timeString(from: timeRemaining))")
                        .font(.headline)
                        .foregroundColor(showWarning ? .red : .black)

                    if showWarning {
                        Text("⚠️ 残り10分です")
                            .foregroundColor(.red)
                            .font(.headline)
                    }

                    Button("この科目を終了する") {
                        finishSubject()
                    }
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .onAppear {
            startExam()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - 試験開始
    private func startExam() {
        timeRemaining = session.durationMinutes * 60
        startTimer()
    }

    // MARK: - タイマー処理
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1

            if timeRemaining == 600 {
                showWarning = true
            }

            if timeRemaining <= 0 {
                timer?.invalidate()
                finishSubject()
            }
        }
    }

    // MARK: - 科目終了
    private func finishSubject() {
        timer?.invalidate()
        showWarning = false
        score += Int.random(in: 5...15)
        finishExam()
    }

    // MARK: - 全試験終了
    private func finishExam() {
        isFinished = true
        isBreakTime = false
        timer?.invalidate()
    }

    // MARK: - 秒数を mm:ss に変換
    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

struct MockExamView_Previews: PreviewProvider {
    static var previews: some View {
        MockExamView(session: .morning90, numQuestions: 20, includeAllYears: true)
    }
}
