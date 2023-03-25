//
//  GameTypeButtonView.swift
//  Words
//
//  Created by Иван Львов on 09.12.2022.
//

import SwiftUI

struct GameTypeButtonView: View {
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
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Spacer()
                
                if outOf > 0{
                    Text( String("\(finished.formattedWithSeparator)/\(outOf.formattedWithSeparator)") )
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .accessibilityIdentifier(accessibilityIdentifier)
                }
                
            }
            Text(subtitle)
                .font(.system(size: 12))
        }
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedCorners(color: color, tl: roundedCorners[0], tr: roundedCorners[1], bl: roundedCorners[2], br: roundedCorners[3])
        )
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

struct GameTypeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GameTypeButtonView(title: "Турнир", subtitle: "Пройдите все уровни один за другим", finished: 90, outOf: 12190, color: Color(hex: "#289788"))
    }
}
