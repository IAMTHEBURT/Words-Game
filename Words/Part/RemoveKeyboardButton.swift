//
//  MarkKeyboardButton.swift
//  Words
//
//  Created by Иван Львов on 16.12.2022.
//

import SwiftUI

struct RemoveKeyboardButton: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var playViewModel: PlayViewModel
    @State private var isPressed: Bool = false
    
    let sound: String
    
    
    // MARK: - BODY
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(
                playViewModel.removeButtonIsActive ? Color.white : Color.gray.opacity(0.5)
            )
            .overlay(
                Image(systemName: "delete.left")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                    .foregroundColor(playViewModel.removeButtonIsActive ? Color.black : Color.white)
                    .animation(.easeInOut(duration: 0.15), value: playViewModel.removeButtonIsActive)
            )
            .onTapGesture {
                playSound(sound: sound, type: "wav")
                playViewModel.removeCharacter()
            }
    }
}

// MARK: - PREVIW
struct RemoveKeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        RemoveKeyboardButton(playViewModel: PlayViewModel(), sound: "custom-2.wav")
    }
}
