//
//  Question.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/11.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let year: String
    let subject: String
    let number: Int
    let text: String
    let choices: [String]
    let answerIndex: [Int]
    let explanations: [String]

    // ✅ 追加: OX問題用フィールド（JSONに "oxAnswer" がある場合に対応）
    let oxAnswer: String?    // "○" または "×" を格納
    let oxExplanation: String?  // OXモード専用の簡単解説

    // デコード時にUUIDを自動生成するようカスタムイニシャライザを追加
    init(
        id: UUID = UUID(),
        year: String,
        subject: String,
        number: Int,
        text: String,
        choices: [String],
        answerIndex: [Int],
        explanations: [String],
        oxAnswer: String? = nil,
        oxExplanation: String? = nil
    ) {
        self.id = id
        self.year = year
        self.subject = subject
        self.number = number
        self.text = text
        self.choices = choices
        self.answerIndex = answerIndex
        self.explanations = explanations
        self.oxAnswer = oxAnswer
        self.oxExplanation = oxExplanation
    }

    // MARK: - 表示用タイトル
    var title: String {
        return "\(subject)（\(year) 第\(number)問）"
    }

    // MARK: - OX判定を使いやすくするための便利プロパティ
    var isOXMode: Bool {
        return oxAnswer != nil
    }

    // MARK: - 正解テキスト取得
    func correctAnswerText() -> String {
        if let ox = oxAnswer {
            return ox  // ○ or ×
        } else {
            // 通常の選択肢問題なら choices から正答インデックスを参照
            let indexes = answerIndex
            let valid = indexes.compactMap { i in
                i < choices.count ? choices[i] : nil
            }
            return valid.joined(separator: ", ")
        }
    }

    // MARK: - 解説取得
    func explanationText() -> String {
        if let oxExp = oxExplanation {
            return oxExp
        } else {
            return explanations.joined(separator: "\n")
        }
    }
}

// MARK: - JSON読み込み関数
func loadQuestions() -> [Question] {
    guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("❌ JSONファイルが見つからない、または読み込み失敗")
        return []
    }

    do {
        let decoder = JSONDecoder()
        let questions = try decoder.decode([Question].self, from: data)
        return questions
    } catch {
        print("❌ JSONデコードエラー: \(error)")
        return []
    }
}
