//
//  MainViewModel.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    // MARK: - PROPERTIES
    @Published var countDown: String = ""
    
    @Published var seconds: Int = 0
    @Published var minutes: Int = 0
    @Published var hours: Int = 0
    
    
    @Published var pushToGame: Bool = false
    
    @Published var allProgresionTasksCount: Int = 0
    @Published var doneProgresionTasksCount: Int = 0
    
    @Published var showingCompletedBlockAlert = false
    @Published var showingDailyWordIsFinishedAlert = false
    
    private var allTasks: [TaskModel] = []
    private var progressionTasks: [TaskModel] = []
    private var freeModeTasks: [TaskModel] = []
    
    var playVM: PlayViewModel = PlayViewModel()
    
    // MARK: - FUNCTIONS
    
//    func updateProgressionCount(){
//        do {
//            self.allProgresionTasksCount = try CoreDataProvider.shared.viewContext.count(for: TaskDBM.all)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        do {
//            let request = TaskDBM.all
//            request.predicate = NSPredicate(format: "game != nil")
//            self.doneProgresionTasksCount = try CoreDataProvider.shared.viewContext.count(for: request)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    
    func isFreeModeCategoryOpened(count: Int) -> Bool {
        let finished = self.getCountOff(type: .progression, finished: true)
        if count == 5 && finished > 30{
            return true
        }
        
        if count == 6 && finished > 50{
            return true
        }
        
        if count == 7 && finished > 70{
            return true
        }
        
        if count == 8 && finished > 90{
            return true
        }
        
        if count == 9 && finished > 120{
            return true
        }
        
        return false
        
        
    }
    
    func getCountOff(type: GameType, finished: Bool = false, difficulty: Difficulty = .low, symbolsCount: Int = 5) -> Int{
        if finished{
            return allTasks.filter{ $0.gameType == type && $0.history != nil && $0.difficulty == difficulty && $0.count == symbolsCount}.count
        }else{
            return allTasks.filter{ $0.gameType == type && $0.difficulty == difficulty && $0.count == symbolsCount }.count
        }
    }
    
    
    func updateTasksData(){
        do {
            let allTasksDBM = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)
            
            allTasks = allTasksDBM.map( TaskModel.init )
            progressionTasks = allTasks.filter{ $0.gameType == .progression }
            freeModeTasks = allTasks.filter{ $0.gameType == .freeMode }
            
        } catch {
            print(error.localizedDescription)
        }
        
//        do {
//            let request = TaskDBM.all
//            request.predicate = NSPredicate(format: "game != nil")
//            self.doneProgresionTasksCount = try CoreDataProvider.shared.viewContext.count(for: request)
//        } catch {
//            print(error.localizedDescription)
//        }
        
    }
    
    
    func startDailyWordGame(){
        guard let word = APIProvider.shared.wordOfTheDayResponse?.word else {
            print("Не загружено слово")
            return
        }
        
        playVM = PlayViewModel()
        playVM.setGame(word: word, gameType: .dailyWord)

        DispatchQueue.main.async{
            self.pushToGame = true
            self.objectWillChange.send()
        }
    }
    
    func setProgressionGame(){
        let request = TaskDBM.all
        request.predicate = NSPredicate(format: "game == nil && type == 0")
        request.fetchLimit = 1
        
        do {
            let tasks = try CoreDataProvider.shared.viewContext.fetch(request)
            
            guard let taskDBM = tasks.first else {
                print("Не осталось заданий")
                showingCompletedBlockAlert = true
                return
            }
            
            playVM = PlayViewModel()
            playVM.setGame(task: taskDBM, gameType: .progression)
            
            DispatchQueue.main.async{
                self.pushToGame = true
                self.objectWillChange.send()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func startFreeModeGame(count: Int){
        let request = TaskDBM.all
        request.predicate = NSPredicate(format: "game == nil && type == 2 && count == \(Int16(count))")
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "difficulty", ascending: true)]
        
        do {
            let tasks = try CoreDataProvider.shared.viewContext.fetch(request)
            
            guard let taskDBM = tasks.first else {
                print("Не осталось заданий")
                return
            }
            
            playVM = PlayViewModel()
            playVM.setGame(task: taskDBM, gameType: .freeMode)
            
            DispatchQueue.main.async{
                print("Сложность")
                print(taskDBM.difficulty)
                self.pushToGame = true
                self.objectWillChange.send()
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    

    func updateCountdown(){
        guard let nextAt = APIProvider.shared.wordOfTheDayResponse?.nextAt else { return }
        let interval = Double(nextAt) - Date.now.timeIntervalSince1970
        
        if interval <= 0{
            APIProvider.shared.getWordOfTheDay()
            return
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(interval))!
        
        countDown = formattedString
        
        hours = Int(interval) / 3600
        minutes = Int(interval) / 60 % 60
        seconds = Int(interval) % 60
    }
    
    func isDailyWordCompleted() -> Bool{
        
        //CoreDataProvider.shared.viewContext.fetch(GameDBM.all)
        guard let dailyWord = APIProvider.shared.wordOfTheDayResponse?.word else { return false }
        
        let fetchRequest = GameDBM.all
        fetchRequest.predicate = NSPredicate(format: "word = %@", dailyWord.uppercased())

        do {
            let games = try CoreDataProvider.shared.viewContext.fetch(fetchRequest)
            if games.isEmpty{
                return false
            }else{
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getDailyWordGameHistory() -> GameHistoryModel?{
        
        //CoreDataProvider.shared.viewContext.fetch(GameDBM.all)
        guard let dailyWord = APIProvider.shared.wordOfTheDayResponse?.word else { return nil }
        
        let fetchRequest = GameDBM.all
        fetchRequest.predicate = NSPredicate(format: "word = %@", dailyWord.uppercased())

        do {
            let games = try CoreDataProvider.shared.viewContext.fetch(fetchRequest)
            if games.isEmpty{
                return nil
            }else{
                return GameHistoryModel(gameDBM: games.first!)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
