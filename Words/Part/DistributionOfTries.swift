//
//  DistributionOfTries.swift
//  Words
//
//  Created by Ivan Lvov on 28.01.2023.
//

import SwiftUI

struct DistributionOfTries: View {
    // MARK: - PROPERTIES
    
    var data: [ Int ] = [ 8, 17, 12, 6, 22, 19]
    
    var max: Int {
        data.max() ?? 0
    }
    
    @State private var maxWidth: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    // MARK: - FUNCTIONS
    func getWidthFor(count: Int) -> CGFloat{
        let part = CGFloat(count) / CGFloat(max) * 100.0
        
        return 0.62 * maxWidth / 100 * CGFloat(part)
        //return maxWidth / 100 * part
        //return 100.0
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0){

                    RoundedCorners(color: Color(hex: "#E99C5D"), tl: 8, tr: 8, bl: 0, br: 0)
                        .frame(height: 48)
                        .overlay(
                            Text("Распределение выигрышных попыток")
                                .foregroundColor(Color(hex: "##2C2F38"))
                                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                        )
                    
                    Spacer()
                        .frame(height: 30)
                    
                    DistributionElement(maxElementWidth: $maxWidth, title: "Слово дня", number: data[0], maxNumber: max)
                    DistributionElement(maxElementWidth: $maxWidth, title: "5 букв", number: data[1], maxNumber: max)
                    DistributionElement(maxElementWidth: $maxWidth, title: "6 букв", number: data[2], maxNumber: max)
                    DistributionElement(maxElementWidth: $maxWidth, title: "7 букв", number: data[3], maxNumber: max)
                    DistributionElement(maxElementWidth: $maxWidth, title: "8 букв", number: data[4], maxNumber: max)
                    DistributionElement(maxElementWidth: $maxWidth, title: "9 букв", number: data[5], maxNumber: max)
                    
                    Spacer()
                        .frame(height: 30)
                }
                .background(
                    Color(hex: "#2C2F38")
                        .cornerRadius(8)
                )
                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                .onAppear{
                    maxWidth = geo.size.width
                    withAnimation(.linear(duration: 1)){
                        isAnimating.toggle()
                    }
                }
                
            }
            
            
        }

    }
}

// MARK: - PREVIW
struct DistributionOfTries_Previews: PreviewProvider {
    static var previews: some View {
        DistributionOfTries()
            .frame(height: 200)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
