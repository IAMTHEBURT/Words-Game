//
//  TestConView.swift
//  Words
//
//  Created by Ivan Lvov on 11.02.2023.
//

import SwiftUI
import ConfettiSwiftUI

struct TestConView: View {
    
    @State private var counter: Int = 0
    
    var body: some View {
        Button("🎉") {
            counter += 1
        }
        .confettiCannon(counter: $counter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
    }
    
}

struct TestConView_Previews: PreviewProvider {
    static var previews: some View {
        TestConView()
    }
}
