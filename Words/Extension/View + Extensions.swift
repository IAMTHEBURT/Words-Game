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
