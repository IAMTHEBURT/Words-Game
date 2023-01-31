//
//  LetterState.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation
import SwiftUI

enum LetterState: Int, Codable{
    case unanswered, rightLetterRightPlace, rightLetterWrongPlace, wrongLetter
}

extension LetterState{
    var color: Color{
        switch self {
        case .unanswered:
            return Color("unansweredLetterBackground")
        case .rightLetterRightPlace:
            return Color("rightLetterRightPlaceBackground")
        case .rightLetterWrongPlace:
            return Color("rightLetterWrongPlaceBackground")
        case .wrongLetter:
            return Color("wrongLetterBackground")
        }
    }
    
    var fontColor: Color{
        switch self {
        case .unanswered:
            return Color("unansweredLetterFontColor")
        case .rightLetterRightPlace:
            return Color("rightLetterRightPlaceFontColor")
        case .rightLetterWrongPlace:
            return Color("rightLetterWrongPlaceFontColor")
        case .wrongLetter:
            return Color("answeredWrongFontColor")
        }
    }
    
    var description: String{
        switch self {
        case .unanswered:
            return "Вы еще не ответили 🥹"
        case .rightLetterRightPlace:
            return "Вы угадали букву и позицию 🤗"
        case .rightLetterWrongPlace:
            return "Такая буква есть, но в другом месте 🧐"
        case .wrongLetter:
            return "Такой буквы в слове нет ☹️"
        }
    }
    
    static var defaultColor: Color{
        Color("unansweredLetterBackground")
    }
    
    static var defaultFontColor: Color{
        Color("unansweredLetterFontColor")
    }
    
}
