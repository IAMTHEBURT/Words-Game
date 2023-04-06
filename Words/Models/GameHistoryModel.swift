//
//  GameHistoryModel.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import CoreData

struct GameHistoryModel: Identifiable {
    var gameDBM: GameDBM

    init(gameDBM: GameDBM) {
        self.gameDBM = gameDBM
    }

    var id: NSManagedObjectID {
        gameDBM.objectID
    }

    var duration: Int {
        Int(gameDBM.duration)
    }

    var date: Date {
        gameDBM.date ?? Date()
    }

    var gameType: GameType {
        return GameType(rawValue: Int(gameDBM.gameType)) ?? .progression
    }

    var word: String {
        gameDBM.word ?? ""
    }

    var result: GameResult {
        return GameResult(rawValue: Int(gameDBM.result)) ?? .win
    }

    var letters: [Letter] {
        var letters: [Letter] = []
        gameDBM.letters?.forEach({ letterDBM in
            if let letterDBM = letterDBM as? LetterDBM {
                let createdAt = letterDBM.createdAt ?? Date()
                let character = letterDBM.character ?? ""
                let state = LetterState(rawValue: Int(letterDBM.state)) ?? .rightLetterRightPlace
                let letter = Letter(createdAt: createdAt, character: character, state: state)
                letters.append(letter)
            }
        })
        return letters
    }

    // Number of lines
    var tries: Int {
        var nonEmptyLetters = 0

        letters.forEach { letter in
            if letter.character != ""{
                nonEmptyLetters += 1
            }
        }

        return nonEmptyLetters / word.count
    }
}
