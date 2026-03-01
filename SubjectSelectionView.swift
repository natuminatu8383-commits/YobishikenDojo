//
//  SubjectSelectionView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/10/05.
//

import SwiftUI

struct SubjectSelectionView: View {
    let year: String?      // 年度（年度モードで使用）
    let random: Bool       // ランダムモードかどうか
    let mode: QuizMode?    // ⭕️❌・模擬試験などの判定用（オプション）

    /// 科目リスト
    let subjects = [
        "民法", "憲法", "刑法", "商法", "行政法",
        "民事訴訟法", "刑事訴訟法", "一般教養", "全シャッフル"
    ]

    // ✅ initを追加（modeが指定されていたら反映）
    init(year: String?, random: Bool, mode: QuizMode?) {
        self.year = year
        self.random = random
        self.mode = mode

        if let mode = mode {
            currentQuizMode = mode
            print("🟢 [DEBUG] SubjectSelectionView init: currentQuizMode = \(mode)")
        }
    }

    var body: some View {
        List(subjects, id: \.self) { subject in
            if let mode = mode {
                switch mode {
                case .ox:
                    // ✅ ⭕️❌モード（OXLevelViewに遷移）
                    NavigationLink(
                        destination: OXLevelView(subject: subject),
                        label: {
                            Text("\(subject)（⭕️❌10問）")
                                .font(.system(size: 18, weight: .medium))
                                .padding(.vertical, 8)
                        }
                    )

                case .mock:
                    // 模擬試験モード
                    NavigationLink(
                        destination: {
                            let all = loadQuestionsFromJSON(subject: subject, year: nil)
                            let selected = Array(all.shuffled().prefix(20))
                            QuizView(questions: selected)
                        },
                        label: {
                            Text("\(subject)（模試20問）")
                                .font(.system(size: 18, weight: .medium))
                                .padding(.vertical, 8)
                        }
                    )

                default:
                    // 通常 or ランダム
                    subjectButton(subject: subject)
                }

            } else {
                // modeがnil（普通のランダム・年度別）
                subjectButton(subject: subject)
            }
        }
        .navigationTitle("科目選択")
    }

    // MARK: - 通常モード（年度別 or ランダム）
    @ViewBuilder
    private func subjectButton(subject: String) -> some View {
        if random {
            NavigationLink(
                destination: {
                    let all = loadQuestionsFromJSON(subject: subject, year: nil)
                    let selected = Array(all.shuffled().prefix(10))
                    QuizView(questions: selected)
                },
                label: {
                    Text("\(subject) (ランダム10問)")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.vertical, 8)
                }
            )
        } else {
            NavigationLink(
                destination: QuizView(questions: loadQuestionsFromJSON(subject: subject, year: year)),
                label: {
                    Text(subject)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.vertical, 8)
                }
            )
        }
    }
}
