//
//  GameResultView.swift
//  Words
//
//  Created by Ivan Lvov on 26.01.2023.
//

import SwiftUI

struct GameResultView: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var playVM: PlayViewModel
    
    let successTitle: String = "Поздравляем, вы отгадали слово!"
    let failTitle: String = "К сожалению, вы не угадали слово"
    
    let successSubtitle: String = "Закрепите свой успех!\nПродолжить отгадывать слова?"
    let failSubtitle: String = "Следующий этап будет более успешным!\nПродолжить отгадывать слова?"
    
    var showContinue: Bool = true
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 24){
            Spacer()
            Text(playVM.result == .win ? successTitle : failTitle)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 20))
            HStack{
                
                ForEach(0..<playVM.lettersCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(playVM.getResultFieldBGColorForIndex(index: index))
                        .overlay(
                            Text(playVM.finalWordAsArray[index])
                                .modifier(MyFont(font: "Inter", weight: "bold", size: 36))
                        )
                        .frame(maxWidth: 52, maxHeight: 52)
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            
            Group{
                Text(playVM.result == .win ? successSubtitle : failSubtitle)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 16))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                
                
                VStack(spacing: 12){
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
                    
                    Button(action: {
                        playVM.isShareSheetPresented = true
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 177, height: 42)
                            .overlay {
                                Text("Поделиться")
                                    .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                    .foregroundColor(Color.white)
                            }
                    }
                    .accessibilityIdentifier("shareButton")
                }
                
                
                Spacer()
            }
            .opacity(showContinue ? 1 : 0)
        }
        
        
    }
}

// MARK: - PREVIW
struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(playVM: PlayViewModel())
            .background(Color(hex: "#1F2023"))
    }
}
