//
//  OXLevelView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/10/07.
//

import SwiftUI
import AVFoundation

struct OXLevelView: View {
    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var correctCount = 0
    @State private var answeredCount = 0
    @State private var showGoal = false
    @State private var showCrumb = Array(repeating: true, count: 10)
    @State private var sparrowOffset: CGFloat = -110
    @State private var feedbackMessage = ""
    @State private var showFeedback = false
    @State private var showExplanation = false
    @State private var hardMode = false
    @State private var showGlowPath = false
    @State private var showDoor = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var textSize: Double = 22

    let subject: String

    init(subject: String) {
        self.subject = subject
        currentQuizMode = .ox
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.96, blue: 1.0), .white]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 4) {
                // タイトル
                Text("⭕️❌ パンくずチャレンジ")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.brown)
                    .padding(.top, 2)

                // ハードモード
                Toggle(isOn: $hardMode) {
                    Text("ハードモード（1ミスで最初に戻る）")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.red)
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                .padding(.horizontal, 25)

                // 文字サイズ調整
                HStack(spacing: 6) {
                    Text("文字サイズ")
                        .font(.system(size: 13, weight: .semibold))
                    Slider(value: $textSize, in: 16...28, step: 1)
                        .accentColor(.blue)
                    Text("\(Int(textSize))pt")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .frame(width: 45)
                }
                .padding(.horizontal, 25)

                // 🍞 パンくずレーン
                ZStack(alignment: .bottomLeading) {
                    HStack(spacing: 11) {
                        ForEach(0..<10, id: \.self) { i in
                            if showCrumb[i] {
                                Text("🍞").font(.system(size: 18))
                            } else if showGlowPath {
                                Circle()
                                    .fill(Color.yellow.opacity(0.6))
                                    .frame(width: 15, height: 15)
                                    .shadow(color: .yellow, radius: 5)
                            } else {
                                Color.clear.frame(width: 15, height: 15)
                            }
                        }
                    }
                    .padding(.horizontal, 12)

                    Image("sparrow_normal")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .offset(x: sparrowOffset, y: -8)
                        .animation(.easeInOut(duration: 0.7), value: sparrowOffset)
                }
                .frame(height: 60)
                .offset(y: -10)

                // 出題部
                if currentIndex < questions.count {
                    VStack(spacing: 8) {
                        ScrollView {
                            Text(questions[currentIndex].text)
                                .font(.system(size: textSize, weight: .bold))
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                        .frame(maxHeight: 660)

                        HStack(spacing: 35) {
                            Button(action: { checkAnswer("⭕️") }) {
                                Text("⭕️")
                                    .font(.system(size: 36))
                                    .frame(width: 85, height: 85)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                            Button(action: { checkAnswer("❌") }) {
                                Text("❌")
                                    .font(.system(size: 36))
                                    .frame(width: 85, height: 85)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }

                if showFeedback {
                    Text(feedbackMessage)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .transition(.opacity)
                }
            }

            // 💬 解説オーバーレイ
            if showExplanation {
                VStack(spacing: 15) {
                    Text("【解説】")
                        .font(.system(size: 21, weight: .bold))
                        .foregroundColor(.orange)

                    ScrollView {
                        Text(questions[currentIndex].explanations.first ?? "解説なし")
                            .font(.system(size: textSize - 2))
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                    }
                    .frame(maxHeight: 240)

                    HStack(spacing: 30) {
                        Button("前の問題に戻る") {
                            if currentIndex > 0 { currentIndex -= 1 }
                            showExplanation = false
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("次の問題へ") {
                            showExplanation = false
                            if currentIndex < questions.count - 1 {
                                currentIndex += 1
                            }
                            if answeredCount >= 10 {
                                triggerGoal()
                            }
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.65))
                .cornerRadius(18)
                .padding(25)
                .transition(.opacity)
            }

            // 🎉 合格演出
            if showGoal {
                VStack(spacing: 25) {
                    if showDoor {
                        Image("goal_door")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .shadow(color: .yellow, radius: 15)
                    }

                    Image("sparrow_ok")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .offset(y: showDoor ? -15 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.5), value: showDoor)

                    Text("🎉 10問達成！ 🎉")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.orange)
                        .shadow(color: .yellow, radius: 5)

                    Button("タイトルに戻る") {
                        // TODO: メニューへ遷移
                    }
                    .font(.system(size: 19, weight: .semibold))
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.9))
                .onAppear { playSound("goal_chime") }
            }
        }
        .onAppear { loadOXQuestions() }
    }

    // MARK: - ✅ 問題読み込み（ランダム仕様）
    private func loadOXQuestions() {
        var all = loadQuestionsFromJSON(subject: subject, year: nil)
        var oxQuestions = all.filter { $0.choices.count == 2 }

        // 🔹 JSONが空ならフォールバック（keiho_ox.json）
        if oxQuestions.isEmpty {
            if let url = Bundle.main.url(forResource: "keiho_ox", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let decoded = try? JSONDecoder().decode([Question].self, from: data) {
                oxQuestions = decoded
            }
        }

        // 🔹 JSON全体をシャッフルしてランダム抽出
        oxQuestions.shuffle()
        questions = Array(oxQuestions.prefix(10))

        // 🔹 状態リセット
        currentIndex = 0
        correctCount = 0
        answeredCount = 0

        print("🎲 [DEBUG] \(subject) のOX問題をランダムに10問ロードしました (全: \(oxQuestions.count))")
    }

    // MARK: - 回答
    private func checkAnswer(_ answer: String) {
        guard currentIndex < questions.count else { return }
        let correct = questions[currentIndex].choices[questions[currentIndex].answerIndex.first ?? 0]
        answeredCount += 1

        if answer == correct {
            withAnimation(.easeInOut(duration: 0.6)) {
                showCrumb[correctCount] = false
                sparrowOffset += 28
                feedbackMessage = "🍞 カリッ！ 正解！"
                showFeedback = true
                playSound("crunch")
            }
            correctCount += 1
        } else {
            feedbackMessage = "❌ 間違い！"
            showFeedback = true
            if hardMode {
                correctCount = 0
                sparrowOffset = -110
                showCrumb = Array(repeating: true, count: 10)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showFeedback = false
            showExplanation = true
        }
    }

    // MARK: - 達成演出
    private func triggerGoal() {
        guard !showGoal else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                showGlowPath = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                    showGoal = true
                    showDoor = true
                }
            }
        }
    }

    // MARK: - 音
    private func playSound(_ name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch { print("⚠️ 音声再生失敗: \(error)") }
        }
    }
}

#Preview {
    OXLevelView(subject: "刑法")
}
