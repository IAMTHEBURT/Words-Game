//
//  StatBlockView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct StatBlockView: View {
    // MARK: - PROPERTIES
    var title: String
    var count: Double
    
    var countString: String{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: count as NSNumber) ?? "n/a"
        
        //String(format: "", count)
        
    }
    
    // MARK: - BODY
    var body: some View {
        HStack{
            VStack{
                Spacer()
                Text(title)
                    .opacity(0.8)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 12)
                Spacer()
                
                RoundedCorners(color: Color(hex: "#289788"), tl: 0, tr: 0, bl: 8, br: 8)
                    .overlay(
                        Text(countString)
                    )
                    .frame(maxHeight: 40)
                
            }
        }
        .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
        .foregroundColor(.white)
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#2C2F38"))
        )
    }
}

// MARK: - PREVIEW
struct StatBlockView_Previews: PreviewProvider {
    static var previews: some View {
        StatBlockView(title: "Среднее распределение выиггрышных попыток", count: 5)
            .previewLayout(.sizeThatFits)
            .frame(width: 175, height: 120)
            .padding()
    }
}
