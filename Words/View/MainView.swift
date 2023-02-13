//
//  MainView.swift
//  Words
//
//  Created by Иван Львов on 09.12.2022.
//
import SwiftUI

struct MainView: View {
    // MARK: - PROPERTIES
    @StateObject private var mainVM: MainViewModel = MainViewModel()
    @StateObject private var APIProvider: APIProvider = .shared
    @AppStorage("isDailyWordNotificationSet") private var isDailyWordNotificationSet: Bool = false
    @State var isDailyWordAnimating: Bool = false

    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.25)
            .speed(2)
            .delay(0.25)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - BODY
    let categories: [Int] = [6, 7, 8, 9]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BGColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0){
                    
                    PageHeaderView(title: "ВОРДЛ")
                        .offset(y: 2)
                    //GAME OPTIONS
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            
                            
                            VStack(alignment: .leading, spacing: 8){
                                HStack{
                                    Text("Вордл дня")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                
                                Group{
                                    if mainVM.isDailyWordCompleted() {
                                        VStack(alignment: .leading){
                                            Text("Вы уже играли сегодня")
                                            Text("Следущее общее слово через \(mainVM.countDown)")
                                        }
                                    } else{
                                        Text("Общее слово для всех игроков")
                                    }
                                }
                                .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#DD6B4E"))
                            )
                            .overlay(
                                Image(systemName: isDailyWordNotificationSet ? "bell.fill" : "bell")
                                    .offset(x: -25, y: 10)
                                    .onTapGesture {
                                        NotificationProvider.shared.toggleNotifications()
                                    }
                                ,
                                alignment: .topTrailing
                            )
                            .offset( y: mainVM.isDailyWordAnimating ? 0 : -600 )
                            .animation(slideInAnimation, value: mainVM.isDailyWordAnimating)
                            .onTapGesture {
                                if mainVM.getDailyWordGameHistory() != nil{
                                    mainVM.showingDailyWordIsFinishedAlert.toggle()
                                }else{
                                    mainVM.startDailyWordGame()
                                }
                            }
                            
//                            VStack(alignment: .leading, spacing: 8){
//                                HStack{
//                                    Text("Вордл дня")
//                                        .font(.system(size: 20))
//                                        .fontWeight(.bold)
//                                    Spacer()
//                                }
//
//                                Group{
//                                    if mainVM.isDailyWordCompleted() {
//                                        VStack(alignment: .leading){
//                                            Text("Вы уже играли сегодня")
//                                            Text("Следущее общее слово через \(mainVM.countDown)")
//                                        }
//                                    } else{
//                                        Text("Общее слово для всех игроков")
//                                    }
//                                }
//                                .font(.system(size: 12))
//                            }
//                            .foregroundColor(.white)
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding(.vertical, 16)
//                            .padding(.horizontal, 12)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(hex: "#DD6B4E"))
//                            )
//                            .overlay(
//                                Image(systemName: isDailyWordNotificationSet ? "bell.fill" : "bell")
//                                    .offset(x: -25, y: 10)
//                                    .onTapGesture {
//                                        NotificationProvider.shared.toggleNotifications()
//                                    }
//                                ,
//                                alignment: .topTrailing
//                            )
//                            .offset( y: isDailyWordAnimating ? 0 : -600 )
//                            .animation(slideInAnimation, value: isDailyWordAnimating)
//                            .onTapGesture {
//                                if mainVM.getDailyWordGameHistory() != nil{
//                                    mainVM.showingDailyWordIsFinishedAlert.toggle()
//                                }else{
//                                    mainVM.startDailyWordGame()
//                                }
//                            }
                            
                            
                            
                            GameTypeButtonView(
                                title: "Турнир",
                                subtitle: "Пройдите все уровни один за другим",
                                finished: mainVM.getCountOff(type: .progression, finished: true),
                                outOf: mainVM.getCountOff(type: .progression),
                                color: Color(hex: "289788")
                            )
                            .onTapGesture {
                                mainVM.setProgressionGame()
                            }
                            
                            VStack(spacing: 0){
                                GameTypeButtonView(
                                    title: "Свободный режим",
                                    subtitle: "Уровни открываются за победы в турнире",
                                    finished: mainVM.getCountOff(type: .freeMode, finished: true),
                                    outOf: mainVM.getCountOff(type: .freeMode),
                                    color: Color(hex: "4D525B"),
                                    roundedCorners: [8, 8, 0, 0]
                                )
                                
                                ForEach(categories, id: \.self){ count in
                                    NewCategoryView(
                                        name: "\(count) букв",
                                        isOpened: mainVM.isFreeModeCategoryOpened(count: count),
                                        finished: mainVM.getCountOff(type: .freeMode, finished: true, difficulty: .low, symbolsCount: count),
                                        outOf: mainVM.getCountOff(type: .freeMode, finished: false, difficulty: .low, symbolsCount: count
                                                                 ),
                                        roundedCorners: count == 9 ? [0, 0, 8, 8] : [0, 0, 0, 0]
                                    )
                                    .onTapGesture {
                                        mainVM.startFreeModeGame(count: count)
                                    }
                                }
                            }
                            
                            
#if DEBUG
                            VStack{
                                
                                Button(action: {
                                    do {
                                        let allDailyWords = try CoreDataProvider.shared.viewContext.fetch(DailyWordDBM.all)
                                        
                                        allDailyWords.forEach { word in
                                            word.delete()
                                        }
                                        try CoreDataProvider.shared.viewContext.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    
                                }) {
                                    Text("Сбросить слова дня")
                                }
                                
                                
                                Button(action: {
                                    APIProvider.getComments(word: "Усадка")
                                }) {
                                    Text("Получить комменты")
                                }
                                
                                Button(action: {
                                    APIProvider.getPoints()
                                }) {
                                    Text("Получить очки")
                                }
                                
                                Button(action: {
                                    APIProvider.getTopList()
                                }) {
                                    Text("Получить топ")
                                }
                                
                                Button(action: {
                                    let gameHistory = GameHistoryModel(gameDBM: GameDBM.emptyInit())
                                    APIProvider.saveTheGame(game: gameHistory)
                                }) {
                                    Text("Сохранить игру")
                                }
                                
                                Button(action: {
                                    APIProvider.getWordOfTheDay()
                                }) {
                                    Text("Получить слово дня")
                                }
                                
                            }
#endif
                            
                        }
                        .padding(.top, 86)
                        .padding(.bottom, 186)
                        
                        
                        
                    } //: SCROLLVIEW
                    
                } //: MAIN VSTACK
                .padding(.horizontal, 16)
                
                Group{
                    if mainVM.showingDailyWordIsFinishedAlert {
                        Rectangle()
                            .fill( .black.opacity(0.75))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                mainVM.showingDailyWordIsFinishedAlert = false
                            }
                    }
                    
                    DailyWordResultAlertView(mainVM: mainVM)
                        .offset(y: mainVM.showingDailyWordIsFinishedAlert ? 0 : -1000)
                }
                
                
            } //: MAIN ZSTACK
            .animation(
                Animation.easeInOut(duration: 0.5), value: mainVM.showingDailyWordIsFinishedAlert
            )
            
            .onReceive(timer) { _ in
                mainVM.updateCountdown()
            }
            .onAppear{
                mainVM.updateTasksData()
                //APIProvider.getWordOfTheDay()
            }
//            .onChange(of: APIProvider.wordOfTheDayResponse, perform: { _ in
//                isDailyWordAnimating = true
//            })
            
//            .onChange(of: mainVM.dailyWord, perform: { dailyWord in
//                if dailyWord != nil {
//                    isDailyWordAnimating = true
//                }
//            })
            
            
            
            .navigationDestination(isPresented: $mainVM.pushToGame) {
                PortraitPlayView(playVM: mainVM.playVM)
            }
            .alert("🤓 Кажется, вы уже прошли этот блок слов. Вы всегда можете сбросить весь прогресс в настройках и начать сызнова.", isPresented: $mainVM.showingCompletedBlockAlert) {
                Button("Ок") { mainVM.showingCompletedBlockAlert = false }
            }
        } //: NAVIIGATION STACK
    }
}

// MARK: - PREVIW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
