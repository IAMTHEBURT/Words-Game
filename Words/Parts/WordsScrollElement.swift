//
//  WordsScrollElement.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import SwiftUI

struct WordsScrollElement: View {
    let word: String

    init(word: String) {
        self.word = word.uppercased()
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(word.enumerated()), id: \.offset) { (_, letter) in
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#4D525B"))
                    Text(String(letter))
                        .modifier(MyFont(font: "Inter", weight: "Bold", size: 16))
                }
                .frame(width: 24, height: 24)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#2C2F38"))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.45), radius: 4, x: 0.0, y: 5.0)
        )
    }
}

struct WordsScrollElement_Previews: PreviewProvider {
    static var previews: some View {
        WordsScrollElement(word: "Антиква")
    }
}
