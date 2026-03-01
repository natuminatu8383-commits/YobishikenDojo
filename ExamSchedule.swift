//
//  ExamSchedule.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/20.
//

import Foundation

/// 予備試験・短答の公式時間割に合わせたセッション
enum ExamSession: CaseIterable, Identifiable {
    case morning90   // 9:45–11:15（90分） 民法・商法・民事訴訟法
    case noon60      // 12:00–13:00（60分） 憲法・行政法
    case afternoon60 // 14:15–15:15（60分） 刑法・刑事訴訟法
    case evening90   // 16:00–17:30（90分） 一般教養科目

    var id: String { title }

    var title: String {
        switch self {
        case .morning90:   return "第1時限（90分）"
        case .noon60:      return "第2時限（60分）"
        case .afternoon60: return "第3時限（60分）"
        case .evening90:   return "第4時限（90分）"
        }
    }

    /// 制限時間（分）
    var durationMinutes: Int {
        switch self {
        case .morning90, .evening90: return 90
        case .noon60, .afternoon60:  return 60
        }
    }

    /// その時限に含まれる科目（JSONの subject と一致する文字列）
    var subjects: [String] {
        switch self {
        case .morning90:   return ["民法", "商法", "民事訴訟法"]
        case .noon60:      return ["憲法", "行政法"]
        case .afternoon60: return ["刑法", "刑事訴訟法"]
        case .evening90:   return ["一般教養"]
        }
    }

    /// デフォルト出題数（必要なら調整）
    var defaultNumQuestions: Int {
        switch self {
        case .morning90:   return 30   // 目安
        case .noon60:      return 20
        case .afternoon60: return 20
        case .evening90:   return 30
        }
    }
}
