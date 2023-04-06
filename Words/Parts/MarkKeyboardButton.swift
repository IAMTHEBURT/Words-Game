//
//  MarkKeyboardButton.swift
//  Words
//
//  Created by Иван Львов on 16.12.2022.
//

import SwiftUI

struct MarkKeyboardButton: View {
    // MARK: - PROPERTIES

    @StateObject var playViewModel: PlayViewModel
    @State private var isPressed: Bool = false

    // MARK: - BODY

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .stroke(playViewModel.checkButtonIsActive ? .blue : Color.gray.opacity(0.5), lineWidth: 2)
            .overlay {
                (playViewModel.checkButtonIsActive ? .blue : Color.gray.opacity(0.5))
                    .cornerRadius(6)
            }
            .overlay(
                Color.white
                    .opacity(isPressed ? 0.5 : 0)
                    .cornerRadius(6)
            )
            .overlay(
                Image(systemName: "checkmark")
            )
            .fontWeight(.bold)
            .scaleEffect(playViewModel.checkButtonIsActive ? 1.1 : 1)
            .animation(.linear(duration: 0.1), value: playViewModel.checkButtonIsActive)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        isPressed = true
                    })
                    .onEnded({ _ in
                        isPressed = false
                        if playViewModel.checkButtonIsActive == false {
                            return
                        }

                        try? playViewModel.checkTheLine()
                    })
            )
    }
}

// MARK: - PREVIW
struct MarkKeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        MarkKeyboardButton(playViewModel: PlayViewModel())
    }
}
