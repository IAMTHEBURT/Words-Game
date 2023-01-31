//
//  HistoryView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct StatView: View {
    // MARK: - PROPERTIES
    @StateObject private var settingsVM: StatisticsViewModel = StatisticsViewModel()
    
    let rowSpacing: CGFloat = 8
    let columnSpacing: CGFloat = 8
    
    var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 2)
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                // MARK: - PAGE HEADER
                PageHeaderView(title: "Статистика")
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack{
                        LazyVGrid(columns: gridLayout, spacing: columnSpacing){
                            StatBlockView(title: "Игр сыграно", count: settingsVM.totalGamesCount)
                            StatBlockView(title: "Всего побед", count: settingsVM.wonGamesCount)
                            StatBlockView(title: "Длина текущей череды побед", count: settingsVM.currentWinningStreak)
                            StatBlockView(title: "Максимальная череда побед", count: settingsVM.maxWinningStreak)
                            StatBlockView(title: "Всего выиграно слов дня", count: settingsVM.wonDailyWordGamesCount)
                            StatBlockView(title: "Всего слов дня сыграно", count: settingsVM.totalDailyWordGamesCount)
                            StatBlockView(title: "Среднее количество попыток на победу", count: settingsVM.averageCountOfTriesForWin)
                            StatBlockView(title: "Среднее количество слов в день", count: settingsVM.averageCountOfWordsPerDay)
                        }
                        .lineLimit(3)
                        .padding(.top, 37)
                        
                        Spacer()
                            .frame(height: 41)
                        
                        DistributionOfTries()
                            .frame(height: 500)
                    }
                    .padding(.bottom, 186)

                }
                
            }
            .padding(.horizontal, 16)
            
            VStack{
                Spacer()
                BottomMenu()
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
            }
            
        }
        .foregroundColor(.black)
        .onAppear{
            settingsVM.setStats()
        }
    }
}

// MARK: - PREVIW

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            StatView()
        }

    }
}


