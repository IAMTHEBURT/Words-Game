//
//  DictionaryModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation

class Dictionary {
    // MARK: - PROPERTIES
    
    static let shared: Dictionary = Dictionary()
    let list: [String]
    
    // MARK: - FUNCTIONS
    
    init() {
        self.list = Bundle.main.decode("nouns-ru.json")
    }
    
    func hasTheWord(word: String) -> Bool{
        let result = list.first { element in
            element == word.lowercased()
        }
        return result != nil
    }
}
