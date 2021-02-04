//
//  CalendarInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import Foundation

class CalendarInformation: ObservableObject {
    init(date: Date, buttonArrowActive: Bool) {
        self.referenceDate = date
        self.buttonArrowActive = buttonArrowActive
    }
    
    let buttonArrowActive: Bool
    
    @Published var referenceDate: Date
    
    func getDayNumber(forRow row: Int, column: Int) -> Int? {
        var weekdayIndex = Date.calendar.component(.weekday, from: referenceDate.start(of: .month)) - Date.calendar.firstWeekday
        
        while weekdayIndex < 0 {
            weekdayIndex += 7
        }
        
        let dayNumber = (row * 7) + (column + 1) - weekdayIndex
                
        if dayNumber <= 0 || dayNumber > referenceDate.numberOfDaysInMonth {
            return nil
        }else {
            return dayNumber
        }
    }
}
