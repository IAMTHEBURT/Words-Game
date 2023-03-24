//
//  SwiftUIView.swift
//  Lingua Widget
//
//  Created by Иван Львов on 04.10.2021.
//

import SwiftUI

struct CustomProgressView: View {
    // MARK: - BODY

    var body: some View {
        VStack{
            ProgressView()
                .frame(width: 50, height: 50, alignment: .center)
        }
        .background(.thinMaterial.opacity(0.8))
        .cornerRadius(8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        //.zIndex(9999999)
    }
}

// MARK: - PREVIW

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
