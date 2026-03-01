//
//  ReviewResultView.swift
//  YobishikenDojo
//
//  Created by J J on 2025/09/20.
//
import SwiftUI

struct ReviewResultView: View {
    let removedCount: Int
    let remainingCount: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("復習モード 結果")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.brown)
                .padding(.top, 40)

            Text("正解して削除された問題: \(removedCount) 問")
                .font(.title2)
                .foregroundColor(.green)

            Text("まだ残っている問題: \(remainingCount) 問")
                .font(.title2)
                .foregroundColor(.red)

            Spacer()

            NavigationLink(destination: ReviewQuizView()) {
                Text("再挑戦する")
                    .padding()
                    .frame(maxWidth: 250)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: MenuView()) {
                Text("メニューに戻る")
                    .padding()
                    .frame(maxWidth: 250)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}

