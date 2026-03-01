//
//  StartView.swift
//  YobishikenDojo
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // 背景（イラストのみ）
                Image("start_background.png")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // タイトル文字をSwiftUIで表示
                    Text("パンクズ過去問\nリスト")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.35, green: 0.22, blue: 0.15)) // こげ茶
                        .multilineTextAlignment(.center)
                        .shadow(radius: 2)
                        .padding(.top, -40)
                    
                    Spacer()
                    
                    // ボタン
                    NavigationLink(destination: MenuView()) {
                        Text("予備試験")
                            .font(.system(size: 22, weight: .bold, design: .rounded)) // ポップで読みやすい丸ゴシック
                            .foregroundColor(Color(red: 1.0, green: 0.98, blue: 0.92)) // 明るい生成り色
                            .padding(.horizontal, 50)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 0.60, green: 0.30, blue: 0.10)) // 赤茶寄りの木目カラー
                            )
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 3, y: 3)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

