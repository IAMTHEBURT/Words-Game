//
//  GameType.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

enum GameType: Int, Codable {
    case progression, dailyWord, freeMode

    var name: String {
        switch self {
        case .progression:
            return "Прохождение"
        case .dailyWord:
            return "Слово дня"
        case .freeMode:
            return "Свободный режим"
        }
    }

    var color: Color {
        switch self {
        case .progression:
            return Color(hex: "#F76BB2")
        case .dailyWord:
            return Color(hex: "#36B3F2")
        case .freeMode:
            return .black
        }
    }
}
