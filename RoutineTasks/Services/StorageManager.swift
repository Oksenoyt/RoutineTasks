//
//  StorageManager.swift
//  RoutineTasks
//
//  Created by Elenka on 29.09.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
        let date = DateManager()
        
        // MARK: - Core Data stack
        private let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Tasks")
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        
        private let viewContext: NSManagedObjectContext
        
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
        func saveContext() {
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
}
