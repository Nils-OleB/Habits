//
//  CDHabitEntry+CoreDataProperties.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 27.10.20.
//
//

import Foundation
import CoreData


extension CDHabitEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHabitEntry> {
        return NSFetchRequest<CDHabitEntry>(entityName: "CDHabitEntry")
    }

    @NSManaged public var dayString: String?
    @NSManaged public var habit: CDHabit?
    @NSManaged public var creationDate: Date?

}
