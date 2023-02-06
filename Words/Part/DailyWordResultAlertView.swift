//
//  DailyWordResultAlertView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct DailyWordResultAlertView: View {
    // MARK: - PROPERTIES
    @StateObject var mainVM: MainViewModel
    @StateObject var apiProvider: APIProvider = .shared
    
    @State var offset = CGSize.zero
    
    var numberOfTheDay: Int{
        let date = Date() // now
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: date)
        
        return day ?? 0
    }
    var gameHistoryModel: GameHistoryModel {
        return mainVM.getDailyWordGameHistory() ?? GameHistoryModel(gameDBM: .emptyInit())
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 19){
                Text("ВОРДЛИ ДНЯ")
                    .foregroundColor(Color(hex: "#2C2F38"))
                Text("/")
                    .foregroundColor(Color(hex: "#4D525B"))
                Text("День \(numberOfTheDay)")
                    .foregroundColor(.white)
            }
            .padding(.vertical, 26)
            .frame(minWidth: 0, maxWidth: .infinity)
            .modifier(MyFont(font: "Inter", weight: "Bold", size: 20))
            .background(RoundedCorners(color: Color(hex: "#DD6B4E"), tl: 8, tr: 8, bl: 0, br: 0))
            
            
            HStack(spacing: 0){
                Text("Угадали\nслово")
                    .frame(width: 80, alignment: .leading)
                Spacer()
                Text("\(apiProvider.wordstat?.wonPercent ?? 0)%")
                    .blur(radius: apiProvider.wordstat != nil ? 0 : 10)
                    .multilineTextAlignment(.center)
                                
                Spacer()
                Text("\(apiProvider.wordstat?.won ?? 0) игрок(ов)")
                    .blur(radius: apiProvider.wordstat != nil ? 0 : 10)
                    .frame(width: 120, alignment: .trailing)
            }
            .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 22)
            
            Rectangle()
                .fill(Color(hex: "#4D525B"))
                .frame(height: 1)
                .overlay{
                    ProgressView()
                        .opacity(apiProvider.wordstat == nil ? 1 : 0)
                }
            
            HStack(alignment: .center, spacing: 0){
                Text("Не угадали\nслово")
                    .frame(width: 80, alignment: .leading)
                
                Spacer()
                
                Text("\(apiProvider.wordstat?.lostPercent ?? 0)%")
                    .blur(radius: apiProvider.wordstat != nil ? 0 : 10)
                    //.multilineTextAlignment(.center)
                    .frame(alignment: .leading)
                Spacer()
                
                Text("\(apiProvider.wordstat?.lost ?? 0) игрок(ов)")
                    .blur(radius: apiProvider.wordstat != nil ? 0 : 10)
                    .frame(width: 120, alignment: .trailing)
            }
            .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 22)
            
            Rectangle()
                .fill(Color(hex: "#4D525B"))
                .frame(height: 1)
            
            HStack{
                MiniPlayField(gameHistoryModel: gameHistoryModel)
                    .frame(maxWidth: 108)
                    .onTapGesture {
                        dump(gameHistoryModel.letters)
                    }
                
                Spacer()
                
                VStack(spacing: 20){
                    VStack(spacing: 5){
                        Text("Загаданное слово")
                        Text("\(gameHistoryModel.word.uppercased())")
                    }
                    .foregroundColor(.white)
                        
                    Text("\(gameHistoryModel.tries) попыток из 6")
                }
                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                .padding(.trailing, 24)
                
            } //: EXTRA
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            
            Spacer()
                .frame(maxHeight: 23)
            
            VStack(spacing: 16){
                Text("Следующее слово через")
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                
                HStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black, radius: 8, x: 0, y: 4)
                        .overlay(
                            Text("\(mainVM.hours)")
                                .modifier(MyFont(font: "Inter", weight: "medium", size: 24))
                                .foregroundColor(.black)
                        )
                    
                    VStack(spacing: 12){
                        Circle()
                            .fill(.white)
                            .frame(width: 4, height: 4)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 4, height: 4)
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black, radius: 8, x: 0, y: 4)
                        .overlay(
                            Text("\(mainVM.minutes)")
                                .modifier(MyFont(font: "Inter", weight: "medium", size: 24))
                                .foregroundColor(.black)
                        )
                    
                    VStack(spacing: 12){
                        Circle()
                            .fill(.white)
                            .frame(width: 4, height: 4)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 4, height: 4)
                    }
                    
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black, radius: 8, x: 0, y: 4)
                        .overlay(
                            Text("\(mainVM.seconds)")
                                .modifier(MyFont(font: "Inter", weight: "medium", size: 24))
                                .foregroundColor(.black)
                        )
                    
                }
            }
            
            Spacer()
                .frame(maxHeight: 43)
            VStack(spacing: 16){
                Text("Продолжить отгадывать случайные слова?")
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                
                Button(action: {
                    print("Got tap")
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 217, height: 42)
                        .overlay(
                            Text("Поделиться")
                                .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                .foregroundColor(.white)
                        )
                }
                
                Button(action: {
                    mainVM.showingDailyWordIsFinishedAlert = false
                    mainVM.setProgressionGame()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 217, height: 42)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                        .overlay(
                            Text("Cледущее слово")
                                .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                .foregroundColor(Color(hex: "#242627"))
                        )
                }
            }
        }
        .padding(.bottom, 33)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#2C2F38"))
        )
        .offset(y: offset.height * 2)
        .opacity(2 - Double(abs(offset.height / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.height) > 100 {
                        mainVM.showingDailyWordIsFinishedAlert = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            offset = .zero
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onAppear{
            apiProvider.getWordstat( word: gameHistoryModel.word )
        }
        
        
    }
}


// MARK: - PREVIW

struct DailyWordResultAlertView_Previews: PreviewProvider {
    static var gameHistoryModel: GameHistoryModel {
        return GameHistoryModel(gameDBM: GameDBM.emptyInit())
    }
    
    static var previews: some View {
        DailyWordResultAlertView(mainVM: MainViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
        
    }
}
