//
//  ColorHelper.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 20.01.21.
//

import Foundation

class ColorHelper {
    static var colorNames = ColorID.allCases
    
    static var randomColor: ColorID {
        return colorNames.randomElement() ?? .pickerColor_1
    }
    
    enum ColorID: String, CaseIterable {
        case pickerColor_1 = "pickerColor-1"
        case pickerColor_2 = "pickerColor-2"
        case pickerColor_3 = "pickerColor-3"
        case pickerColor_4 = "pickerColor-4"
        case pickerColor_5 = "pickerColor-5"
        case pickerColor_6 = "pickerColor-6"
        case pickerColor_7 = "pickerColor-7"
        case pickerColor_8 = "pickerColor-8"
        case pickerColor_9 = "pickerColor-9"
        case pickerColor_10 = "pickerColor-10"
        case pickerColor_11 = "pickerColor-11"
        case pickerColor_12 = "pickerColor-12"
        case pickerColor_13 = "pickerColor-13"
        case pickerColor_14 = "pickerColor-14"
        case pickerColor_15 = "pickerColor-15"
        case pickerColor_16 = "pickerColor-16"
        case pickerColor_17 = "pickerColor-17"
        case pickerColor_18 = "pickerColor-18"
    }
}
