//
//  LoadingScreen.swift
//  Words
//
//  Created by Ivan Lvov on 24.01.2023.
//

import SwiftUI

struct LoadingScreen: View {
    // MARK: - PROPERTIES
    @State private var showingTitle: Bool = false
    @State private var showingButton: Bool = false
    
    @StateObject var bottomMenuVM = BottomMenuViewModel.shared
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color
                .black
                .opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Text("Добро\nпожаловать\nв вордл")
                        .textCase(.uppercase)
                        .modifier(MyFont(font: "Inter", weight: "Bold", size: 36.0))
                }
                .padding(.leading, 16)
                .opacity(showingTitle ? 1 : 0)
                
                Spacer()
                
                LoadingAnimation()
                
                Spacer()
                
            } //: MAIN VSTACK
            
            
            
            VStack{
                Spacer()
                Button(action: {
                    bottomMenuVM.isInitialLoadingFinished = true
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(width: 138, height: 42)
                            .overlay(Text("Начать"))
                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                            .foregroundColor(Color(hex: "#242627"))
                    }
                    .opacity(showingButton ? 1 : 0)
                }
            }
        }
        .onAppear{
            withAnimation(.easeIn(duration: 2)) {
                showingTitle.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showingButton.toggle()
                }
            }
        }
        
    }
}



// MARK: - PREVIW

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}