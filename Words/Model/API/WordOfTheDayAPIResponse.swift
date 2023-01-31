//
//  WordOfTheDayAPIResponse.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation

struct WordOfTheDayAPIResponse: Codable, Equatable{
    var id: Int
    var word: String
    var nextAt: Int
}

extension WordOfTheDayAPIResponse {
    static func emptyInit() -> WordOfTheDayAPIResponse{
        return WordOfTheDayAPIResponse(id: 999999999999, word: "Пробка", nextAt: 212121212)
    }
}
