//
//  QuizMode.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/20.
//

import Foundation

/// クイズの出題モードを表す列挙型
enum QuizMode: Equatable {
    /// 年度指定モード（例: "平成28年"）
    case year(String)
    
    /// ランダム10問
    case random
    
    /// 模擬試験形式
    case mock
    
    /// ⭕️❌（正誤問題モード）
    case ox
}

