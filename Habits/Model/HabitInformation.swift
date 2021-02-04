//
//  HabitInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 04.02.21.
//

import SwiftUI

class HabitInformation: ObservableObject {
    init(titel: String?,
         color: Color,
         symbolID: SymbolHelper.SymbolID?,
         goal: Int,
         timesDone: Int,
         hideProgressNumbers: Bool = false) {
        self.titel = titel
        self.color = color
        self.symbolID = symbolID
        self.goal = goal
        self.timesDone = timesDone
        self.hideProgressNumbers = hideProgressNumbers
    }
    
    init(cdHabit: CDHabit, hideProgressNumbers: Bool = false) {
        self.titel = cdHabit.titel
        self.color = Color(cdHabit.colorID.rawValue)
        self.symbolID = cdHabit.symbolID
        self.goal = Int(cdHabit.goal)
        self.timesDone = cdHabit.numberFor(dayString: Date().dayMonthYearString)
        self.hideProgressNumbers = hideProgressNumbers
    }
    
    @Published var titel: String?
    @Published var color: Color
    @Published var symbolID: SymbolHelper.SymbolID?
    @Published var goal: Int
    @Published var timesDone: Int
    
    @Published var hideProgressNumbers: Bool
    
    var percentageDone: CGFloat {
        return CGFloat(timesDone) / CGFloat(goal)
    }
}
