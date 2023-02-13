//
//  ContentView.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bottomMenuVM = BottomMenuViewModel.shared
    @State var isInitialLoadingHidden: Bool = false
    
    var body: some View {
        
        if bottomMenuVM.isInitialLoadingFinished{
            
            ZStack{
                switch bottomMenuVM.activeScreen {
                case .game:
                    MainView()
                case .history:
                    GameHistory()
                case .stat:
                    StatView()
                case .settings:
                    SettingsView()
                case .rules:
                    EmptyView()
                case .rating:
                    RatingView()
                }
                
                VStack{
                    Spacer()
                    BottomMenuView()
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                        .padding(.bottom, 8)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    BottomMenuViewModel.shared.showMenu()
                }
            }

        }else{
            LoadingScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
