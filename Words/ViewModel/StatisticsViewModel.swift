//
//  SettingsViewModel.swift
//  Words
//
//  Created by Иван Львов on 15.12.2022.
//

import Foundation

class StatisticsViewModel: ObservableObject{
    // MARK: - PROPERTIES
    @Published var totalGamesCount: Double = 0
    @Published var wonGamesCount: Double = 0
    @Published var currentWinningStreak: Double = 0
    @Published var maxWinningStreak: Double = 0
    @Published var wonDailyWordGamesCount: Double = 0
    @Published var totalDailyWordGamesCount: Double = 0
    @Published var averageCountOfTriesForWin: Double = 0
    @Published var averageCountOfWordsPerDay: Double = 0
    
    
    var max: Double {
        var max: Double = 0
        distributionData.forEach { element in
            if max < element.first!.value {
                max = element.first!.value
            }
        }
        return max
    }
    
    @Published var distributionData: [ [String : Double] ] = []

    var games: [GameDBM] = []
    
    // MARK: - METHODS
        
    func fetchData(){
        do {
            self.games = try CoreDataProvider.shared.viewContext.fetch(GameDBM.all)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setStats(){
        fetchData()
        
        DispatchQueue.main.async{
            self.totalGamesCount = self.getTotalGamesCount()
            self.wonGamesCount = self.getWonGamesCount()
            self.currentWinningStreak = self.getCurrentWinningStreak()
            self.maxWinningStreak = self.getMaxWinningStreak()
            self.wonDailyWordGamesCount = self.getWonDailyWordGamesCount()
            self.totalDailyWordGamesCount = self.getTotalDailyWordCount()
            self.averageCountOfTriesForWin = self.getAverageCountOfTriesForWin()
            self.averageCountOfWordsPerDay = self.getAverageCountOfWordsPerDay()
            self.distributionData = self.getDistribution()
        }
    }
    
    
    func getDistribution() -> [ [String : Double] ]{
        
        let games = self.games.map(GameHistoryModel.init)
        
        var result: [ [String:Double] ] = []
        
        var tries: [Double] = []
        
        games.map { game in
            if game.result == .win && game.gameType == .dailyWord{
                tries.append(Double(game.tries))
            }
        }
        result.append( ["Слово дня" : tries.average] )
        
        for index in 5...9 {
            tries = []
            print("Индекс \(index)")
            
            games.map { game in
                if game.result == .win && game.word.count == index{
                    tries.append(Double(game.tries))
                }
            }
            print("Резалт \(tries.average)")
            result.append( ["\(index) попыток" : tries.average] )
        }
        
        return result
    }
    
    
    func getTotalGamesCount() -> Double{
        return Double(games.count)
    }
    
    func getWonGamesCount() -> Double{
        return Double(games.filter{($0.result == 0)}.count)
    }
    
    func getCurrentWinningStreak() -> Double{
        let sortedGames = games.sorted { $0.date ?? Date() > $1.date ?? Date()}
        guard let lastGame = sortedGames.first else { return 0 }
        if lastGame.result == 1 { return 0 }
        
        var streak = 0
        
        for game in sortedGames{
            if game.result == 0{
                streak += 1
            }else{
                break
            }
        }
        
        return Double(streak)
    }
    
    
    func getMaxWinningStreak() -> Double{
        let sortedGames = games.sorted { $0.date ?? Date() > $1.date ?? Date()}
        guard let lastGame = sortedGames.first else { return 0 }
        
        var streaks: [Int] = []
        
        
        var streak = 0
        for game in sortedGames{
            if game.result == 0{
                streak += 1
            }else{
                streaks.append(streak)
                streak = 0
            }
        }
        
        streaks = streaks.sorted { $0 > $1 }
        return Double(streaks.first ?? 0)
    }
    
    
    func getWonDailyWordGamesCount() -> Double{
        return Double(games.filter{($0.gameType == 1 && $0.result == 0)}.count)
    }
    
    
    func getTotalDailyWordCount() -> Double{
        return Double(games.filter{($0.gameType == 1)}.count)
    }
    
    func getAverageCountOfTriesForWin() -> Double{
        let wonGames = games.filter{($0.result == 0)}
        var sum = 0
        
        wonGames.forEach { game in
            sum += Int(game.lines)
        }
        
        let average = Double(sum) / Double(wonGames.count)
        if average.isNaN {
            return 0
        }else{
            return average
        }
    }
    
    func getAverageCountOfWordsPerDay() -> Double{
        var result: [DateComponents : Int] = [:]
        
        games.forEach { game in
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: game.date ?? Date())
            if result[calendarDate] != nil {
                result[calendarDate]! += 1
            }else{
                result[calendarDate] = 1
            }
        }
        
        var sum: Int = 0
        result.forEach { value in
            sum += value.value
        }
        return Double(sum) / Double(games.count)
    }
}
