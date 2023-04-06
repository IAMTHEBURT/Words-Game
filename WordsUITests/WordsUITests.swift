//
//  WordsUITests.swift
//  WordsUITests
//
//  Created by Ivan Lvov on 25.03.2023.
//
// swiftlint:disable all

import XCTest

fileprivate func start(app: XCUIApplication){
    app.launch()
    
    let _ = app.buttons["startButton"].waitForExistence(timeout: 10)
    app.buttons["startButton"].tap()
    
    if app.buttons["tryButton"].exists{
        app.buttons["tryButton"].tap()
    }
    
    if app.buttons["go_home_icon"].exists{
        app.buttons["go_home_icon"].tap()
    }
}


fileprivate func finish_a_game(app: XCUIApplication){
    app.staticTexts["tournamentTasksCountLabel"].tap()
    
    for _ in 0...5 {
        app.staticTexts["keyboard-П"].tap()
        app.staticTexts["keyboard-А"].tap()
        app.staticTexts["keyboard-Р"].tap()
        app.staticTexts["keyboard-О"].tap()
        app.staticTexts["keyboard-М"].tap()
        app.staticTexts["keyboard-check"].tap()
    }
}



class when_start_app_for_the_first_time: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        start(app: app)
        
    }
    
    func test_shoud_have_avaliable_tasks(){
        let tournamentTasksCountLabel = app.staticTexts["tournamentTasksCountLabel"]
        XCTAssertTrue(tournamentTasksCountLabel.exists)
        XCTAssertTrue(tournamentTasksCountLabel.label != "0/0")
        
        
        let freeModeTasksCountLabel = app.staticTexts["freeModeTasksCountLabel"]
        XCTAssertTrue(freeModeTasksCountLabel.exists)
        XCTAssertTrue(freeModeTasksCountLabel.label != "0/0")
    }
    
    func test_game_history_should_be_empty(){
        app.images["icon_history"].tap()
        XCTAssertTrue(app.collectionViews["gameHistory"].cells.count == 0)
    }
    
    override class func tearDown() {
        Springboard.deleteApp()
    }
}


class when_run_the_app: XCTestCase{
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        start(app: app)
    }
    
    func test_shoud_run_a_game_when_tap_on_tournament_mode(){
        app.staticTexts["tournamentTasksCountLabel"].tap()
        let _ = app.staticTexts["Прохождение"].waitForExistence(timeout: 2)
        XCTAssertTrue(app.staticTexts["Прохождение"].exists)
        XCTAssertTrue(app.staticTexts["проверить слово"].exists)
    }
    
    func test_shoud_run_a_game_when_tap_on_free_mode(){
        app.staticTexts["freeModeTasksCountLabel"].tap()
        let _ = app.staticTexts["Свободный режим"].waitForExistence(timeout: 2)
        XCTAssertTrue(app.staticTexts["Свободный режим"].exists)
        XCTAssertTrue(app.staticTexts["проверить слово"].exists)
    }
    
}


class when_finishes_a_game: XCTestCase{
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        start(app: app)
        finish_a_game(app: app)
    }
    
    func test_should_show_comments_block(){
        XCTAssertTrue((app.staticTexts["Написать комментарий"].exists))
    }
    
    func test_should_show_share_button(){
        XCTAssertTrue(app.buttons["shareButton"].exists)
    }
    
}


class acceptance_when_finishes_a_game: XCTestCase{
    var app: XCUIApplication!
    var currentPoints: Int = 0
    
    override func setUp() {
        app = XCUIApplication()
        start(app: app)
        sleep(1)
        self.currentPoints = Int(app.staticTexts["points"].label)!
        finish_a_game(app: app)
    }
    
    func test_should_show_save_comments(){
        let elementsQuery = app.scrollViews.otherElements
        let writeACommentTextFieldTextView = elementsQuery.textViews["write_a_comment_text_field"]
        writeACommentTextFieldTextView.tap()
        writeACommentTextFieldTextView.typeText("Привет, друг. Как дела?")
        elementsQuery/*@START_MENU_TOKEN@*/.buttons["sendCommentButton"]/*[[".buttons[\"Отправить\"]",".buttons[\"sendCommentButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let _ = app.staticTexts["Привет, друг."].waitForExistence(timeout: 10)
                
    }
    
    
    func test_should_update_points(){
        let _ = app.staticTexts["Написать комментарий"].waitForExistence(timeout: 5)
        print(app.staticTexts["points"].label)
        sleep(5)
        let updatedPoints = Int( app.staticTexts["points"].label )!
        let currentPoints = self.currentPoints
        XCTAssertTrue(updatedPoints > currentPoints)
    }
    
}


class acceptance_when_run_the_app: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        start(app: app)
    }
    
    func test_shoud_show_daily_word_block(){
        let _ = app.staticTexts["wordOfTheDayLabel"].waitForExistence(timeout: 10)
        XCTAssertTrue(app.staticTexts["wordOfTheDayLabel"].exists)
    }
    
    func test_should_show_rating(){
        app.images["icon_rating"].tap()
        let _ = app.staticTexts["nickname"].waitForExistence(timeout: 5)
        XCTAssertTrue((app.staticTexts["nickname"].exists))
    }
}
// swiftlint:enable all
