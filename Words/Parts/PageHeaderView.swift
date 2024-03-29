//
//  PageHeaderView.swift
//  Words
//
//  Created by Ivan Lvov on 24.01.2023.
//

import SwiftUI

enum HeaderSheet: Identifiable {
    case rules, rating

    var id: Int {
        hashValue
    }
}

struct PageHeaderView: View {

    // MARK: - PROPERTIES

    @StateObject var apiProvider = APIProvider.shared

    var blockRatingButton: Bool = false
    var title: String

    var hideHomeIcon: Bool = true
    var hideRulesIcon: Bool = false

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var bottomMenuVM: BottomMenuViewModel

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                bottomMenuVM.showMenu()
                presentationMode.wrappedValue.dismiss()
                bottomMenuVM.activeScreen = .game
            }) {
                Image("go_home_icon")
            }
            .opacity(hideHomeIcon ? 0 : 1)

            Spacer()

            Text(title)
                .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
            Spacer()

            HStack(spacing: 15) {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .opacity(hideRulesIcon ? 0 : 1)
                    .onTapGesture {
                        bottomMenuVM.headerSheetPresented = .rules
                        bottomMenuVM.isSheetPresented = true
                    }

                HStack(spacing: 10) {
                    Image("icon_rating")
                    Text("\(apiProvider.points)")
                        .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
                        .accessibilityIdentifier("points")
                }
                .onTapGesture {
                    if blockRatingButton {
                        return
                    }
                    bottomMenuVM.headerSheetPresented = .rating
                    bottomMenuVM.isSheetPresented = true
                }
            }
        }
        .foregroundColor(.white)
        .padding(17)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#4D525B"))
        }
    }
}

// MARK: - PREVIW
struct PageHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PageHeaderView(title: "Рейтинг")
    }
}
