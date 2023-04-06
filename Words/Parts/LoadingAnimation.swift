//
//  LoadingAnimation.swift
//  Words
//
//  Created by Ivan Lvov on 24.01.2023.
//

import SwiftUI

struct LoadingAnimation: View {
    // MARK: - PROPERTIES
    @State private var isAnimating: Bool = false

    private let elementWidth: CGFloat = 57
    private let elemetsPerLine: Int = 20

    private let firstLineColors: [Color] = [
        Color("unansweredLetterBackground"),
        Color("rightLetterRightPlaceBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("wrongLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground")
    ]

    private let secondLineColors: [Color] = [
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("rightLetterWrongPlaceBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("rightLetterRightPlaceBackground")
    ]

    private let thirdLineColors: [Color] = [
        Color("wrongLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("unansweredLetterBackground"),
        Color("wrongLetterBackground"),
        Color("unansweredLetterBackground")
    ]

    // MARK: - BODY

    var body: some View {
        VStack {
            VStack {
                // MARK: - FIRST LINE
                HStack {
                    ForEach((1...3), id: \.self) {_ in
                        ForEach((0...6), id: \.self) {index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(firstLineColors[index])
                                .frame(width: elementWidth, height: elementWidth)
                        }
                    }

                }
                .offset(x: isAnimating ? 0.4 * elementWidth * CGFloat(elemetsPerLine) : 0)
                .animation(
                    Animation
                        .linear(duration: 20)
                        .repeatForever(autoreverses: true)
                    ,
                    value: isAnimating
                )

                // MARK: - SECOND LINE
                HStack {
                    ForEach((1...3), id: \.self) {_ in
                        ForEach((0...6), id: \.self) {index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(secondLineColors[index])
                                .frame(width: elementWidth, height: elementWidth)
                        }
                    }

                }
                .offset(x: isAnimating ? 0.4 * elementWidth * CGFloat(elemetsPerLine) : 0)
                .animation(
                    Animation
                        .linear(duration: 30)
                        .repeatForever(autoreverses: true)
                    ,
                    value: isAnimating
                )

                // MARK: - THIRD LINE
                HStack {
                    ForEach((1...3), id: \.self) {_ in
                        ForEach((0...6), id: \.self) {index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(secondLineColors[index])
                                .frame(width: elementWidth, height: elementWidth)
                        }
                    }

                }
                .offset(x: isAnimating ? 0.4 * elementWidth * CGFloat(elemetsPerLine) : 0)
                .animation(
                    Animation
                        .linear(duration: 15)
                        .repeatForever(autoreverses: true)
                    ,
                    value: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

// MARK: - PREVIW
struct LoadingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimation()
            .previewLayout(.sizeThatFits)
    }
}
