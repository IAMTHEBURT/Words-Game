import Foundation
import XCTest

class Springboard {
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    
    class func deleteApp() {
        XCUIApplication().terminate()
        springboard.activate()
        let appIcon = springboard.icons.matching(identifier: "ВОРДЛ").firstMatch
        appIcon.press(forDuration: 1.3)
        
        let _ = springboard.buttons["Удалить приложение"].waitForExistence(timeout: 1.0)
        springboard.buttons["Удалить приложение"].tap()
        
        let deleteButton = springboard.alerts.buttons["Удалить приложение"].firstMatch
        if deleteButton.waitForExistence(timeout: 5) {
            deleteButton.tap()
            springboard.alerts.buttons["Удалить"].tap()
        }
        
    }
    
}
