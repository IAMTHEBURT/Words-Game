//
//  GameDBM + Extensions.swift
//  Words
//
//  Created by Иван Львов on 14.12.2022.
//

import Foundation
import CoreData

extension TaskDBM: BaseDBModel {
    static var all: NSFetchRequest<TaskDBM> {
        let request = TaskDBM.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}
