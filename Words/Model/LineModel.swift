//
//  LineModel.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation
import SwiftUI

class Line: Identifiable {
    let id: UUID = UUID()
    var lettersCount: Int
    var letters: [Letter] = []
    
    var lineIndex: Int = 99
    
    init(lettersCount: Int = 5) {
        self.lettersCount = lettersCount
    }
    
    init(lettersCount: Int = 5, lineIndex: Int) {
        self.lettersCount = lettersCount
        self.lineIndex = lineIndex
    }
    
}

extension Line {
    var lettersAsString: String{
        var string = ""
        letters.map { letter in
            string += letter.character
        }
        return string
    }
    var lettersWithEmptyElements: [Letter]{
        var result: [Letter] = []
        for index in 0...lettersCount - 1 {
            if letters.indices.contains(index){
                result.append(letters[index])
            }
            else{
                result.append(Letter.emptyInit())
            }
        }
        
        return result
    }
    
    var lineIsFull: Bool {
        if lettersCount == letters.count{
            return true
        }
        return false
    }
    
    func getFontColorByIndex(index: Int) -> Color {
        if letters.indices.contains(index){
            return letters[index].state.fontColor
        }
        
        return LetterState.defaultColor
    }
    
    func getStateByIndex(index: Int) -> LetterState{
        if letters.indices.contains(index){
            return letters[index].state
        }
        
        return LetterState.unanswered
    }
    
    func getBGColorByIndex(index: Int, highlightCurrent: Bool = false) -> Color{
        if letters.indices.contains(index){
            return letters[index].state.color
        }
        
        if highlightCurrent{
            return LetterState.unanswered.color
        } else{
            return LetterState.defaultColor
        }
    }
    
    func getCharacterByIndex(index: Int) -> String{
        if letters.indices.contains(index){
            return letters[index].character
        }
        return ""
    }
    
    func addCharacter(character: String){
        if letters.count == lettersCount{ return }
        letters.append(Letter(character: character))
    }
    
    func removeLastCharacter(){
        if letters.isEmpty{ return }
        
        letters.removeLast()
    }
    
    func allLettersAreTyped() -> Bool{
        return letters.count == lettersCount
    }
    
}
