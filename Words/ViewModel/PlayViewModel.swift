//
//  PlayViewModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation
import SwiftUI
import CoreData

class PlayViewModel: ObservableObject {
    // MARK: - PROPERTIES
    let dictionary = Dictionary()
    
    let numberOfLines = 6
    var finalWord: String = "салют".uppercased()
    var gameType: GameType = .dailyWord
    
    var tries: Int = 0
    
    var maxTries: Int {
        return lines.count
    }
    
    @Published var isResultAlertPresented: Bool = false
    @Published var gameIsFinished: Bool = false
    @Published var lines: [Line] = []
    @Published var checkButtonIsActive: Bool = false
    @Published var removeButtonIsActive: Bool = false
    @Published var showNotifyView: Bool = false
    @Published var notifyHeadline: String = ""
    @Published var notifyText: String = ""
    @Published var shakeFieldId: String?
    @Published var isShareSheetPresented: Bool = false
    @Published var successConfettiCounter: Int = 0
    @Published var failConfettiCounter: Int = 0
    @Published var forceTitle: String = ""
    
    var result: GameResult = .loose
    var task: TaskDBM?
    
    var currentLineIndex: Int = 0
    var currentSymbolIndex: Int = 0
    
    var finalWordAsArray:[String]{
        let characters = finalWord.map { String($0) }
        return characters
    }
    
    var gameHistory: GameHistoryModel?
    
    var currentLine: Line {
        return lines[currentLineIndex]
    }
    
    var lettersCount: Int{
        return finalWord.count
    }
    
    var started_at: TimeInterval = Date.now.timeIntervalSince1970
    
    // MARK: - FUNCTIONS
    
    init(){
        setLines()
    }
    
    //This constructor is just for finished games
    init(gameHistory: GameHistoryModel){
        self.finalWord = gameHistory.word
        self.result = gameHistory.result
        self.gameIsFinished = true
    }
    
    func getCurrentDurationInSeconds() -> Int {
        return Int(Date.now.timeIntervalSince1970 - started_at)
    }
    
    func isTheCurrentLine(line: Line) -> Bool {
        if line.lineIndex == currentLine.lineIndex{
            return true
        }
        return false
    }
    
    func getResultFieldBGColorForIndex(index: Int) -> Color {
        let character = finalWordAsArray[index]
        var hasLetter = false
        
        lines.forEach { line in
            
            if isTheCurrentLine(line: line) { return }
            
            if line.lettersWithEmptyElements[index].character == character {
                hasLetter = true
            }
        }
        return hasLetter ? LetterState.rightLetterRightPlace.color : Color("unansweredBGColorForResultLine")
    }
    
    func getResultFieldCharacterForIndex(index: Int, empty: Bool = true) -> String {
        let character = finalWordAsArray[index]
        var hasLetter = false
        
        lines.forEach { line in
            if isTheCurrentLine(line: line) { return }
            
            if line.lettersWithEmptyElements[index].character == character {
                hasLetter = true
            }
        }
        
        
        if empty{
            return hasLetter ? character : ""
        }else{
            return character
        }
        
    }
    

    private func setLines(){
        var lines:[Line] = []
        for index in 0...numberOfLines - 1 {
            lines.append(Line(lettersCount: lettersCount, lineIndex: index))
        }
        self.lines = lines
    }
    
    func getAllLetters(withEmpty: Bool = false) -> [Letter]{
        var letters: [Letter] = []
        lines.map { line in
            if withEmpty{
                letters.append(contentsOf: line.lettersWithEmptyElements)
            }else{
                letters.append(contentsOf: line.letters)
            }
        }
        return letters
    }
    
    func reset(){
        isResultAlertPresented = false
        finalWord = ""
        tries = 0
        gameIsFinished = false
        //lines = Array(repeating: Line(), count: numberOfLines)
        lines = []
        checkButtonIsActive = false
        notifyText = ""
        task = nil
        currentLineIndex = 0
        currentSymbolIndex = 0
        gameHistory = nil
        started_at = Date.now.timeIntervalSince1970
        result = .loose
        forceTitle = ""
    }
    
    func setGame(word: String, gameType: GameType){
        self.finalWord = word.uppercased()
        self.gameType = gameType
        setLines()
    }

