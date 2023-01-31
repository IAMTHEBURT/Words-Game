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
