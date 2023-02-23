//
//  CategoryView.swift
//  Words
//
//  Created by Иван Львов on 09.12.2022.
//

import SwiftUI

struct NewCategoryView: View{
    // MARK: - PROPERTIES
    var name: String
    var isOpened: Bool
    var finished: Int
    var outOf: Int
    var roundedCorners: [CGFloat] = [0, 0, 0, 0]
    
    
    // MARK: - FUNCTIONS
    
    // MARK: - BODY
    var body: some View {
        HStack{
            Text(name)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
            
            HStack(spacing: 0){
                Circle()
                    .fill(isOpened ? Color(hex: "#289788") : Color(hex: "#4D525B"))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("0")
                            .foregroundColor(Color(hex: "#1F2023"))
                            .font(.system(size: 10))
                    )
                Spacer()
                
                if outOf > 0{
                    Text("\(finished.formattedWithSeparator)/\(outOf.formattedWithSeparator)")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .layoutPriority(1)
                }
            }
            .frame(width: 90)
        }
        .padding(.top, 26)
        .padding(.bottom, 30)
        .padding(.horizontal, 12)
        .background(
            RoundedCorners(
                color: Color(hex: "#2C2F38"),
                tl: roundedCorners[0],
                tr: roundedCorners[1],
                bl: roundedCorners[2],
                br: roundedCorners[3]
            )
        )
    }
}

// MARK: - PREVIEW
struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack{
            NewCategoryView(name: "5 Букв", isOpened: true, finished: 10, outOf: 180)
                .previewLayout(.sizeThatFits)
            
            NewCategoryView(name: "9 Букв", isOpened: true, finished: 110, outOf: 180)
                .previewLayout(.sizeThatFits)
        }

        
    }
}
