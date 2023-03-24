//
//  WordsUnitTests.swift
//  WordsUnitTests
//
//  Created by Ivan Lvov on 24.03.2023.
//

import XCTest
@testable import Words

class when_start_app_first_time: XCTestCase {
    override func setUp(){
        //Remove all data from DB
        do {
            let tasks = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)
            tasks.forEach { task in
                task.delete()
            }
        } catch {
            print(error)
        }
    }
    
    
    func test_should_decode_and_save_words_correctly(){
        let localDataProvider = LocalDataProvider()
        try! localDataProvider.checkAndStoreData()
        
        let tasks = try! CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)
        XCTAssertTrue(tasks.count > 0)
    }

    
    func test_should_decode_words_correctly(){
        let decodedNouns: [String] = Bundle.main.decode("nouns-ru.json")
        let decodedProgressionMode: [String] = Bundle.main.decode("progression-mode-ru.json")
        let decodedFreeMode: [String] = Bundle.main.decode("free-mode-ru.json")
        
        XCTAssertTrue(decodedNouns.count > 0)
        XCTAssertTrue(decodedProgressionMode.count > 0)
        XCTAssertTrue(decodedFreeMode.count > 0)
    }
}

class when_plays_game: XCTestCase {
    let playVM = PlayViewModel()
    
    override func setUp() {
        playVM.setGame(gameType: .progression)
    }
    
    
    func test_when_input_should_update_the_line() {
        playVM.inputCharacter(character: "А")
        XCTAssertEqual(playVM.lines.first!.letters.first!.character, "А")
    }
    
    
    func test_should_remove_character(){
        playVM.inputCharacter(character: "А")
        playVM.removeCharacter()
        XCTAssertTrue(playVM.lines.first!.letters.isEmpty)
    }
    
}

class when_submit_an_answer: XCTestCase {
    func test_should_throw_when_the_word_is_not_real(){
        let playVM = PlayViewModel()
        playVM.setGame(gameType: .progression)
        playVM.inputCharacter(character: "А")
        playVM.inputCharacter(character: "Б")
        playVM.inputCharacter(character: "В")
        playVM.inputCharacter(character: "Г")
        playVM.inputCharacter(character: "Д")
        XCTAssertThrowsError(try playVM.checkTheLine())
    }
    
    func test_should_change_line_when_type_5_letters() {
        let playVM = PlayViewModel()
        playVM.setGame(gameType: .progression)
        playVM.inputCharacter(character: "Т")
        playVM.inputCharacter(character: "О")
        playVM.inputCharacter(character: "П")
        playVM.inputCharacter(character: "К")
        playVM.inputCharacter(character: "А")
        try? playVM.checkTheLine()
        XCTAssertEqual(playVM.currentLineIndex, 1)
    }
}

class when_finishes_the_game: XCTestCase {
    
    let playVM = PlayViewModel()
    
    override func setUp() {
        playVM.setGame(gameType: .progression)
    }
    
    func test_should_save_game_to_the_database(){
        let playVM = PlayViewModel()
        
        playVM.setGame(gameType: .progression)
        
        playVM.finalWordAsArray.forEach { character in
            playVM.inputCharacter(character: character)
        }
        
        try? playVM.checkTheLine()
        
        let request = GameDBM.fetchRequest()
        
        //WHERE RELATIONSHIP (ONLY ONE TO ONE) NOT EQUAL TO NIL
        request.predicate = NSPredicate(format: "word == %@", playVM.finalWord)
        
        
        //LIMIT
        request.fetchLimit = 1
        
        let result = try! CoreDataProvider.shared.viewContext.fetch(request)
        
        XCTAssertTrue(result.count > 0)
    }
    

    override func tearDown() {
        //Remove all data from DB
        do {
            let tasks = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)
            tasks.forEach { task in
                task.delete()
            }
        } catch {
            print(error)
        }
    }
}
