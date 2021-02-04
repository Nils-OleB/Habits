//
//  DayInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 04.02.21.
//

import SwiftUI

class DayInformation: ObservableObject {
    static let shared = DayInformation()
    private init() {}
    @Published var dayString = Date().dayMonthYearString
}
