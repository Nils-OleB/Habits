//
//  ColorExtension.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.10.20.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(hex: String?) {
        guard let hex = hex else {
            self.init(.gray)
            return
        }
        
        let r, g, b: CGFloat
 
        if hex.count == 6 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                
                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }
        
        self.init(.gray)
        return
    }
    
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
    
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
}
