//
//  ContentView.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    @StateObject var mainVM = MainViewModel()
    @StateObject var bottomMenuVM = BottomMenuViewModel()
    @State var isInitialLoadingHidden: Bool = false
    @AppStorage("isOnboardingFinished") private var isOnboardingFinished: Bool = false

    // MARK: - BODY

    var body: some View {
        Group {
            if bottomMenuVM.isInitialLoadingFinished {
                ZStack {
                    switch bottomMenuVM.activeScreen {
                    case .game:
                        MainView()
                            .environmentObject(mainVM)
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

                    VStack {
                        Spacer()
                        BottomMenuView()
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                            .padding(.bottom, 8)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if isOnboardingFinished == false {
                            return
                        }
                        bottomMenuVM.showMenu()
                    }
                }
                .sheet(isPresented: $bottomMenuVM.isSheetPresented) {
                    if bottomMenuVM.headerSheetPresented == .rules {
                        RulesView(mainVM: MainViewModel())
                    } else {
                        RatingView()
                    }
                }
                .environmentObject(bottomMenuVM)

            } else {
                LoadingScreen(bottomMenuVM: bottomMenuVM)
                    .onAppear {
                        try? LocalDataProvider()
                            .checkAndStoreData()
                    }
            }
        }
    }
}

// MARK: - PREVIW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
