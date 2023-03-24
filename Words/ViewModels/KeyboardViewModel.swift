//
//  KeyboardViewModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation

class KeyboardViewModel: ObservableObject{
    let letters: String = "abcdefghijklmnopqrstuvwxyz"
    
    var characters: [String]{
        let result: [String] =  letters.map { character in
            String(character)
        }
        return result
    }
    
}
