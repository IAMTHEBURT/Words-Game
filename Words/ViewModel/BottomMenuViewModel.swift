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
    static let shared: BottomMenuViewModel = BottomMenuViewModel()
    @Published var activeScreen: ActiveScreen = .game
    @Published var isInitialLoadingFinished: Bool = false
    
    func changeScreen(screen: ActiveScreen){
        print(screen.hashValue)
        withAnimation(.easeIn(duration: 0.3)){
            self.activeScreen = screen
        }
        
    }
}
