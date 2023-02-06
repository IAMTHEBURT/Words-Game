//
//  WordOfTheDayAPIResponse.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation

struct WordOfTheDayResponse: Codable, Equatable{
    var id: Int
    var word: String
    var active_at: Int
    var next_at: Int
}

extension WordOfTheDayResponse {
    static func emptyInit() -> WordOfTheDayResponse{
        return WordOfTheDayResponse(id: 999999999999, word: "Пробка", active_at: 111111111, next_at: 212121212)
    }
}
