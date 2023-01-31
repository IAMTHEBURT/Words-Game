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
    
    let spacing: CGFloat = 5
    
    var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(minimum: 52), spacing: 4), count: playVM.finalWord.count)
    }
    
    // MARK: - BODY
    
    var body: some View {
        LazyVGrid(columns: gridLayout, alignment: .center, spacing: spacing){
            ForEach(playVM.lines){ line in
                ForEach((0...line.lettersCount - 1), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            line.getBGColorByIndex(index: index)
                        )
                        .frame(height: 52)
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

            ForEach(0..<playVM.lettersCount) { index in
                let bgColor = playVM.getResultFieldBGColorForIndex(index: index)
                let character = playVM.getResultFieldCharacterForIndex(index: index, empty: true)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(playVM.getResultFieldBGColorForIndex(index: index))
                    .overlay(
                        Text(character)
                            .modifier(MyFont(font: "Inter", weight: "bold", size: 36))
                    )
                    .frame(height: 52)
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
