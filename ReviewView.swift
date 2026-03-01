import SwiftUI

struct ReviewView: View {
    @State private var wrongQuestions = ReviewManager.shared.getWrongQuestions()

    var body: some View {
        VStack {
            if wrongQuestions.isEmpty {
                Text("復習する問題はありません")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                NavigationLink(
                    destination: QuizView(questions: wrongQuestions)
                ) {
                    Text("復習を始める (\(wrongQuestions.count)問)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.orange)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.top, 40)

                Button("復習問題を全消去") {
                    ReviewManager.shared.clearAll()
                    wrongQuestions = []
                }
                .padding(.top, 20)
                .foregroundColor(.red)
            }
        }
    }
}
