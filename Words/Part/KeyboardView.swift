//
//  KeyboardView.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

struct KeyboardView: View {
    // MARK: - PROPERTIES
    @StateObject var playViewModel: PlayViewModel
    let keyboardLineHeight: CGFloat = 40
    
    let columnSpacing: CGFloat = 4
    let rowSpacing: CGFloat = 4
    
    var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(maximum: 25), spacing: rowSpacing, alignment: .trailing), count: 11)
    }
    
    var characters: [String]{
        let letters: String = "йцукенгшщзхфывапролджэячсмитьбю"
        let result: [String] =  letters.map { character in
            String(character).uppercased()
        }
        return result
    }
    
    let line1: [String] = "йцукенгшщзхъ".toArray()
    let line2: [String] = "фывапролджэ".toArray()
    let line3: [String] = "ячсмитьбю".toArray()
    
    var lines: [[String]] {
        return [
            line1,
            line2,
            line3,
        ]
    }
    
    // MARK: - BODY
    var body: some View {
        GeometryReader{ geo in
            VStack{
                Spacer()
                HStack(alignment: .center, spacing: 6){
                    ForEach(line1, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "tap-1")
                            .frame(maxWidth: 25)
                    }
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                HStack(spacing: 6){
                    Spacer(minLength: geo.size.width / CGFloat(line2.count) / 6)
                    ForEach(line2, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "tap-2")
                            .frame(maxWidth: 25)
                    }
                    Spacer(minLength: geo.size.width / CGFloat(line2.count) / 6)
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                HStack(spacing: 6){
                    ForEach(line3, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "tap-3")
                            .frame(maxWidth: 25)
                    }
                    
                    RemoveKeyboardButton(playViewModel: playViewModel, sound: "tap-4")
                        .frame(maxWidth: 25)
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                LongMarkKeyboardButton(playViewModel: playViewModel)
                    .frame(height: 40)
                    .padding(.horizontal, 40)
                Spacer()
            }
        }
        
    }
}

// MARK: - PREVIW
struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(playViewModel: PlayViewModel())
            .background(Color("BGColor"))
    }
}
