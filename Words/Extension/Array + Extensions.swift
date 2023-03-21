//
//  Array + Extensions.swift
//  Words
//
//  Created by Ivan Lvov on 21.03.2023.
//

import Foundation

extension Array where Element: BinaryFloatingPoint {
    /// The average value of all the items in the array
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }

}