    func setGame(task: TaskDBM, gameType: GameType){
        guard let word = task.word else { return }
        self.finalWord = word
        self.gameType = gameType
        self.task = task
        setLines()
    }
    
    
    func setGame(gameType: GameType){
        reset()
        started_at = Date.now.timeIntervalSince1970
        if gameType == .progression{
            let request = TaskDBM.all
            request.predicate = NSPredicate(format: "game == nil")
            request.fetchLimit = 1
            
            do {
                let tasks = try CoreDataProvider.shared.viewContext.fetch(request)
                
                guard let taskDBM = tasks.first else {
                    print("Не осталось заданий")
                    return
                }
                
                self.setGame(task: taskDBM, gameType: .progression)
            } catch {
                print(error.localizedDescription)
            }
        }else{
            guard let word = APIProvider.shared.wordOfTheDayResponse?.word else { return }
            setGame(word: word, gameType: .dailyWord)
        }
    }

    
    //Активирует новосе слово если вдруг пользователь дождался не уходя с экрана
    func activateNewWord(){
        
    }
    
    func inputCharacter(character: String){
        
        print(finalWord.uppercased())
        
        if currentLine.lineIsFull {
            return
        }
        
        lines[currentLineIndex].addCharacter(character: character)
        updateCheckButtonState()
        updateRemoveButtonState()
        
        withAnimation(.easeOut(duration: 0.1).repeatCount(3)){
            shakeFieldId = "\(lines[currentLineIndex].id)\(lines[currentLineIndex].lettersAsString.count - 1)"
        }
        
        objectWillChange.send()
    }
    
    func removeCharacter(){
        lines[currentLineIndex].removeLastCharacter()
        updateCheckButtonState()
        updateRemoveButtonState()
        objectWillChange.send()
    }
    
    func updateRemoveButtonState(){
        if lines[currentLineIndex].letters.isEmpty == false{
            removeButtonIsActive = true
        }else{
            removeButtonIsActive = false
        }
    }
    
    func updateCheckButtonState(){
        if lines[currentLineIndex].allLettersAreTyped(){
            checkButtonIsActive = true
        }else{
            checkButtonIsActive = false
        }
    }
    
    func showNotifyView(headline: String = "", text: String){
        notifyHeadline = headline
        notifyText = text
        showNotifyView = true
    }
    
    func checkTheLine(){
        //Check if this is a real word
        if !dictionary.hasTheWord(word: lines[currentLineIndex].lettersAsString){
            playSound(sound: "custom-1", type: "wav")
            showNotifyView(text: "Мы не нашли такого слова в нашем словаре")
            return
        }
        
        tries += 1
        
        lines[currentLineIndex].letters.enumerated().forEach { (position, letter) in
            //If the final word has the same character at the same place
            if finalWordAsArray[position] == letter.character{
                letter.setState(state: .rightLetterRightPlace)
            }
            //If the final word has the same character at the wrong place
            else if finalWordAsArray.contains(letter.character) {
                letter.setState(state: .rightLetterWrongPlace)
            }
            else{
                letter.setState(state: .wrongLetter)
            }
        }
        
        //If this is the right word
        if lines[currentLineIndex].lettersAsString == finalWord{
            print("YOU WON")
            self.result = .win
            finishTheGame()
            playSound(sound: "custom-2", type: "wav")
            successConfettiCounter += 1
        }

        
        playSound(sound: "custom-3", type: "wav")
        // FINISH
        if lines.count == currentLineIndex + 1 {
            finishTheGame()
            failConfettiCounter += 1
        }
        
        // OR CHANGE THE LINE
        else{
            nextLine()
        }
        
        objectWillChange.send()
    }
    
    func finishTheGame(){
        print("GAME IS FINISHED")
        
        //SAVE THE GAME TO DB
        let gameDBM = GameDBM(context: CoreDataProvider.shared.viewContext)
        gameDBM.date = Date()
        gameDBM.duration = Int16(getCurrentDurationInSeconds())
        gameDBM.gameType = Int16(gameType.rawValue)
        getAllLetters(withEmpty: true).forEach { letter in
            let letterDBM = LetterDBM(context: CoreDataProvider.shared.viewContext)
            letterDBM.character = letter.character
            letterDBM.state = Int16(letter.state.rawValue)
            letterDBM.createdAt = Date()
            letterDBM.game = gameDBM
        }
        
        gameDBM.result = Int16(result.rawValue)
        gameDBM.word = finalWord
        gameDBM.lines = Int16(lines.filter{(!$0.letters.isEmpty)}.count)
        
        if let taskDBM = task{
            print("SAVING TASK")
            gameDBM.task = taskDBM
        }
        
        gameDBM.save()
        
        self.gameHistory = GameHistoryModel(gameDBM: gameDBM)
        
        gameIsFinished = true
        isResultAlertPresented = true
        
        if gameType == .dailyWord{
            NotificationProvider().updateNotifications(skipCurrentDay: true)
        }
        
        Task{
            do{
                try await APIProvider.shared.saveTheGame(game: self.gameHistory!)
                try await APIProvider.shared.updatePoints()
            }catch{
                print(error)
            }
        }
    }
    
    func nextLine(){
        checkButtonIsActive = false
        currentLineIndex += 1
    }
}
