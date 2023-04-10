//
//  CompletionDay+CoreDataProperties.swift
//  RoutineTasks
//
//  Created by Elenka on 09.04.2023.
//
//

import Foundation
import CoreData


extension CompletionDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompletionDay> {
        return NSFetchRequest<CompletionDay>(entityName: "CompletionDay")
    }

    @NSManaged public var date: String?
    @NSManaged public var task: Task?

}

extension CompletionDay : Identifiable {

}
