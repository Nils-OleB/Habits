//
//  DateExtension.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 22.10.20.
//

import Foundation

extension Date {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.autoupdatingCurrent
        return calendar
    }
    
    static var shortWeekdayArray: [String] {
        var result = Date.calendar.shortWeekdaySymbols
        var weekdayIndex = Date.calendar.firstWeekday-1
        
        while weekdayIndex > 0 {
            result.append(result.remove(at: 0))
            weekdayIndex -= 1
        }
        
        return result
    }
    
    static var veryShortWeekdayArray: [String] {
        var result = Date.calendar.veryShortWeekdaySymbols
        var weekdayIndex = Date.calendar.firstWeekday-1
        
        while weekdayIndex > 0 {
            result.append(result.remove(at: 0))
            weekdayIndex -= 1
        }
        
        return result
    }
    
    
    //MARK: - String conversions
    var dayMonthYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var dayMonthYearString2: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    var dayMonthYearString3: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMMM yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    var dayMonthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self).uppercased()
    }
    
    var weekString: String {
        return "\(start(of: .week).dayMonthString) - \(end(of: .week).dayMonthString), \(end(of: .week).yearString)"
    }
    
    var monthYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: self)
    }
    
    var monthYearString2: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    var monthString: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter.string(from: self).uppercased()
    }
    
    var yearString: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy")
        return formatter.string(from: self)
    }
    
    
    //MARK: - String ranges
    static func getMonthStringRange(from startDate: Date, to endDate: Date) -> [String] {
        var startDate = startDate.start(of: .month)
        let endDate = endDate.start(of: .month)
        var monthStrings = [String]()
        
        guard startDate <= endDate else {return monthStrings}
        
        repeat {
            monthStrings.append(startDate.monthYearString)
            startDate = startDate.next(.month)
        } while startDate <= endDate
        
        return monthStrings
    }
    
    static func getDayStringRange(from startDate: Date, to endDate: Date) -> [String] {
        var startDate = startDate.start(of: .day)
        let endDate = endDate.start(of: .day)
        var dayStrings = [String]()
        
        guard startDate <= endDate else {return dayStrings}
        
        repeat {
            dayStrings.append(startDate.dayMonthYearString)
            startDate = startDate.next(.day)
        } while startDate <= endDate
        
        return dayStrings
    }
    
    
    //MARK: - Initializer
    init?(day: Int, month: Int, year: Int) {
        let components = DateComponents(year: year, month: month, day: day)
        if let date = Date.calendar.date(from: components) {
            self = date
        }else {
            return nil
        }
    }
    
    init?(fromString dateString: String?) {
        guard let dateString = dateString else {return nil}
        
        let dateFormats = ["yyyy-MM-dd", "yyyy-MM", "yyyy", "MMMM yyyy"]
        let dateFormatter = DateFormatter()
        
        for dateFormat in dateFormats {
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: dateString) {
                self = date
                return
            }
        }
        
        return nil
    }
    
    
    //MARK: - Time manipulation
    enum DateComponent {
        case day, week, month, year
    }
    
    func previous(_ dateComponent: DateComponent) -> Date {
        var components = DateComponents()
        switch dateComponent {
        case .day:
            components.day = -1
        case .week:
            components.weekOfYear = -1
        case .month:
            components.month = -1
        case .year:
            components.year = -1
        }
        return Date.calendar.date(byAdding: components, to: self)!
    }
    
    func next(_ dateComponent: DateComponent) -> Date {
        var components = DateComponents()
        switch dateComponent {
        case .day:
            components.day = 1
        case .week:
            components.weekOfYear = 1
        case .month:
            components.month = 1
        case .year:
            components.year = 1
        }
        return Date.calendar.date(byAdding: components, to: self)!
    }

    func start(of dateComponent: DateComponent) -> Date {
        let components: DateComponents
        switch dateComponent {
        case .day:
            components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        case .week:
            components = Date.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        case .month:
            components = Date.calendar.dateComponents([.year, .month], from: self)
        case .year:
            components = Date.calendar.dateComponents([.year], from: self)
        }
        return Date.calendar.date(from: components)!
    }
    
    func end(of dateComponent: DateComponent) -> Date {
        let date = self.start(of: dateComponent).next(dateComponent)
        var components = DateComponents()
        components.second = -1
        return Date.calendar.date(byAdding: components, to: date)!
    }
    
    
    //MARK: - Date information
    var numberOfDaysInMonth: Int {
        let range = Date.calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    var dayNumber: Int {
        return Date.calendar.dateComponents([.day], from: self).day ?? 1
    }
    
    var monthNumber: Int {
        return Date.calendar.dateComponents([.month], from: self).month ?? 1
    }
    
    var yearNumber: Int {
        return Date.calendar.dateComponents([.year], from: self).year ?? 1
    }
}
