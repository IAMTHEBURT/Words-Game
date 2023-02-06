//
//  GameHistoryElementView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct GameHistoryElementView: View {
    // MARK: - PROPERTIES
    
    @State private var isCollapsed: Bool = false
    @State private var extraOpacity: Double = 0
    
    @State private var showResultSheet: Bool = false
    
    var gameHistoryModel: GameHistoryModel
    
    var stringDate: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: gameHistoryModel.date)
    }
    
    // MARK: - FUNCTIONS
    func getBGColor() -> Color{
        if gameHistoryModel.result == .win {
            return Color(hex: "#289788")
        } else{
            return Color(hex: "#4D525B")
        }
    }
    
    
    func open() {
        withAnimation(.linear(duration: 0.25)){
            isCollapsed.toggle()
        }
        
        withAnimation(
            Animation
                .linear(duration: 0.25)
                .delay(0.1)
        ){
            extraOpacity = extraOpacity == 0 ? 1 : 0
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            ZStack{
                Color.black
                    .opacity(0.0001)
                    .onTapGesture {
                        open()
                    }
                HStack(spacing: 35){
                    //DATE
                    VStack(alignment: .leading, spacing: 8){
                        Text(gameHistoryModel.gameType.name)
                            .modifier(MyFont(font: "Inter", weight: "Bold", size: 20))
                        Text(stringDate)
                            .modifier(MyFont(font: "Inter", weight: "Medium", size: 12))
                    }
                    .foregroundColor(.white)
                    Spacer()
                    //SHRINK BUTTON
                    Image("collapse.arrow")
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: isCollapsed ? 180 : 0))
                    
                } // MARK: - MAIN HSTACK
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .onTapGesture {
                    open()
                }
                .sheet(isPresented: $showResultSheet) {
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            GameResultView(playVM: PlayViewModel(gameHistory: gameHistoryModel), showContinue: false)
                            CommentsView(playVM: PlayViewModel(gameHistory: gameHistoryModel))
                        }
                    }
                }
            }
            
            
            
            // EXTRA INFORMATION
            if isCollapsed {
                HStack{
                    MiniPlayField(gameHistoryModel: gameHistoryModel)
                        .frame(maxWidth: 108)
                        .onTapGesture {
                            //dump(gameHistoryModel.letters)
                            showResultSheet.toggle()
                        }
                    
                    Spacer()
                    
                    VStack(spacing: 20){
                        
                        VStack(spacing: 5){
                            Text("Загаданное слово")
                            Text("\(gameHistoryModel.word.uppercased())")
                        }
                        .foregroundColor(.white)
                        .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                            
                        
                        Button(action: {
                            print("Got tap")
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#FFFFFF"))
                                .frame(height: 46)
                                .frame(maxWidth: 160)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                            
                                .overlay(
                                    Text("Поделиться")
                                        .foregroundColor(Color(hex: "#242627"))
                                )
                            
                        }
                    }
                    
                } //: EXTRA
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(Color(hex: "#2C2F38"))
                .opacity(extraOpacity)
            }
        } //: MAINV STACK
        .background(getBGColor())
        .cornerRadius(8)
        .onAppear{
            //open()
        }
    }
}

// MARK: - PREVIEW
struct GameHistoryElementView_Previews: PreviewProvider {
    
    static var gameHistoryModel: GameHistoryModel {
        return GameHistoryModel(gameDBM: GameDBM.emptyInit())
    }

    static var previews: some View {
        GameHistoryElementView(gameHistoryModel: gameHistoryModel)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
