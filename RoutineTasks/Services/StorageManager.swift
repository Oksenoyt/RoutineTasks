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
    
    // MARK: - CRUD TASK
    func createTask(name: String, color: String, activeDays: [String], completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = name
        task.color = color
        completion(task)
        
        saveContext()
    }
    
    func fetchTasks(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    //    func updateTask(_ taskList: [Task], sourceIndexPath: Int, destinationIndexPath: Int, completion: ([Task]) -> Void) {
    //        let taskList: [Task] = taskList
    //        taskList[sourceIndexPath].id = Int16(destinationIndexPath)
    //        taskList[destinationIndexPath].id = Int16(sourceIndexPath)
    //        completion(taskList)
    //        saveContext()
    //    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    
    // MARK: - CRUD SCHEDULE
    func createSchedule(_ task: Task, selectedDays: [String], completion: (Task) -> Void) {
        for day in selectedDays {
            let schedule = Schedule(context: viewContext)
            schedule.day = day
            task.addToSchedule(schedule)
            saveContext()
        }
        completion(task)
    }
    
    
    // MARK: - CRUD CompletionDay
    func createCompletionDay(_ task: Task, date: String, completion: (Task) -> Void) {
        let completionDay = CompletionDay(context: viewContext)
        completionDay.task = task
        completionDay.date = date
        
        completion(task)
        saveContext()
    }
    
    func deleteCompletionDay(_ task: Task, completionDay: String, completion: (Task) -> Void) {
        let fetchRequest = CompletionDay.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date = %@)", completionDay)
        do {
            let completionDay = try viewContext.fetch(fetchRequest)
            if let date = completionDay.first {
                viewContext.delete(date)
            }
        } catch let error {
            print(error)
        }
        completion(task)
        saveContext()
    }
    
    
    
    
//    func fetchSchedule(task: Task, completion: (Result<[Schedule], Error>) -> Void) {
//        let fetchRequest = Schedule.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "(task = %@)", task)
//        do {
//            let schedule = try viewContext.fetch(fetchRequest)
//            completion(.success(schedule))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
    
    
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
