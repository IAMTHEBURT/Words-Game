//
//  DistributionOfTries.swift
//  Words
//
//  Created by Ivan Lvov on 28.01.2023.
//

import SwiftUI
import CoreData

struct DistributionOfTries: View {
    // MARK: - PROPERTIES
    
    @StateObject var statVM: StatisticsViewModel
    @State private var maxWidth: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    // MARK: - FUNCTIONS
    func getWidthFor(count: Int) -> CGFloat{
        let part = CGFloat(count) / CGFloat(statVM.max) * 100.0
        return 0.62 * maxWidth / 100 * CGFloat(part)
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
                    
                    
                    ForEach(statVM.distributionData, id: \.self) { category in
                        DistributionElement(maxElementWidth: $maxWidth, title: category.first!.key, number: category.first!.value, maxNumber: statVM.max)
                    }
                    
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
        DistributionOfTries(statVM: StatisticsViewModel())
            .frame(height: 200)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension Array where Element: BinaryFloatingPoint {

    /// The average value of all the items in the array
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }

}
