//
//  GameResultAlertView.swift
//  Words
//
//  Created by Иван Львов on 13.12.2022.
//

import SwiftUI

struct GameResultAlertView: View {
    @StateObject var playVM: PlayViewModel
    @Binding var countDownTrigger: Bool

    var body: some View {
        ZStack {
            Spacer()
                .background(.thinMaterial.opacity(0.90))
                .frame(minWidth: 0, maxWidth: .infinity)

            VStack(alignment: .center, spacing: 10) {
                Text(playVM.gameType.name.uppercased())
                    .padding(10)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(playVM.gameType.color)
                    )

                Text("День \(341)")
                    .fontWeight(.medium)

                Text("Загаданное слово: \(playVM.finalWord)")

                if let gameHistory = playVM.gameHistory {
                    MiniPlayField(gameHistoryModel: gameHistory)
                        .frame(maxWidth: 150)
                }

                Text("\(playVM.tries) попыток из \(playVM.maxTries)")

                if playVM.gameType == .dailyWord {
                    Text("Следущее слово через")

                    CountDownView(till: APIProvider.shared.wordOfTheDayResponse?.next_at ?? 1670976000, countDownTrigger: $countDownTrigger)

                    Text("Вы можете продолжить угадывать случайные слова")
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 10) {
                    Button(action: {
                        playVM.isShareSheetPresented = true
                    }) {
                        Text("Отправить другу")
                            .frame(minWidth: 200)
                    }
                    .buttonStyle(DefaultButtonStyle())

                    Button(action: {
                        playVM.setGame(gameType: .progression)
                    }) {
                        Text("Следущее слово")
                            .frame(minWidth: 200)
                    }
                    .buttonStyle(DefaultButtonStyle(bgColor: Color(hex: "#E5E9F9")))
                }
            }
            .frame(minWidth: UIScreen.main.bounds.width * 0.8)
            .foregroundColor(.black)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
            }
            .overlay(
                Image(systemName: "xmark")
                    .offset(x: -20, y: 20)
                    .foregroundColor(.black)
                    .onTapGesture {
                        playVM.isResultAlertPresented = false
                    }
                ,
                alignment: .topTrailing
            )

            .onChange(of: countDownTrigger) { _ in
                playVM.activateNewWord()
        }
        }
    }
}

struct GameResultAlertView_Previews: PreviewProvider {
    static let playVM = PlayViewModel()
    static var gameDBM: GameDBM {
        let game = GameDBM(context: CoreDataProvider.shared.viewContext)
        game.result = 1
        game.gameType = 1

        let letter1 = LetterDBM(context: CoreDataProvider.shared.viewContext)
        letter1.character = "Р"
        letter1.game = game

        let letter2 = LetterDBM(context: CoreDataProvider.shared.viewContext)
        letter2.character = "О"
        letter2.game = game

        let letter3 = LetterDBM(context: CoreDataProvider.shared.viewContext)
        letter3.character = "М"
        letter3.game = game

        let letter4 = LetterDBM(context: CoreDataProvider.shared.viewContext)
        letter4.character = "А"
        letter4.game = game

        let letter5 = LetterDBM(context: CoreDataProvider.shared.viewContext)
        letter5.character = "Н"
        letter5.game = game

        return game

    }

    static var gameModel: GameHistoryModel {
        return GameHistoryModel(gameDBM: gameDBM)
    }

    static var playViewModel: PlayViewModel {
        let playVM = PlayViewModel()
        playVM.gameHistory = gameModel
        return playVM
    }

    static var previews: some View {

        GameResultAlertView(playVM: playViewModel, countDownTrigger: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
