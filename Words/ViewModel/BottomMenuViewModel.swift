//
//  BottomMenuViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 18.01.2023.
//

import Foundation
import SwiftUI

class BottomMenuViewModel: ObservableObject{
    // MARK: - PROPERTIES
    //static let shared: BottomMenuViewModel = BottomMenuViewModel()
    
    @Published var activeScreen: ActiveScreen = .game
    @Published var isInitialLoadingFinished: Bool = false
    @Published var isBottomMenuHidden: Bool = true
    @Published var isSheetPresented: Bool = false
    @Published var headerSheetPresented: HeaderSheet = .rules
    @Published var isOnboardingPagePresented: Bool = false
    
    func changeScreen(screen: ActiveScreen){
        print(screen.hashValue)
        withAnimation(.easeIn(duration: 0.3)){
            self.activeScreen = screen
        }
    }
    
    func hideMenu(){
        withAnimation {
            isBottomMenuHidden = true
        }
    }
    
    func showMenu(){
        withAnimation(.linear(duration: 0.6)) {
            isBottomMenuHidden = false
        }
    }
    
}
