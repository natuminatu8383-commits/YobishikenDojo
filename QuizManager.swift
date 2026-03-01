//
//  QuizManager.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/11.
//

import Foundation
import SwiftUI

final class QuizManager: ObservableObject {
    // 公開状態
    @Published private(set) var questions: [Question] = []
    @Published private(set) var index: Int = 0
    @Published private(set) var current: Question?
    @Published var selectedIndex: Int? = nil
    @Published var showResult = false
    @Published var isCorrect = false
    @Published var correctCount = 0

    init() {
        loadQuestions()
        start()
    }

    // Bundle 内の questions.json を読み込み
    private func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("questions.json が見つかりません")
            self.questions = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Question].self, from: data)
            self.questions = decoded.shuffled()  // 毎回ランダム
        } catch {
            print("JSON読み込みエラー: \(error)")
            self.questions = []
        }
    }

    func start() {
        index = 0
        correctCount = 0
        showResult = false
        selectedIndex = nil
        isCorrect = false
        current = questions.isEmpty ? nil : questions[index]
    }

    func select(_ choiceIndex: Int) {
        guard let q = current else { return }
        selectedIndex = choiceIndex
        isCorrect = q.answerIndex.contains(choiceIndex)
        if isCorrect { correctCount += 1 }
        showResult = true
    }

    func next() {
        guard !questions.isEmpty else { return }
        if index < questions.count - 1 {
            index += 1
            current = questions[index]
            selectedIndex = nil
            showResult = false
            isCorrect = false
        } else {
            // 最後まで終わったら再スタート（ひとまず）
            start()
        }
    }

    var progressText: String {
        guard !questions.isEmpty else { return "0 / 0" }
        return "\(index + 1) / \(questions.count)"
    }

    var scoreText: String {
        guard index >= 0 else { return "0 正解" }
        return "\(correctCount) 正解"
    }
}
