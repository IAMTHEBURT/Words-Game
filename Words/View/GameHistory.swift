//
//  GameHistory.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct GameHistory: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var gameHistoryVM: GameHistoryViewModel = GameHistoryViewModel(context: CoreDataProvider.shared.viewContext)
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    // MARK: - PAGE HEADER
                    PageHeaderView(title: "История игр")
                    
                    Spacer()
                        .frame(height: 66)
                    
                    LazyVStack{
                        ForEach(gameHistoryVM.games) { game in
                            GameHistoryElementView(gameHistoryModel: game)
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                } //: MAIN VSTACK
            } //: SCROLL VIEW
            
            VStack{
                Spacer()
                BottomMenu()
            }
            
        } //: VSTACK

    }
}

// MARK: - PREVIW

struct GameHistory_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameHistory()
        }
    }
}
