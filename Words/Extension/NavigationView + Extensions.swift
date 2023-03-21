//
//  NavigationView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}

