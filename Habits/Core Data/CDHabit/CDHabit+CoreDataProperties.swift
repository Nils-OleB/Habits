//
//  CDHabit+CoreDataProperties.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 20.10.20.
//
//

import CoreData

extension CDHabit: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHabit> {
        return NSFetchRequest<CDHabit>(entityName: "CDHabit")
    }

    @NSManaged public var titel: String?
    @NSManaged public var symbolName: String?
    @NSManaged public var colorName: String?
    @NSManaged public var goal: Int64
    @NSManaged public var goalPeriod: String?
    
    @NSManaged public var position: Int64
    @NSManaged public var internal_id: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var entrys: NSSet?
    
    var symbolID: SymbolHelper.SymbolID {
        set {
            symbolName = newValue.rawValue
        }
        get {
            SymbolHelper.SymbolID(rawValue: symbolName ?? "") ?? .symbol_1
        }
    }
    
    var colorID: ColorHelper.ColorID {
        set {
            colorName = newValue.rawValue
        }
        get {
            ColorHelper.ColorID(rawValue: colorName ?? "") ?? .pickerColor_1
        }
    }
    
    var goalPeriodID: GoalPeriodHelper.GoalPeriodID {
        set {
            goalPeriod = newValue.rawValue
        }
        get {
            GoalPeriodHelper.GoalPeriodID(rawValue: goalPeriod ?? "") ?? .daily
        }
    }
}

// MARK: Generated accessors for entrys
extension CDHabit {

    @objc(addEntrysObject:)
    @NSManaged public func addToEntrys(_ value: CDHabitEntry)
    
    @objc(removeEntrysObject:)
    @NSManaged public func removeFromEntrys(_ value: CDHabitEntry)

    @objc(addEntrys:)
    @NSManaged public func addToEntrys(_ values: NSSet)

    @objc(removeEntrys:)
    @NSManaged public func removeFromEntrys(_ values: NSSet)

}

extension CDHabit {
    func numberFor(dayString: String) -> Int{
        guard let entrys = entrys
        else {return 0}
        
        let dayEntrys = entrys.filter({ (habitEntry) -> Bool in
            return (habitEntry as! CDHabitEntry).dayString == dayString
        })
        
        return dayEntrys.count
    }
    
    func numberFor(monthString: String) -> Int {
        guard let entrys = entrys
        else {return 0}
        
        let monthEntrys = entrys.filter({ (habitEntry) -> Bool in
            var entryMonthString = (habitEntry as! CDHabitEntry).dayString
            entryMonthString?.removeLast()
            entryMonthString?.removeLast()
            entryMonthString?.removeLast()
            return entryMonthString == monthString
        })
        
        return monthEntrys.count
    }
    
//    func addEntry(to context: NSManagedObjectContext, for dayString: String) {
//        let cdHabitEntry = CDHabitEntry(context: context)
//        cdHabitEntry.habit = self
//        cdHabitEntry.dayString = dayString
//        cdHabitEntry.creationDate = Date()
//        
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
//    func deleteEntry(in context: NSManagedObjectContext, for dayString: String) {
//        guard let entrys = entrys else {return}
//
//        let dayEntrys = entrys.filter({ (habitEntry) -> Bool in
//            return (habitEntry as! CDHabitEntry).dayString == dayString
//        })
//
//        deleteEntry(dayEntrys.last as? CDHabitEntry, in: context)
//    }
//
//    func deleteEntry(_ cdHabitEntry: CDHabitEntry?, in context: NSManagedObjectContext) {
//        guard let cdHabitEntry = cdHabitEntry else {return}
//        context.delete(cdHabitEntry)
//
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
//    func changeValues(in context: NSManagedObjectContext,
//                      titel: String?,
//                      symbolID: SymbolHelper.SymbolID,
//                      colorID: ColorHelper.ColorID,
//                      goal: Int64,
//                      goalPeriodID: GoalPeriodHelper.GoalPeriodID) {
//        context.performAndWait {
//            self.titel = titel
//            self.symbolID = symbolID
//            self.colorID = colorID
//            self.goal = goal
//            self.goalPeriodID = goalPeriodID
//
//            try? context.save()
//        }
//    }
    
    static func getAllCDHabits() -> NSFetchRequest<CDHabit> {
        let request: NSFetchRequest<CDHabit> = CDHabit.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    static func getAllCDHabits(in context: NSManagedObjectContext) -> [CDHabit] {
        do {
            let result = try context.fetch(getAllCDHabits())
            return result
        }catch {
            return []
        }
    }
    
//    static func addHabit(to context: NSManagedObjectContext,
//                         titel: String?,
//                         symbolID: SymbolHelper.SymbolID,
//                         colorID: ColorHelper.ColorID,
//                         goal: Int64,
//                         goalPeriodID: GoalPeriodHelper.GoalPeriodID) {
//        let cdHabit = CDHabit(context: context)
//        cdHabit.titel = titel
//        cdHabit.symbolID = symbolID
//        cdHabit.colorID = colorID
//        cdHabit.goal = goal
//        cdHabit.goalPeriodID = goalPeriodID
//
//        cdHabit.position = Int64(getAllCDHabits(in: context).count)
//        cdHabit.internal_id = UUID().uuidString
//        cdHabit.creationDate = Date()
//
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
//    static func deleteHabit(_ cdHabit: CDHabit?, in context: NSManagedObjectContext) {
//        guard let cdHabit = cdHabit else {return}
//        context.delete(cdHabit)
//
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}
