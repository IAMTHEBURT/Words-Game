//
//  GameDBM + Extensions.swift
//  Words
//
//  Created by Иван Львов on 14.12.2022.
//

import Foundation
import CoreData

extension GameDBM: BaseDBModel {
    static var all: NSFetchRequest<GameDBM> {
        let request = GameDBM.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    static func emptyInit() -> GameDBM{
        let persistentContainer = NSPersistentContainer(name: "DB")
        let game = GameDBM(context: persistentContainer.viewContext)
        game.result = Int16(1)
        game.gameType = Int16(0)
        game.word = "лампа"
        game.date = Date()
        game.lines = Int16(5)
        
        let letters = "лампа"
        
        letters.forEach { char in
            let letterDBM = LetterDBM(context: CoreDataProvider.shared.viewContext)
            letterDBM.character = String(char)
            letterDBM.state = Int16(Int.random(in: 0...3))
            letterDBM.createdAt = Date()
            letterDBM.game = game
        }
        
        return game
    }
}
