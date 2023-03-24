//
//  PlayField.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct PlayFieldView: View {
    // MARK: - PROPERTIES
    @StateObject var playVM: PlayViewModel
    @State private var showAlert: Bool = false
    @State private var flip: Bool = false
    @State private var alertText: String = ""
    
    private let spacing: CGFloat = 5
    
    private var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(minimum: size), spacing: 4), count: playVM.finalWord.count)
    }
    
    private var size: CGFloat {
        let count = playVM.finalWord.count
        
        if count == 5 || count == 6 {
            if UIScreen.main.bounds.width <= 375 {
                return 42
            } else{
                return 52
            }
        } else if count == 7 {
            return 42
        } else if count == 8 {
            return 38
        } else {
            return 32
        }
    }
    
    
    private func highLightCurrent(index: UUID) -> Bool {
        return playVM.currentLine.id == index
    }
    
    // MARK: - BODY
    
    var body: some View {
        LazyVGrid(columns: gridLayout, alignment: .center, spacing: spacing){
            //Text("\(UIScreen.main.bounds.width)")
            ForEach(playVM.lines){ line in
                ForEach((0...line.lettersCount - 1), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            line.getBGColorByIndex(
                                index: index,
                                highlightCurrent: highLightCurrent(index: line.id)
                            )
                        )
                        .frame(height: size)
                        .overlay(
                            Text(line.getCharacterByIndex(index: index))
                                .foregroundColor(line.getFontColorByIndex(index: index))
                                .modifier(MyFont(font: "Inter", weight: "bold", size: 36))
                        )
                        .id("\(line.id)\(index)")
                        .offset(y: playVM.shakeFieldId == "\(line.id)\(index)" ? -6 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    Text(alertText)
                                        .foregroundColor(.black)
                                )
                                .frame(width: 100, height: 50)
                                .offset(y: 100)
                                .opacity(showAlert ? 1 : 0)
                                .zIndex(2)
                        )
                        .onTapGesture{
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flip.toggle()
                            }

                            let state = line.getStateByIndex(index: index)
                            if state != .unanswered{
                                playVM.showNotifyView(headline: "\"\(line.getCharacterByIndex(index: index))\"", text: state.description)
                            }
                        }
                }

            } //: FOREACH LINES

            ForEach(0..<playVM.lettersCount, id: \.self) { index in
                let character = playVM.getResultFieldCharacterForIndex(index: index, empty: true)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(playVM.getResultFieldBGColorForIndex(index: index))
                    .overlay(
                        Text(character)
                            .modifier(MyFont(font: "Inter", weight: "bold", size: 36))
                    )
                    .frame(height: size)
                    .padding(.top, 20)
            }
            
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
        .frame(maxWidth: 600)
    }
}

// MARK: - PREVIW
struct PlayFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PlayFieldView(playVM: PlayViewModel())
    }
}
