//
//  ColorBlended.swift
//  Words
//
//  Created by Ivan Lvov on 21.03.2023.
//

import SwiftUI

public struct ColorBlended: ViewModifier {
  var color: Color

  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

