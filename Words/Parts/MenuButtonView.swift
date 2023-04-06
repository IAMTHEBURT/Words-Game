//
//  MenuButtonView.swift
//  Words
//
//  Created by Иван Львов on 09.12.2022.
//

import SwiftUI

struct MenuButtonView: View {
    // MARK: - PROPERTIES

    var systemImageName: String
    var text: String

    // MARK: - BODY

    var body: some View {
        HStack {
            Image(systemName: systemImageName )
            Text(text)
                .minimumScaleFactor(0.8)
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.white)
        )
        .foregroundColor(.black)
        .font(.callout)
        .lineLimit(1)
    }
}

// MARK: - PREVIW
struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(systemImageName: "gear", text: "crossmark")
            .previewLayout(.sizeThatFits)
    }
}
