//
//  BottomMenu.swift
//  Words
//
//  Created by Ivan Lvov on 18.01.2023.
//

import SwiftUI

struct BottomMenuView: View {
    
    // MARK: - PROPERTIES
    
    //@StateObject var bottomMenuVM: BottomMenuViewModel = BottomMenuViewModel.shared
    
    @EnvironmentObject var bottomMenuVM: BottomMenuViewModel
    @State var activeElement: Int = 0
    
    
    // MARK: - FUNCTIONS
    
    func setActive(_ id: Int){
        withAnimation {
            activeElement = id
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#2C2F38"))
            
            GeometryReader { geo in
                
                RoundedCorners(
                    color: Color(hex: "#4D525B"),
                    tl: activeElement == 0 ? 8 : 0,
                    tr: activeElement == 3 ? 8 : 0,
                    bl: activeElement == 0 ? 8 : 0,
                    br: activeElement == 3 ? 8 : 0
                )
                
                .frame(width: geo.size.width / 4)
                .offset(x: CGFloat(activeElement) * geo.size.width / 4)
                
                HStack(spacing: 0){
                    BottomMenuElement(isActive: bottomMenuVM.activeScreen == .game, title: "игра", icon: "go_home_icon")
                        .onTapGesture {
                            bottomMenuVM.changeScreen(screen: .game)
                            setActive(0)
                        }
                        
                    BottomMenuElement(isActive: bottomMenuVM.activeScreen == .stat, title: "статистика", icon: "icon_statistics")
                        .onTapGesture {
                            bottomMenuVM.changeScreen(screen: .stat)
                            setActive(1)
                        }
                    
                    BottomMenuElement(isActive: bottomMenuVM.activeScreen == .settings, title: "настройки", icon: "icon_settings")
                        .onTapGesture {
                            bottomMenuVM.changeScreen(screen: .settings)
                            setActive(2)
                        }
                    
                    BottomMenuElement(isActive: bottomMenuVM.activeScreen == .history, title: "история", icon: "icon_history")
                        .onTapGesture {
                            bottomMenuVM.changeScreen(screen: .history)
                            setActive(3)
                        }
                }
                .cornerRadius(6)
                
            }
        }
        .frame(height: 74)
        .padding(.horizontal, 16)
        .offset(y: bottomMenuVM.isBottomMenuHidden ? 1000 : 0)
    }
}

// MARK: - PREVIW

struct BottomMenu_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenuView()
    }
}


struct BottomMenuElement: View{
    var isActive: Bool
    var title: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8){
            Spacer()
                .frame(height: 10)
            Image(icon)
                .frame(height: 28)
            Text(title)
            Spacer()
                .frame(height: 10)
        }
        .font(.system(size: 10))
        .foregroundColor(Color(hex: "#7F838B"))
        .blending(color: isActive ? Color(hex: "#ffffff") : Color(hex: "#7F838B"))
        //.background(isActive ? Color(hex: "#4D525B") : Color.clear)
    }
}
