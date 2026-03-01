//
//  SelectionView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/10/05.
//

import SwiftUI

struct SelectionView: View {
    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.92, blue: 0.80),
                    Color(red: 0.98, green: 0.96, blue: 0.90)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // タイトル
                Text("出題形式を選択")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.brown)
                    .padding(.top, 40)

                // MARK: - 科目を選ぶ（通常モード）
                NavigationLink(
                    destination: SubjectSelectionView(year: "平成28年", random: false, mode: nil)
                ) {
                    Text("📘 科目で選ぶ")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }

                // MARK: - 年度を選ぶ
                NavigationLink(
                    destination: YearSelectionView()
                ) {
                    Text("📅 年度で選ぶ")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }

                // MARK: - ランダム10問モード
                NavigationLink(
                    destination: SubjectSelectionView(year: nil, random: true, mode: .random)
                ) {
                    Text("🎲 ランダム10問に挑戦")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }

                // MARK: - 模擬試験モード
                NavigationLink(
                    destination: SubjectSelectionView(year: nil, random: false, mode: .mock)
                ) {
                    Text("🧭 模擬試験モード")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }

                // MARK: - ○×問題モード
                NavigationLink(
                    destination: SubjectSelectionView(year: nil, random: false, mode: .ox)
                ) {
                    Text("⭕️❌ ○×問題モード")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }

                // MARK: - 復習モード
                NavigationLink(destination: ReviewView()) {
                    Text("📝 復習モード")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.teal)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - プレビュー
struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectionView()
        }
    }
}
