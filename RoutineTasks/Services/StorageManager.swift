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
    func createTask(name: String, color: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = name
        task.color = color
        task.order = getOrder()
        completion(task)
        
        saveContext()
    }
    
    func fetchTasks(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updateTask(_ task: Task, newTitle: String, color: String, completion: (Result<Task, Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            fetchRequest.predicate = NSPredicate(
                format: "title == %@", task.title
            )
            let objects = try viewContext.fetch(fetchRequest)
            guard let task = objects.first else {
                //написать ошибку
                return }
            task.title = newTitle
            task.color = color
            saveContext()
            completion(.success(task))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updateOrderOfTask(_ task: Task, order: Int16) {
        let fetchRequest = Task.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(
                format: "title == %@", task.title
            )
            let objects = try viewContext.fetch(fetchRequest)
            guard let cuttrentTask = objects.first else {
               // todo
                return }
            cuttrentTask.order = order
            saveContext()
            updateOrderOfTask(order: order, task: task)
        } catch let error {
            print(error)
        }
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    
    // MARK: - CRUD SCHEDULE
    func createSchedule(_ task: Task, selectedDays: [Int], completion: (Task) -> Void) {
        for day in selectedDays {
            let schedule = Schedule(context: viewContext)
            schedule.day = Int64(day)
            task.addToSchedule(schedule)
            saveContext()
        }
        completion(task)
    }
    
    func removeSchedule(task: Task, completion: (Result<Task, Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            fetchRequest.predicate = NSPredicate(
                format: "title == %@", task.title
            )
            let objects = try viewContext.fetch(fetchRequest)
            guard let task = objects.first else {
                //написать ошибку
                return }
            guard let schedule = task.schedule else { return }
            task.removeFromSchedule(schedule)
            saveContext()
            completion(.success(task))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
    // MARK: - CRUD CompletionDay
    func createCompletionDay(_ task: Task, date: String) {
        let completionDay = CompletionDay(context: viewContext)
        completionDay.task = task
        completionDay.date = date
        
        saveContext()
    }
    
    func deleteCompletionDay(_ task: Task, completionDay: String) {
        let fetchRequest = CompletionDay.fetchRequest()
        let datePredicate = NSPredicate(format: "(date = %@)", completionDay)
        let taskPredicate = NSPredicate(format: "(task = %@)", task)
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [datePredicate, taskPredicate]
        )
        do {
            let completionDay = try viewContext.fetch(fetchRequest)
            if let date = completionDay.first {
                viewContext.delete(date)
            }
        } catch let error {
            print(error)
        }
        saveContext()
    }
    
    private func getOrder() -> Int16 {
        var order: Int16 = 0
        fetchTasks { result in
            switch result {
            case .success(let tasks):
                order = Int16(tasks.count)
            case .failure(let error):
                print(error)
            }
        }
        return order
    }
    
    private func updateOrderOfTask(order: Int16, task: Task) {
        let fetchRequest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            for currentTask in tasks {
                if currentTask != task {
                    if currentTask.order >= order {
                        currentTask.order += Int16(1)
                        saveContext()
                    }
                }
            }
        } catch let error {
            print(error)
        }
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
