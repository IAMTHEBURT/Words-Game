//
//  LetterModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation
import CoreData

class Letter: Identifiable {
    let id: UUID = UUID()
    var state: LetterState = .unanswered
    var character: String = ""
    var createdAt: Date = Date()

    init(character: String) {
        self.character = character
        // self.id = position
    }

    init(character: String, state: LetterState) {
        self.character = character
        self.state = state
        // self.id = position
    }

    init(createdAt: Date, character: String, state: LetterState) {
        self.character = character
        self.state = state
        self.createdAt = createdAt
    }

    func setState(state: LetterState) {
        self.state = state
    }

    static func emptyInit(character: String = "") -> Letter {
        return Letter(character: character, state: .unanswered)
    }
}
