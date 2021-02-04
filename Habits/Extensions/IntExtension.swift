//
//  IntExtension.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 17.01.21.
//

import Foundation

extension Int {
    var numberOfDigits: Int {
        var workingValue = self
        var numberOfDigits = 0
        
        repeat {
            workingValue = workingValue / 10
            numberOfDigits += 1
        }while workingValue > 0
        
        return numberOfDigits
    }
}
