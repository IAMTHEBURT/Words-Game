//
//  CommentModel.swift
//  Words
//
//  Created by Ivan Lvov on 01.02.2023.
//

import Foundation

struct Comment: Codable, Identifiable, Equatable {
    let id: Int
    let user_id: Int
    let name: String
    let word: String
    let text: String
    let created_at: String
    let updated_at: String
    let likes: Int
    let dislikes: Int
    let has_user_like: Bool
    let has_user_dislike: Bool
}

extension Comment {
    static func emptyInit() -> Comment {
        return Comment(id: 1,
                       user_id: 21221,
                       name: "Фиолетовый Тигр",
                       word: "Лепка",
                       text: "Ловко ты это придумал",
                       created_at: "Сегодня",
                       updated_at: "Сегодня",
                       likes: 12,
                       dislikes: 2,
                       has_user_like: false,
                       has_user_dislike: false)
    }
}
