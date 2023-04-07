//
//  FreeGameCategoryVerticalView.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import SwiftUI

struct FreeGameCategoryVerticalView: View {
    // MARK: - PROPERTIES
    var name: String
    var isOpened: Bool
    var finished: Int
    var outOf: Int
    var roundedCorners: [CGFloat] = [0, 0, 0, 0]

    // MARK: - FUNCTIONS

    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(hex: "#2C2F38")
                Text(name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(maxHeight: .infinity)
            }

            HStack(spacing: 0) {
                Circle()
                    .fill(isOpened ? Color(hex: "#289788") : Color(hex: "#FFFFFF"))

                    .frame(width: 15, height: 15)
                    .overlay(
                        Text("0")
                            .foregroundColor(Color(hex: "#1F2023"))
                            .fontWeight(.semibold)
                            .font(.system(size: 10))
                    )
                Spacer()

                if outOf > 0 {
                    Text("\(finished.formattedWithSeparator)/\(outOf.formattedWithSeparator)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.medium)
                        .layoutPriority(1)
                }
            }
            .padding(.horizontal, 10)
            .frame(maxHeight: .infinity)
            .background(RoundedCorners(color: Color(hex: "##4D525B"), bl: 8, br: 8))
        }
        .frame(height: 136)
    }
}

// MARK: - PREVIEW
struct FreeGameCategoryVerticalView_Previews: PreviewProvider {
    static var previews: some View {

        VStack {
            FreeGameCategoryVerticalView(name: "5 Букв", isOpened: true, finished: 10, outOf: 180)
                .previewLayout(.sizeThatFits)

            FreeGameCategoryVerticalView(name: "9 Букв", isOpened: true, finished: 110, outOf: 180)
                .previewLayout(.sizeThatFits)
        }

    }
}
