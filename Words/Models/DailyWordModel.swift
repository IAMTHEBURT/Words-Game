//
//  LetterModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation
import CoreData

struct DailyWord: Identifiable, Equatable {
    var dailyWordDMB: DailyWordDBM

    init(dailyWordDBM: DailyWordDBM) {
        self.dailyWordDMB = dailyWordDBM
    }

    var id: NSManagedObjectID {
        dailyWordDMB.objectID
    }

    var activeAt: Int {
        return Int(dailyWordDMB.active_at)
    }

    var nextAt: Int {
        return Int(dailyWordDMB.next_at)
    }

    var word: String {
        return dailyWordDMB.word ?? ""
    }
}
