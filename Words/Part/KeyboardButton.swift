//
//  KeyboardButton.swift
//  Words
//
//  Created by Иван Львов on 16.12.2022.
//

import SwiftUI

struct KeyboardButton: View {
    @StateObject var playViewModel: PlayViewModel
    @State var character: String
    @State private var isPressed: Bool = false
    
    
    func getBGColorForTheKeyboardKey() -> Color{
        var letters: [Letter] = []
        playViewModel.lines.map { line in letters.append(contentsOf: line.letters) }
        let filtered = letters.filter{ $0.character == character }
        if !filtered.isEmpty{
            return filtered.first?.state.color ?? LetterState.defaultColor
        }else{
            return LetterState.defaultColor
        }
    }
    
    
    func getForegroundColorForTheKeyboardKey() -> Color{
        var letters: [Letter] = []
        playViewModel.lines.map { line in letters.append(contentsOf: line.letters) }
        let filtered = letters.filter{ $0.character == character }
        if !filtered.isEmpty{
            return filtered.first?.state.fontColor ?? LetterState.defaultColor
        }else{
            return LetterState.unanswered.fontColor
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .overlay(
                getBGColorForTheKeyboardKey()
                    .cornerRadius(6)
            )
            .overlay(
                Color.white
                .opacity(isPressed ? 0.15 : 0)
                    .cornerRadius(6)
            )
            .overlay(
                Text(character)
                    .padding(2)
                    .foregroundColor(getForegroundColorForTheKeyboardKey())
                    //.foregroundColor(.white.opacity(0.9))
//                    .foregroundColor(
//                        playViewModel.getBGColorForTheKeyboardKey(character: character)
//                    )
                    .modifier(MyFont(font: "Inter", weight: "medium", size: 16))
                    .minimumScaleFactor(0.4)
                , alignment: .center
            )
            .shadow(color: .black.opacity(0.45), radius: 4, x: 1, y: 3)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        isPressed = true
                    })
                    .onEnded({ _ in
                        isPressed = false
                        playViewModel.inputCharacter(character: character)
                    })
            )
    }
}

struct KeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardButton(
            playViewModel: PlayViewModel(),
            character: "Т")
        .frame(height: 80)
        .frame(width: 60)
        .previewLayout(.sizeThatFits)
        .padding(30)
        .background(.white)
    }
}