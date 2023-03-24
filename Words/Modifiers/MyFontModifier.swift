//
//  CusFontModifier.swift
//  Spanish Minute
//
//  Created by Ivan Lvov on 27.12.2022.
//

import SwiftUI


struct MyFont: ViewModifier {
    let font: String
    let weight: String
    let size: CGFloat
    
    init(font: String, weight: String, size: CGFloat) {
        self.font = font.capitalizingFirstLetter()
        self.weight = weight.capitalizingFirstLetter()
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("\(font)-\(weight)", size: size))
    }
}
