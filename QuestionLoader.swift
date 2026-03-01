//
//  QuestionLoader.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/30.
//

import Foundation

/// 現在のクイズモード（デフォルトはランダム）
var currentQuizMode: QuizMode = .random

/// JSONファイルから問題を読み込む
func loadQuestionsFromJSON(subject: String? = "刑法", year: String? = nil) -> [Question] {
    print("🟢 [DEBUG] loadQuestionsFromJSON 開始 ---")

    // 1️⃣ ファイルマップ
    let subjectFileMap: [String: String] = [
        "民法": "minpo",
        "憲法": "kenpo",
        "刑法": "keiho",
        "会社法": "syouho",
        "行政法": "gyousei",
        "民事訴訟法": "minso",
        "刑事訴訟法": "keiso",
        "一般教養": "kyouyo"
    ]

    // 2️⃣ ベース名取得
    let baseName = subjectFileMap[subject ?? "刑法"] ?? "keiho"

    // ✅ OXモード対応：明示的に判定
    var fileName = baseName
    if currentQuizMode == .ox {
        fileName = "\(baseName)_ox"
    }

    print("🟢 [DEBUG] 現在のモード: \(currentQuizMode)")
    print("🟢 [DEBUG] 読み込む予定のファイル名: \(fileName).json")

    var questions: [Question] = []

    // 3️⃣ ファイル探索
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("❌ [DEBUG] \(fileName).json が Bundle に見つかりません")
        print("⚠️ [DEBUG] File Inspector の Target Membership に YobishikenDojo がチェックされているか確認してください")
        return []
    }

    print("✅ [DEBUG] \(fileName).json が見つかりました！ URL: \(url)")

    // 4️⃣ データ読み込み
    do {
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode([Question].self, from: data)
        questions = decoded
        print("🎉 [DEBUG] デコード成功！ \(decoded.count) 問を読み込みました")
    } catch {
        print("❌ [DEBUG] JSON 読み込みまたはデコードエラー: \(error)")
    }

    // 5️⃣ 年度フィルタ（必要な場合のみ）
    if let year = year {
        questions = questions.filter { $0.year == year }
        print("🟢 [DEBUG] 年度フィルタ後: \(questions.count)問 (\(year))")
    }

    print("🟢 [DEBUG] loadQuestionsFromJSON 完了 ---\n")
    return questions
}
