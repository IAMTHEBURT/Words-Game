//
//  GameHistoryModel.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import CoreData

struct TaskModel: Identifiable {
    var taskDBM: TaskDBM
    
    init(taskDBM: TaskDBM) {
        self.taskDBM = taskDBM
    }
    
    var id: NSManagedObjectID {
        taskDBM.objectID
    }
    
    var word: String {
        taskDBM.word ?? ""
    }
    
    var count: Int {
        Int(taskDBM.count)
    }
    
    var gameType: GameType{
        return GameType(rawValue: Int(taskDBM.type)) ?? .progression
    }
    
    var difficulty: Difficulty{
        return Difficulty(rawValue: Int(taskDBM.difficulty)) ?? .low
    }
    
    var history: GameHistoryModel? {
        if let game = taskDBM.game{
            return GameHistoryModel(gameDBM: game)
        }
        
        return nil
    }
}
