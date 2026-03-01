//
//  MockResultView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/20.
//
import SwiftUI

struct MockResultView: View {
    let questions: [Question]
    let answers: [Int?]
    let flagged: Set<Int>

    private var score: Int {
        questions.indices.filter { i in
            if let ans = answers[i] {
                return questions[i].answerIndex.contains(ans)
            }
            return false
        }.count
    }

    private var wrongQuestions: [Question] {
        questions.indices.compactMap { i in
            if let ans = answers[i],
               !questions[i].answerIndex.contains(ans) {
                return questions[i]
            } else {
                return nil
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("模擬試験 結果")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brown)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text("正解数: \(score)/\(questions.count)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.green)

                    Text("誤答: \(wrongQuestions.count) 問")
                        .font(.system(size: 18))
                        .foregroundColor(.red)

                    if !wrongQuestions.isEmpty {
                        Divider().padding(.vertical, 10)
                        Text("復習用リスト")
                            .font(.headline)
                            .foregroundColor(.brown)

                        ForEach(wrongQuestions) { q in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Q\(q.number): \(q.text)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                if !q.explanations.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(q.explanations.indices, id: \.self) { i in
                                            Text("解説 (\(i+1)): \(q.explanations[i])")
                                                .font(.system(size: 14))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(red: 0.98, green: 0.96, blue: 0.90))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("結果")
        }
    }
}

