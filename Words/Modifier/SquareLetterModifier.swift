//
//  SquareLetterModifier.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI


struct SquareLetterModifier: ViewModifier {
    var fontColor: Color
    var bgColor: Color
    var size: CGFloat
    var fontSize: CGFloat
    
    init(_ state: LetterState, size: CGFloat = 60, fontSize: CGFloat = 32){
        self.bgColor = state.color
        
        if state == .unanswered{
            self.bgColor = Color("unansweredLetterBackgroundV2")
        }
        self.fontColor = state.fontColor
        self.size = size
        self.fontSize = fontSize
    }
    
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(fontColor)
            .font(.system(size: fontSize))
            .frame(width: size, height: size)
            .background(
                RoundedCorners(color: bgColor, tl: 4, tr: 4, bl: 4, br: 4)
                    .frame(width: size, height: size)
            )
    }
}
