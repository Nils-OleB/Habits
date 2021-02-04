//
//  DatePickerInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 17.01.21.
//

import Foundation

class DatePickerInformation: ObservableObject {
    init(endDate: Date, selectedDate: Date, chooseDay: Bool) {
        monthNames = Date.calendar.monthSymbols
        yearNames = DatePickerInformation.createYearNames(endDate: endDate)
        
        monthIndex = selectedDate.monthNumber - 1
        let selectedYear = selectedDate.yearNumber
        yearIndex = selectedYear - 2000
        
        calendarInformation = CalendarInformation(date: selectedDate,
                                                  buttonArrowActive: true)
        
        type = chooseDay ? .dayPicker : .monthPicker
        self.chooseDay = chooseDay
    }
    
    private static func createYearNames(endDate: Date) -> [String] {
        var tmpDate = Date(day: 1, month: 1, year: 2000)!.start(of: .year)
        var result = [String]()
        repeat {
            result.append(tmpDate.yearString)
            tmpDate = tmpDate.next(.year)
        } while tmpDate.timeIntervalSince(endDate) <= 0
        
        return result
    }
    
    func updateCurrentDate(_ currentDate: Date) {
        monthIndex = currentDate.monthNumber - 1
        let selectedYear = currentDate.yearNumber
        yearIndex = selectedYear - 2000
    }
    
    var dateFromIndices: Date {
        let firstOfDate = Date(day: 1,
                               month: monthIndex + 1,
                               year: yearIndex + 2000) ??
                          Date()
        return
            Date(day: firstOfDate.numberOfDaysInMonth < calendarInformation.referenceDate.dayNumber ? 1 : calendarInformation.referenceDate.dayNumber,
                 month: monthIndex + 1,
                 year: yearIndex + 2000) ??
            Date()
    }
    
    @Published var calendarInformation: CalendarInformation!
    
    @Published var monthIndex: Int
    @Published var yearIndex: Int
    
    @Published var monthNames: [String]
    @Published var yearNames: [String]
    
    @Published var type: PickerType {
        didSet {
            switch type {
            case .dayPicker:
                calendarInformation.referenceDate = dateFromIndices
            case .monthPicker:
                updateCurrentDate(calendarInformation.referenceDate)
            }
        }
    }
    
    @Published var chooseDay: Bool {
        didSet {
            if chooseDay {
                type = .dayPicker
            }else {
                type = .monthPicker
            }
        }
    }
    
    enum PickerType {
        case dayPicker, monthPicker
    }
}
