//
//  MiniPlayField.swift
//  Words
//
//  Created by Иван Львов on 13.12.2022.
//

import SwiftUI

struct MiniPlayField: View {
    private var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(), spacing: 0), count: gameHistoryModel.word.count)
    }
    
    var gameHistoryModel: GameHistoryModel
    
    var lettersArray: [Letter]{
        if gameHistoryModel.letters.isEmpty{
            var array: [Letter] = []
            let totalNumberOfLetters = gameHistoryModel.word.count * 6
            for _ in 1...totalNumberOfLetters{
                array.append(Letter(character: "", state: .unanswered))
            }
            return array
        }else{
            return gameHistoryModel.letters.sorted { $0.createdAt < $1.createdAt }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: gridLayout, spacing: 2){
            ForEach(lettersArray) { letter in
                Text(letter.character)
                    .modifier(SquareLetterModifier(letter.state, size: 20, fontSize: 14))
            }
        }
        .frame(height: 150)
    }
}

struct MiniPlayField_Previews: PreviewProvider {
    
    static var previews: some View {
        MiniPlayField(gameHistoryModel: GameHistoryModel(gameDBM: GameDBM.emptyInit()))
            .previewLayout(.sizeThatFits)
            .frame(width: 108, height: 130)
    }
}
