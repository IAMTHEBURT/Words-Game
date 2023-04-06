//
//  DistributionElement.swift
//  Words
//
//  Created by Ivan Lvov on 29.01.2023.
//

import SwiftUI

struct DistributionElement: View {
    // MARK: - PROPERTIES

    @State private var isAnimating: Bool = false
    @Binding var maxElementWidth: CGFloat
    @State private var showNumber: Bool = false

    var title: String = "Слово дня"
    var number: Double = 0
    var maxNumber: Double = 80

    // MARK: - FUNCTIONS
    func getWidth() -> CGFloat {
        let part = CGFloat(number) / CGFloat(maxNumber) * 100.0
        return 0.62 * maxElementWidth / 100 * CGFloat(part)
    }

    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .multilineTextAlignment(.leading)
                .frame(width: maxElementWidth * 0.35)
                .foregroundColor(.white)

            Rectangle()
                .fill(.white)
                .frame(width: 1)

            if getWidth() > 0 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.clear)
                    .frame(width: isAnimating ? getWidth() : 0, height: 64)
                    .overlay {
                        Color.white
                            .frame(height: 32)
                    }
                    .overlay {
                        Text("\(number, specifier: "%.1f")")
                            .foregroundColor(.black)
                            .opacity(showNumber ? 1 : 0)
                    }
            }

            Spacer()

        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .onAppear {
            let delay = Double.random(in: 0...1)

            withAnimation(
                .linear(duration: 1)
                .delay(delay)

            ) {
                isAnimating.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.linear(duration: 1 + delay)) {
                    showNumber.toggle()
                }

            }
        }
    }
}

// MARK: - PREVIW
struct DistributionElement_Previews: PreviewProvider {
    static var previews: some View {
        DistributionElement(maxElementWidth: .constant(500))
    }
}
