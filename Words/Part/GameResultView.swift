//
//  GameResultView.swift
//  Words
//
//  Created by Ivan Lvov on 26.01.2023.
//

import SwiftUI

struct GameResultView: View {
    @StateObject var playVM: PlayViewModel
    
    let successTitle: String = "Поздравляем, вы отгадали слово!"
    let failTitle: String = "К сожалению, вы не угадали слово"
    
    let successSubtitle: String = "Закрепите свой успех!\nПродолжить отгадывать слова?"
    let failSubtitle: String = "Следующий этап будет более успешным!\nПродолжить отгадывать слова?"
    
    var body: some View {
        
        VStack(spacing: 24){
            Spacer()
            Text(playVM.result == .win ? successTitle : failTitle)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 20))
            HStack{
                
                ForEach(0..<playVM.lettersCount) { index in
                    let bgColor = playVM.getResultFieldBGColorForIndex(index: index)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(playVM.getResultFieldBGColorForIndex(index: index))
                        .overlay(
                            Text(playVM.finalWordAsArray[index])
                                .modifier(MyFont(font: "Inter", weight: "bold", size: 36))
                        )
                        .frame(width: 52, height: 52)
                }
            }
            
            Spacer()
            
            Text(playVM.result == .win ? successSubtitle : failSubtitle)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 16))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            Button(action: {
                playVM.setGame(gameType: .progression)
            }) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#E99C5D"))
                    .frame(width: 177, height: 42)
                    .overlay {
                        Text("Продолжить")
                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                            .foregroundColor(Color(hex: "#242627"))
                    }
            }
            
            Spacer()
        }
        
        
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(playVM: PlayViewModel())
    }
}
