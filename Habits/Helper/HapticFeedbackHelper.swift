//
//  HapticFeedbackHelper.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 22.10.20.
//

import Foundation
import UIKit

class HapticFeedbackHelper {
    static func buttonFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}
