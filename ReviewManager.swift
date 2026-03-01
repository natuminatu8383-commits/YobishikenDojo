import Foundation

class ReviewManager {
    static let shared = ReviewManager()
    private let key = "wrongQuestions"

    private init() {}

    // 保存されている全ての問題を取得
    func getWrongQuestions() -> [Question] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Question].self, from: data) {
            return decoded
        }
        return []
    }

    // 単一の問題を追加（重複チェックあり）
    func addWrongQuestion(_ question: Question) {
        var current = getWrongQuestions()
        if !current.contains(where: { $0.id == question.id }) { // ★ 重複防止
            current.append(question)
        }
        if let encoded = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // 単一の問題を削除
    func removeWrongQuestion(_ question: Question) {
        var current = getWrongQuestions()
        current.removeAll { $0.id == question.id }
        if let encoded = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // 全削除
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
