//
//  PortraitPlayView.swift
//  Words
//
//  Created by Ivan Lvov on 19.12.2022.
//

import SwiftUI

struct PortraitPlayView: View {
    // MARK: - PROPERTIES
    
    @StateObject var playVM = PlayViewModel()
    @State private var fieldHeight: CGFloat = 0
    @State private var countDownTrigger: Bool = false
    
    @State private var alertText: String = ""
    @State private var showAlert: Bool = false
    @State private var flip: Bool = false
    @State private var isShareSheetPresented: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - BODY
    
    var body: some View {
        ZStack(alignment: .center){
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            NotificationView(playViewModel: playVM)
                .zIndex(1)
            
            VStack(alignment: .center, spacing: 0){
                // MARK: - PAGE HEADER
                PageHeaderView(title: playVM.gameType.name)
                
                if playVM.gameIsFinished {
                    ScrollView(.vertical, showsIndicators: false){
                        GameResultView(playVM: playVM)
                        CommentsView(playVM: playVM)
                    }
                    .padding(.horizontal, 14)
                }else{
                    PlayFieldView(playVM: playVM)
                    KeyboardView(playViewModel: playVM)
                        .padding(.top, 31)
                }
                
            }
            .onChange(of: playVM.shakeFieldId) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        playVM.shakeFieldId = nil
                    }
                }
            }
            .sheet(isPresented: $playVM.isShareSheetPresented) {
                ShareSheetView(
                    headline: "Игра Wordle (RU) День #357")
            }
            
//            if playVM.isResultAlertPresented{
//                GameResultAlertView(playVM: playVM, countDownTrigger: $countDownTrigger)
//            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - PREVIW
struct PortraitPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PortraitPlayView()
    }
}
