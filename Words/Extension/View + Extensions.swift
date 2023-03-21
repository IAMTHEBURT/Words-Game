//
//  View + Extensions.swift
//  Words
//
//  Created by Ivan Lvov on 21.03.2023.
//

import SwiftUI

extension View {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

