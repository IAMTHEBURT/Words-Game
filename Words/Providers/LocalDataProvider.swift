//
//  LocalDataProvider.swift
//  Words
//
//  Created by Ivan Lvov on 21.03.2023.
//

import Foundation

// Производит изначальную загрузку данных из JSON в Core Data

class LocalDataProvider {
    func checkAndStoreData() throws {
        do {
            let tasks = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)

            if tasks.isEmpty {
                print("Попытка загрузить")
                // Загружаем слова прогресса из JSON
                storeToDB(filename: "progression-mode-ru.json", mode: .progression)

                // Загружаем Free Mode Легкие
                storeToDB(filename: "free-mode-ru.json", mode: .freeMode)
            }
        } catch {
            print("FAILED TO SAVE TASKS TO THE DATABASE \(error.localizedDescription)")
        }
    }

    private func storeToDB(filename: String, mode: GameType) {
        let words: [String] = Bundle.main.decode(filename)
        words.shuffled().forEach { word in
            let task = TaskDBM(context: CoreDataProvider.shared.viewContext)
            task.word = word.uppercased()
            task.difficulty = Int16(Difficulty.low.rawValue)
            task.type = Int16(mode.rawValue)
            task.count = Int16(word.count)
            task.save()
        }
    }

}
