import SwiftUI

struct ContentView: View {
    @StateObject private var quiz = QuizManager()

    var body: some View {
        NavigationView {
            Group {
                if let q = quiz.current {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            header

                            Text("Q\(q.number)（\(q.subject)・\(q.year)）")
                                .font(.headline)

                            Text(q.text)
                                .font(.body)

                            VStack(spacing: 10) {
                                ForEach(q.choices.indices, id: \.self) { i in
                                    ChoiceRow(
                                        index: i,
                                        text: q.choices[i],
                                        selected: quiz.selectedIndex == i
                                    ) {
                                        quiz.select(i)
                                    }
                                }
                            }

                            if quiz.showResult {
                                resultCard(q)
                            }

                            Button {
                                quiz.next()
                            } label: {
                                Text(quiz.index == (quiz.questions.count - 1) ? "最初からもう一度" : "次の問題へ")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 4)
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("問題を読み込めませんでした")
                        Button("再読み込み") { quiz.start() }
                    }
                }
            }
            .navigationTitle("予備試験 過去問道場")
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "graduationcap")
            Text("進行: \(quiz.progressText)｜スコア: \(quiz.scoreText)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func resultCard(_ q: Question) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: quiz.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(quiz.isCorrect ? .green : .red)
                Text(quiz.isCorrect ? "正解！" : "不正解")
                    .font(.title3).bold()
            }
            Text("【正解】 \(q.answerIndex.map { labelFor($0) }.joined(separator: ", "))")
                .font(.subheadline).bold()
            Text("【解説】\(q.explanations[quiz.selectedIndex ?? 0])")
                .font(.footnote)
                .foregroundStyle(.secondary)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(quiz.isCorrect ? Color.green.opacity(0.4) : Color.red.opacity(0.4), lineWidth: 1)
        )
        .padding(.top, 8)
    }

    private func labelFor(_ i: Int) -> String {
        switch i {
        case 0: return "1"
        case 1: return "2"
        case 2: return "3"
        case 3: return "4"
        case 4: return "5"
        default: return "\(i+1)"
        }
    }
}

struct ChoiceRow: View {
    let index: Int
    let text: String
    let selected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 8) {
                Text(optionLabel(index))
                    .font(.subheadline).bold()
                    .padding(.top, 2)
                Text(text).frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(selected ? Color.gray.opacity(0.15) : Color.gray.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selected ? Color.accentColor : Color.gray.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    private func optionLabel(_ i: Int) -> String {
        switch i {
        case 0: return "1"
        case 1: return "2"
        case 2: return "3"
        case 3: return "4"
        case 4: return "5"
        default: return "\(i+1)"
        }
    }
}

#Preview {
    ContentView()
}
