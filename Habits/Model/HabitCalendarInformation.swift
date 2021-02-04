//
//  HabitCalendarInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 14.01.21.
//

import Foundation

class HabitCalendarInformation: ObservableObject {
    init(cdHabit: CDHabit, date: Date) {
        self.cdHabit = cdHabit
        self.goal = Int(cdHabit.goal)
        self.calendarInformation = CalendarInformation(date: date,
                                                       buttonArrowActive: false)
    }
    
    @Published var calendarInformation: CalendarInformation!
    
    private(set) var cdHabit: CDHabit
    private(set) var goal: Int
    
    private lazy var dataCache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        return cache
    }()
    
    func data(forDate date: Date) -> [Int] {
        let keyString: NSString = date.monthYearString as NSString
        
        if let result = dataCache.object(forKey: keyString) as? [Int] {
            return result
        }
        
        var data = [Int]()
        let dayStrings = Date.getDayStringRange(from: date.start(of: .month), to: date.end(of: .month))
        for dayString in dayStrings {
            data.append(cdHabit.numberFor(dayString: dayString))
        }
        
        dataCache.setObject(data as AnyObject, forKey: keyString)
        
        return data
    }
}
