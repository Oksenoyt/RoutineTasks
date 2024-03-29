//
//  Task+CoreDataProperties.swift
//  RoutineTasks
//
//  Created by Elenka on 12.04.2023.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: String
    @NSManaged public var title: String
    @NSManaged public var order: Int16
    @NSManaged public var completionDay: NSSet?
    @NSManaged public var schedule: NSSet?

}

// MARK: Generated accessors for completionDay
extension Task {

    @objc(addCompletionDayObject:)
    @NSManaged public func addToCompletionDay(_ value: CompletionDay)

    @objc(removeCompletionDayObject:)
    @NSManaged public func removeFromCompletionDay(_ value: CompletionDay)

    @objc(addCompletionDay:)
    @NSManaged public func addToCompletionDay(_ values: NSSet)

    @objc(removeCompletionDay:)
    @NSManaged public func removeFromCompletionDay(_ values: NSSet)

}

// MARK: Generated accessors for schedule
extension Task {

    @objc(addScheduleObject:)
    @NSManaged public func addToSchedule(_ value: Schedule)

    @objc(removeScheduleObject:)
    @NSManaged public func removeFromSchedule(_ value: Schedule)

    @objc(addSchedule:)
    @NSManaged public func addToSchedule(_ values: NSSet)

    @objc(removeSchedule:)
    @NSManaged public func removeFromSchedule(_ values: NSSet)

}

extension Task : Identifiable {

}
