//
//  ActiveScreen.swift
//  Words
//
//  Created by Ivan Lvov on 18.01.2023.
//

import Foundation

enum ActiveScreen: Identifiable {
    case game, stat, rules, settings, history, rating

    var id: Int {
        hashValue
    }
}
