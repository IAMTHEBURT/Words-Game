//
//  RatingView.swift
//  Words
//
//  Created by Ivan Lvov on 29.01.2023.
//

import SwiftUI

struct RatingView: View {
    
    
    
    var body: some View {
        ZStack{
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                PageHeaderView(title: "Рейтинг")
                    .padding(.horizontal, 17)
                
                Spacer()
                    .frame(height: 48)
                
                VStack(spacing: 0){
                    
                    HStack{
                        Text("1")
                        Spacer()
                        Text("Quizstar")
                        Spacer()
                        Text("54376335")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedCorners(color: Color(hex: "#DD6B4E"), tl: 8, tr: 8, bl: 0, br: 0)
                    )
                    
                    Rectangle()
                        .fill(Color(hex: "#4D525B"))
                        .frame(height: 1)
                    
                    HStack{
                        Text("2")
                        Spacer()
                        Text("Dendy")
                        Spacer()
                        Text("888888")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    
                    Rectangle()
                        .fill(Color(hex: "#4D525B"))
                        .frame(height: 1)
                    
                    HStack{
                        Text("3")
                        Spacer()
                        Text("RRRR")
                        Spacer()
                        Text("5666")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    
                    Rectangle()
                        .fill(Color(hex: "#4D525B"))
                        .frame(height: 1)
                    
                    HStack{
                        Text("...")
                        Spacer()
                        Text("")
                        Spacer()
                        Text("...")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    
                    
                    VStack{
                        HStack{
                            Text("234")
                            Spacer()
                            Text("Unknown8363788")
                            Spacer()
                            Text("320")
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        
                        HStack(spacing: 24){
                            Spacer()
                            RatingIcon(bgColor: Color(hex: "#DE6B4E"), iconName: "rating_icon_grow")
                            RatingIcon(bgColor: Color(hex: "#E99C5D"), iconName: "rating_icon_share")
                            RatingIcon(bgColor: Color(hex: "#289788"), iconName: "rating_icon_edit")
                            Spacer()
                        }
                    }
                    .padding(.bottom, 26)
                    .background(
                        RoundedCorners(color: Color(hex: "#4D525B"), tl: 0, tr: 0, bl: 8, br: 8)
                        
                    )
                }
                .background(
                    Color(hex: "#2D2F38")
                )
                .padding(.horizontal, 17)
                
                Spacer()
                
            }
        }
        .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
    }
    
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}

struct RatingIcon: View {
    let bgColor: Color
    let iconName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(bgColor)
            .frame(width: 48, height: 48)
            .overlay(
                Image(iconName)
            )
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}
