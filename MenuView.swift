//
//  MenuView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/20.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // 背景グラデーション
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.96, blue: 0.90),
                        Color(red: 0.95, green: 0.92, blue: 0.80)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // タイトル
                    Text("パンクズ過去問リスト")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.brown)
                        .padding(.bottom, 10)

                    // 年度別
                    NavigationLink(destination: YearSelectionView()) {
                        Text("📘 年度別モード")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.brown)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }

                    // ランダム10問
                    NavigationLink(destination: SubjectSelectionView(year: nil, random: true, mode: .random)) {
                        Text("🎲 ランダム10問")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.orange)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }

                    // 模擬試験
                    NavigationLink(destination: SubjectSelectionView(year: nil, random: false, mode: .mock)) {
                        Text("🧭 模擬試験モード")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }

                    // ⭕️❌モード
                    NavigationLink(destination: SubjectSelectionView(year: nil, random: false, mode: .ox)) {
                        Text("⭕️❌ 正誤モード")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.pink)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }

                    // 復習モード
                    NavigationLink(destination: ReviewView()) {
                        Text("📝 復習モード")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
