//
//  HistoryView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct StatView: View {
    // MARK: - PROPERTIES
    @StateObject private var statVM: StatisticsViewModel = StatisticsViewModel()
    
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
                    .offset(y: 2)
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack{
                        LazyVGrid(columns: gridLayout, spacing: columnSpacing){
                            StatBlockView(title: "Игр сыграно", count: statVM.totalGamesCount)
                            StatBlockView(title: "Всего побед", count: statVM.wonGamesCount)
                            StatBlockView(title: "Длина текущей череды побед", count: statVM.currentWinningStreak)
                            StatBlockView(title: "Максимальная череда побед", count: statVM.maxWinningStreak)
                            StatBlockView(title: "Всего выиграно слов дня", count: statVM.wonDailyWordGamesCount)
                            StatBlockView(title: "Всего слов дня сыграно", count: statVM.totalDailyWordGamesCount)
                            StatBlockView(title: "Среднее количество попыток на победу", count: statVM.averageCountOfTriesForWin)
                            StatBlockView(title: "Среднее количество слов в день", count: statVM.averageCountOfWordsPerDay)
                        }
                        .lineLimit(3)
                        .padding(.top, 37)
                        
                        Spacer()
                            .frame(height: 41)
                        
                        DistributionOfTries(statVM: statVM)
                            .frame(height: 500)
                    }
                    .padding(.bottom, 186)

                }
                
            }
            .padding(.horizontal, 16)
            
        }
        .foregroundColor(.black)
        .onAppear{
            statVM.setStats()
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


