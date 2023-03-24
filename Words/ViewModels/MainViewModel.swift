//
//  MainViewModel.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import SwiftUI
import CoreData

//@MainActor
class MainViewModel: NSObject, ObservableObject {
    // MARK: - PROPERTIES
    
    static var shared: MainViewModel = MainViewModel()
    
    private let fetchedResultsController: NSFetchedResultsController<DailyWordDBM>
    
    private (set) var context: NSManagedObjectContext
    
    @Published var dailyWord: DailyWord?
    @Published var isDailyWordAnimating: Bool = false
    
    override init() {
        self.context = CoreDataProvider.shared.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: DailyWordDBM.actual, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            guard let dailyWordsDBM = fetchedResultsController.fetchedObjects else { return }
            
            guard let safeDailyWord = dailyWordsDBM.first else {
                print("Не смогли взять первый элемент в наборе. Такого слова нет, отправляем запрос на сервер")
                Task{
                    do {
                        let wordOfTheDayResponse = try await APIProvider.shared.getWordOfTheDay()
                        print("Слово дня \(wordOfTheDayResponse)")
                        //Записываем в базу
                        let dailyWord = DailyWordDBM(context: CoreDataProvider.shared.viewContext)
                        dailyWord.word = wordOfTheDayResponse.word
                        dailyWord.active_at = Int64(wordOfTheDayResponse.active_at)
                        dailyWord.next_at = Int64(wordOfTheDayResponse.next_at)
                        dailyWord.save()
                    } catch {
                        print(error)
                    }
                }
                return
            }
            
            self.dailyWord = DailyWord(dailyWordDBM: safeDailyWord)
            self.isDailyWordAnimating = true
            
        } catch {
            print(error)
        }
    }
    
    @Published var countDown: String = ""
    
    @Published var seconds: Int = 0
    @Published var minutes: Int = 0
    @Published var hours: Int = 0
    
    @Published var pushToGame: Bool = false
    
    @Published var allProgresionTasksCount: Int = 0
    @Published var doneProgresionTasksCount: Int = 0
    
    @Published var showingCompletedBlockAlert = false
    @Published var showingDailyWordIsFinishedAlert = false
    
    
    @Published var wordstat: WordstatModel?
    
    private var allTasks: [TaskModel] = []
    private var progressionTasks: [TaskModel] = []
    private var freeModeTasks: [TaskModel] = []
    
    var playVM: PlayViewModel = PlayViewModel()
    
    //@Published var dailyWord: DailyWordDBM
    
    // MARK: - FUNCTIONS
    
    func updateWordstat(word: String) async throws {
        do {
            let data = try await APIProvider.shared.getWordstat(word: word)
            DispatchQueue.main.async{
                self.wordstat = data
            }
        } catch {
            print(error)
        }
        
    }
    
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
    
    func getCountOff(type: GameType, finished: Bool = false, difficulty: Difficulty = .low, symbolsCount: Int = 0) -> Int{
        
        //ALL NUMBERS
        if symbolsCount == 0 {
            if finished{
                return allTasks.filter{ $0.gameType == type && $0.history != nil && $0.difficulty == difficulty}.count
            }else{
                return allTasks.filter{ $0.gameType == type && $0.difficulty == difficulty}.count
            }
            
            //ONLYE SPECIFIED
        }else{
            if finished{
                return allTasks.filter{ $0.gameType == type && $0.history != nil && $0.difficulty == difficulty && $0.count == symbolsCount}.count
            }else{
                return allTasks.filter{ $0.gameType == type && $0.difficulty == difficulty && $0.count == symbolsCount }.count
            }
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
    }
    
    
    func startDailyWordGame(){
        guard let word = self.dailyWord?.word else {
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
    
    func startAnyWordGame(word: String, title: String = ""){
        playVM = PlayViewModel()
        playVM.forceTitle = title
        playVM.setGame(word: word, gameType: .freeMode)
        
        DispatchQueue.main.async{
            self.pushToGame = true
            self.objectWillChange.send()
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
                self.pushToGame = true
                self.objectWillChange.send()
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func updateCountdown(){
        guard let nextAt = dailyWord?.nextAt else { return }
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
        guard let dailyWord = dailyWord?.word else { return false }
        
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
        guard let dailyWord = dailyWord?.word else { return nil }
        
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

extension MainViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("Пришло обновление базы")
        guard let dailyWordsDBM = controller.fetchedObjects as? [DailyWordDBM] else {
            print("Не получилось взять")
            return
        }
        
        guard let safeDailyWord = dailyWordsDBM.first else {
            print("Не смогли взять первый элемент в наборе. Слова нет")
            isDailyWordAnimating = false
            return
        }
        
        self.dailyWord = DailyWord(dailyWordDBM: safeDailyWord)
        self.isDailyWordAnimating = true
    }
}

