//
//  GameTypeButtomVertical.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import SwiftUI

struct GameTypeButtonVerticalView: View {
    // MARK: - PROPERTIES

    var title: String
    var subtitle: String
    var finished: Int
    var outOf: Int
    var color: Color
    var roundedCorners: [CGFloat] = [8, 8, 8, 8]
    var accessibilityIdentifier: String = ""

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Text(title)
                    .modifier(MyFont(font: "Inter", weight: "Bold", size: 20))
                    .fontWeight(.bold)
            }
            .frame(minHeight: 72)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(hex: "#289788"))

            VStack(spacing: 12) {
                Text("Пройдите все\nуровни один за\nдругим")
                if outOf > 0 {
                    Text( String("\(finished.formattedWithSeparator)/\(outOf.formattedWithSeparator)") )
                        .accessibilityIdentifier(accessibilityIdentifier)
                }

                Spacer()
            }
            .frame(height: 112)
            .modifier(MyFont(font: "Inter", weight: "Medium", size: 14))
        }
        .multilineTextAlignment(.center)
        .background(Color(hex: "#2C2F38"))
        .cornerRadius(8)
        .overlay(
            Image(systemName: "checkmark.circle.fill")
                .offset(x: -25, y: -8)
                .opacity(finished == outOf &&  outOf != 0 ? 1 : 0)
            ,
            alignment: .bottomTrailing
        )
    }
}

// MARK: - PREVIW

struct GameTypeButtonVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        GameTypeButtonVerticalView(title: "Турнир", subtitle: "Пройдите все уровни один за другим", finished: 90, outOf: 12190, color: Color(hex: "#289788"))
    }
}
