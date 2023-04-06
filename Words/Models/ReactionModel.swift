//
//  ReactionModel.swift
//  Words
//
//  Created by Ivan Lvov on 01.02.2023.
//

import Foundation

struct Reaction: Codable {
    var type: ReactionType
    var UID: String
    var comment_id: Int
}
