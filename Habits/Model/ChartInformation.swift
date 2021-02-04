//
//  ChartInformation.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 14.01.21.
//

import Foundation

class ChartInformation: ObservableObject {
    init(chartRange: Date.DateComponent, referenceDate: Date, cdHabit: CDHabit) {
        self.chartRange = chartRange
        self.referenceDate = referenceDate
        self.cdHabit = cdHabit
        update()
    }
    @Published var cdHabit: CDHabit {
        didSet {
            update()
        }
    }
    @Published var chartRange: Date.DateComponent {
        didSet {
            update()
        }
    }
    @Published var referenceDate: Date {
        didSet {
            update()
        }
    }
    @Published private(set) var chartLabels: [String] = []
    @Published private(set) var data: [Int] = []
    @Published private(set) var visibleYValues: [Int] = []
    @Published private(set) var numberOfXSections: Int = 0
    
    @Published private(set) var dateString: String = ""
    
    private func update() {
        updateChartLabels()
        updateData()
    }
    
    private func updateChartLabels() {
        switch chartRange {
        case .week:
            chartLabels = Date.shortWeekdayArray
            numberOfXSections = 7
            dateString = referenceDate.weekString
        case .month:
            chartLabels = ["1","6","11","16","21","26"]
            if referenceDate.numberOfDaysInMonth == 31 {
                chartLabels.append("31")
            }
            numberOfXSections = referenceDate.numberOfDaysInMonth
            dateString = referenceDate.monthYearString2
        case .year:
            chartLabels = Date.calendar.veryShortMonthSymbols
            numberOfXSections = 12
            dateString = referenceDate.yearString
        case .day:
            chartLabels = [referenceDate.dayMonthYearString]
            numberOfXSections = 1
            dateString = referenceDate.dayMonthYearString2
        }
    }
    
    private lazy var dataCache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        return cache
    }()
    
    private func cachedData(forKey keyString: String) -> [Int]? {
        if let result = dataCache.object(forKey: keyString as NSString) as? [Int] {
            return result
        }else {
            return nil
        }
    }
    
    private func updateData() {
        data = []
        switch chartRange {
        case .week:
            if let cachedData = cachedData(forKey: referenceDate.dayMonthYearString) {
                data = cachedData
            }else {
                let dayStrings = Date.getDayStringRange(from: referenceDate.start(of: .week), to: referenceDate.end(of: .week))
                for dayString in dayStrings {
                    data.append(cdHabit.numberFor(dayString: dayString))
                }
                dataCache.setObject(data as AnyObject, forKey: referenceDate.dayMonthYearString as NSString)
            }
        case .month:
            if let cachedData = cachedData(forKey: referenceDate.monthYearString) {
                data = cachedData
            }else {
                let dayStrings = Date.getDayStringRange(from: referenceDate.start(of: .month), to: referenceDate.end(of: .month))
                for dayString in dayStrings {
                    data.append(cdHabit.numberFor(dayString: dayString))
                }
                dataCache.setObject(data as AnyObject, forKey: referenceDate.monthYearString as NSString)
            }
        case .year:
            if let cachedData = cachedData(forKey: referenceDate.yearString) {
                data = cachedData
            }else {
                let monthStrings = Date.getMonthStringRange(from: referenceDate.start(of: .year), to: referenceDate.end(of: .year))
                for monthString in monthStrings {
                    data.append(cdHabit.numberFor(monthString: monthString))
                }
                dataCache.setObject(data as AnyObject, forKey: referenceDate.yearString as NSString)
            }
        case .day:
            data.append(cdHabit.numberFor(dayString: referenceDate.dayMonthYearString))
        }
        let maxValue = max((data.max() ?? 1), Int(cdHabit.goal))
        visibleYValues = generateVisibleYValues(for: maxValue)
    }
    
    private func generateVisibleYValues(for maxValue: Int, multiplier: Int = 1) -> [Int] {
        guard maxValue > 0 else {return [0,1]}
        
        var visibleValues = [Int]()
        
        if maxValue <= 10 * multiplier  {
            visibleValues = Array(stride(from: 0, to: maxValue + multiplier, by: multiplier))
        }else if maxValue <= 50 * multiplier {
            visibleValues = Array(stride(from: 0, to: maxValue + 5 * multiplier, by: 5 * multiplier))
        }else {
            visibleValues = generateVisibleYValues(for: maxValue, multiplier: multiplier * 10)
        }
        
        return visibleValues
    }
}
