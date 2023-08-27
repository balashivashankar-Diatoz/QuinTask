//
//  CustomButtonModifier.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI

struct CustomButtonModifier: ViewModifier {
    @State var backroundColor:Color
    init(backroundColor: Color) {
        self.backroundColor = backroundColor
    }
  func body(content: Content) -> some View {
    content
          .padding([.leading,.trailing],10)
          .padding([.top,.bottom],5)
          .background(backroundColor)
          .clipShape(Capsule())
  }
}
