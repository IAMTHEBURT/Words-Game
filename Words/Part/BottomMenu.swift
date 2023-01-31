//
//  BottomMenu.swift
//  Words
//
//  Created by Ivan Lvov on 18.01.2023.
//

import SwiftUI

struct BottomMenu: View {
    @StateObject var bottomMenuVM: BottomMenuViewModel = BottomMenuViewModel.shared
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#2C2F38"))
            HStack(spacing: 0){
                BottomMenuElement(isActive: bottomMenuVM.activeScreen == .game, title: "игра", icon: "icon_rules")
                    .onTapGesture {
                        bottomMenuVM.changeScreen(screen: .game)
                    }
                
                BottomMenuElement(isActive: bottomMenuVM.activeScreen == .stat, title: "статистика", icon: "icon_statistics")
                    .onTapGesture {
                        bottomMenuVM.changeScreen(screen: .stat)
                    }
                
                BottomMenuElement(isActive: bottomMenuVM.activeScreen == .settings, title: "настройки", icon: "icon_settings")
                    .onTapGesture {
                        bottomMenuVM.changeScreen(screen: .settings)
                    }
                
                BottomMenuElement(isActive: bottomMenuVM.activeScreen == .history, title: "история", icon: "icon_history")
                    .onTapGesture {
                        bottomMenuVM.changeScreen(screen: .history)
                    }
            }
            .cornerRadius(6)
        }
        .frame(height: 74)
        .padding(.horizontal, 16)
    }
}

struct BottomMenu_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenu()
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
        .blending(color: isActive ? Color(hex: "#ffffff") : Color.clear)
        .background(isActive ? Color(hex: "#4D525B") : Color.clear)
    }
}



public struct ColorBlended: ViewModifier {
  fileprivate var color: Color
  
  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

extension View {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}
