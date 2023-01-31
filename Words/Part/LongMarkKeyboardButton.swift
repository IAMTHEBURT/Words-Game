//
//  MarkKeyboardButton.swift
//  Words
//
//  Created by Иван Львов on 16.12.2022.
//

import SwiftUI

struct LongMarkKeyboardButton: View {
    @StateObject var playViewModel: PlayViewModel
    @State private var isPressed: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .overlay{
                Color(hex: "#2C2F38")
                    .cornerRadius(4)
            }
            .overlay(
                Color.white
                    .opacity(isPressed ? 0.5 : 0)
                    .cornerRadius(4)
            )
            .overlay(
                Text("проверить слово")
                    .modifier(MyFont(font: "Inter", weight: "medium", size: 20))
            )
            .animation(.linear(duration: 0.1), value: playViewModel.checkButtonIsActive)
            .shadow(color: .black.opacity(0.45), radius: 4, x: 1, y: 3)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        isPressed = true
                    })
                    .onEnded({ _ in
                        isPressed = false
                        if playViewModel.checkButtonIsActive == false{
                            return
                        }
                        playViewModel.checkTheLine()
                    })
            )
    }
}

struct LongMarkKeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        LongMarkKeyboardButton(playViewModel: PlayViewModel())
            .frame(width: 286, height: 40)
    }
}
