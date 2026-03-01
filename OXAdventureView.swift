import SwiftUI

struct OXAdventureView: View {
    @State private var breadcrumbIndex = 0        // 現在食べたパンくず数
    @State private var currentQuestions: [Question] = []
    @State private var currentIndex = 0
    @State private var showEatAnimation = false
    @State private var isCorrect = false
    @State private var showGoal = false

    let subject: String
    
    var body: some View {
        ZStack {
            Image("road_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer()
                
                // パンくずの進行ライン
                HStack(spacing: 22) {
                    ForEach(0..<10, id: \.self) { i in
                        Image(i < breadcrumbIndex ? "breadcrumb_eaten" : "breadcrumb")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .opacity(i == breadcrumbIndex && showEatAnimation ? 0.4 : 1.0)
                            .animation(.easeInOut(duration: 0.6), value: showEatAnimation)
                    }
                }
                .padding(.top, 10)
                
                // スズメの位置（パンくずに合わせて進む）
                ZStack {
                    Image(isCorrect ? "sparrow_happy" : "sparrow_normal")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .offset(x: CGFloat(breadcrumbIndex) * 30 - 120, y: 0)
                        .animation(.spring(), value: breadcrumbIndex)
                }

                Spacer()
                
                // 出題
                if !showGoal {
                    Text(currentQuestions[currentIndex].text)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 50) {
                        Button("⭕️") {
                            answerSelected(0)
                        }
                        .font(.system(size: 36))
                        .frame(width: 80, height: 80)
                        .background(Color.red)
                        .clipShape(Circle())
                        .foregroundColor(.white)

                        Button("❌") {
                            answerSelected(1)
                        }
                        .font(.system(size: 36))
                        .frame(width: 80, height: 80)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                    }
                } else {
                    // 合格画面
                    VStack(spacing: 20) {
                        Image("gate_success")
                            .resizable()
                            .frame(width: 180, height: 180)
                        Text("🎉 合格おめでとう！ 🎉")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.brown)
                        Button("もう一度挑戦") {
                            resetGame()
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .onAppear { loadQuestions() }
    }

    // MARK: - ロジック
    func loadQuestions() {
        let all = loadQuestionsFromJSON(subject: subject, year: nil).filter { $0.choices.count == 2 }
        currentQuestions = Array(all.shuffled().prefix(10))
    }

    func answerSelected(_ index: Int) {
        let question = currentQuestions[currentIndex]
        let correct = question.answerIndex.contains(index)
        
        if correct {
            currentIndex += 1
            if currentIndex >= currentQuestions.count {
                // 全問正解 → パンくずを食べて進む
                eatBreadcrumb()
            }
        } else {
            currentIndex = 0
            loadQuestions()
        }
    }

    func eatBreadcrumb() {
        withAnimation {
            showEatAnimation = true
            breadcrumbIndex += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showEatAnimation = false
            currentIndex = 0
            loadQuestions()
            
            if breadcrumbIndex >= 10 {
                showGoal = true
            }
        }
    }

    func resetGame() {
        breadcrumbIndex = 0
        showGoal = false
        currentIndex = 0
        loadQuestions()
    }
}
