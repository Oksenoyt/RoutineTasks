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
//        task.id = Int16(id)
//        task = createCD(task, date: date, dayWeek: dayWeek, isDone: false)
//        task = createSchedule(task, selectedDays: selectedDays)
//        task.user = user
        
        completion(task)
        saveContext()
    }
    
    func fetchTasks(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
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
    private func createSchedule(_ taskTemp: Task, selectedDays: [Bool]) -> Task {
            let task = taskTemp
            let schedule = Schedule(context: viewContext)
            schedule.task = task //переделать
//            schedule.monday = selectedDays[0]
//            schedule.tuesday = selectedDays[1]
//            schedule.wednesday = selectedDays[2]
//            schedule.thursday = selectedDays[3]
//            schedule.friday = selectedDays[4]
//            schedule.saturday = selectedDays[5]
//            schedule.sunday = selectedDays[6]
            
            return task
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
