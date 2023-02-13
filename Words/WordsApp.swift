//
//  WordsApp.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

@main
struct WordsApp: App {
    let dictionary: Dictionary = Dictionary.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    //APIProvider.shared.getWordOfTheDay()
                    do {
                        let tasks = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)
                        
                        if tasks.isEmpty{
                            
                            print("Загружаю слова в БАЗУ")
                            
                            //Загружаем слова прогресса из JSON
                            let progressionWords: [String] = Bundle.main.decode("progression-mode-ru.json")
                            progressionWords.shuffled().forEach { word in
                                let task = TaskDBM(context: CoreDataProvider.shared.viewContext)
                                task.word = word.uppercased()
                                task.difficulty = Int16(Difficulty.low.rawValue)
                                task.type = Int16(GameType.progression.rawValue)
                                task.count = Int16(word.count)
                                task.save()
                            }
                            
                            //Загружаем Free Mode Легкие
                            let freeEasyWords: [String] = Bundle.main.decode("free-mode-ru.json")
                            freeEasyWords.shuffled().forEach { word in
                                let task = TaskDBM(context: CoreDataProvider.shared.viewContext)
                                task.word = word.uppercased()
                                task.difficulty = Int16(Difficulty.low.rawValue)
                                task.type = Int16(GameType.freeMode.rawValue)
                                task.count = Int16(word.count)
                                task.save()
                            }
                            
                            //Загружаем Free Mode Сложные
//                            let freeDifficultWords: [String] = Bundle.main.decode("freeDifficult-ru.json")
//                            freeDifficultWords.shuffled().forEach { word in
//                                let task = TaskDBM(context: CoreDataProvider.shared.viewContext)
//                                task.word = word.uppercased()
//                                task.difficulty = Int16(Difficulty.hard.rawValue)
//                                task.type = Int16(GameType.freeMode.rawValue)
//                                task.count = Int16(word.count)
//                                task.save()
//                            }
                            
                        }
                    } catch {
                        print("FAILED TO SAVE TASKS TO DATABASE \(error.localizedDescription)")
                    }
                }
        }
    }
}
