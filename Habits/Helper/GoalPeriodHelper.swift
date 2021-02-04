//
//  GoalPeriodHelper.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.01.21.
//

import Foundation

class GoalPeriodHelper {
    static var goalPeriods = GoalPeriodID.allCases
    
    enum GoalPeriodID: String, CaseIterable{
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
    }
}
