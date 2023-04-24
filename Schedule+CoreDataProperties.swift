//
//  Schedule+CoreDataProperties.swift
//  RoutineTasks
//
//  Created by Elenka on 23.04.2023.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var day: Int64
    @NSManaged public var task: Task?

}

extension Schedule : Identifiable {

}
