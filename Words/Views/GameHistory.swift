//
//  GameHistory.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct GameHistory: View {

    // MARK: - PROPERTIES

    @StateObject var gameHistoryVM: GameHistoryViewModel = GameHistoryViewModel(context: CoreDataProvider.shared.viewContext)

    @Environment(\.presentationMode) var presentationMode

    // MARK: - BODY

    var body: some View {
        ZStack {
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)

            if gameHistoryVM.games.isEmpty {
                VStack {
                    Image("empty_history")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("Здесь пока пусто\nОтличный повод начать!")
                        .modifier(MyFont(font: "Inter", weight: "Bold", size: 16))
                }
                .multilineTextAlignment(.center)
            }

            VStack(spacing: 0) {
                // MARK: - PAGE HEADER
                PageHeaderView(title: "История игр")
                    .padding(.horizontal, 16)
                    .offset(y: 2)

                ScrollView(.vertical, showsIndicators: false) {

                    VStack {
                        Spacer()
                            .frame(height: 66)

                        LazyVStack {
                            ForEach(gameHistoryVM.games) { game in
                                GameHistoryElementView(gameHistoryModel: game)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                        .accessibilityIdentifier("gameHistory")
                    } //: MAIN VSTACK
                } //: SCROLL VIEW
            }

        } //: VSTACK

    }
}

// MARK: - PREVIW

struct GameHistory_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameHistory()
        }
    }
}
