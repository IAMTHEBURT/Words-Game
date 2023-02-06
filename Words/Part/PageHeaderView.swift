//
//  PageHeaderView.swift
//  Words
//
//  Created by Ivan Lvov on 24.01.2023.
//

import SwiftUI

struct PageHeaderView: View {
    @StateObject var apiProvider = APIProvider.shared
    
    var blockRatingButton: Bool = false
    var title: String
    
    var showHomeIcon: Bool = true
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var bottomMenuVM = BottomMenuViewModel.shared
    @State var isSheetPresented: Bool = false
    var body: some View {
        ZStack{
            HStack(spacing: 0){
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    bottomMenuVM.activeScreen = .game
                }) {
                    Image("go_home_icon")
                }
                .opacity(showHomeIcon ? 1 : 0)
                
                Spacer()
                
                Text(title)
                    .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
                Spacer()
                HStack(spacing: 10){
                    Group{
                        Image("icon_rating")
                        Text("\(apiProvider.points)")
                            .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
                    }
                    .onTapGesture {
                        if blockRatingButton {
                            return
                        }
                        
                        isSheetPresented.toggle()
                    }
                }
            }
        } //: PAGE HEADER
        .foregroundColor(.white)
        .padding(17)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#4D525B"))
        }
        .sheet(isPresented: $isSheetPresented) {
            RatingView()
        }
    }
}

struct PageHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PageHeaderView(title: "Рейтинг")
    }
}
