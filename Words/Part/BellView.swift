//
//  BellView.swift
//  Words
//
//  Created by Ivan Lvov on 16.02.2023.
//

import SwiftUI

struct BellView: View {
    // MARK: - PROPERTIES
    
    @State var isAnimating: Bool = false
    @AppStorage("isDailyWordNotificationSet") var isDailyWordNotificationSet: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        ZStack{
            Image(systemName: isDailyWordNotificationSet ? "bell.fill" : "bell")
                .rotationEffect(isAnimating ? Angle(degrees: 30) : Angle(degrees: 0), anchor: .top)
                .animation(
                    Animation
                        .linear(duration: 0.2)
                        .repeatCount(6, autoreverses: true)
                    , value: isAnimating)
            
                .onTapGesture {
                    isDailyWordNotificationSet.toggle()
                }
        }
        .onChange(of: isDailyWordNotificationSet) { newValue in
            isAnimating.toggle()
        }
        
    }
}

// MARK: - PREVIW
struct BellView_Previews: PreviewProvider {
    static var previews: some View {
        BellView()
    }
}
