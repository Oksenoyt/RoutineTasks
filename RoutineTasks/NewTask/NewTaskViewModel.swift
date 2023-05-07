//
//  NewTaskViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol NewTaskViewModelProtocol {
    var taskName: String { get }
    var createButton: String { get }
    
    //gthtltkfnm
    init(data: Task, dataList: [Task])
    init(data: [Task])

    func getSchedule(dayWeek: Int) -> Bool
    func createNotifications(title: String, time: Date, toggle: Bool)
    func checkNameTFFilled(title: String?, placeholder: String? ) -> String?
    func checkUniqueName(nameNewTask: String, isChange: String?) -> Bool
    func addTask(name: String, color: String)
    func selectedDaysDidChange(day: Int) -> Bool
    func chooseColor(_ sender: Int) -> String
    func getColorButton() -> Int
    
}

class NewTaskViewModel: NewTaskViewModelProtocol {
    required init(data: [Task]) {
        tasks = data
    }
    
    required init(data: Task, dataList: [Task]) {
        task = data
        tasks = dataList
    }
    
    var taskName: String {
        return task?.title ?? ""
    }
    
    var createButton: String {
        let text = task != nil ? "Update" : "Сreate"
        return text
    }
    
    private let observersViewModel = ObserversViewModel.shared
    private let storageManager = StorageManager.shared
    private let date = DateManager()
    private let notifications = LocalNotification()
    
    private var schedule = [0, 1, 2, 3, 4, 5, 6]
    private var task: Task?
    private var tasks: [Task] = []
    
    func addTask(name: String, color: String) {
        guard let currentTask = task else {
            storageManager.createTask(name: name, color: color) { task in
                storageManager.createSchedule(task, selectedDays: schedule) { task in
                    observersViewModel.addData(data: task)
                }
            }
            return
        }
        storageManager.updateTask(currentTask, newTitle: name, color: color) { result in
            switch result {
            case .success(let newTask):
                replaseSchedule(task: newTask)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkNameTFFilled(title: String?, placeholder: String? ) -> String? {
        var name: String? = nil
        guard let taskName = title, !taskName.isEmpty else {
            guard let taskName = placeholder, !taskName.isEmpty else {
                return name
            }
            name = taskName
            return name
        }
        name = taskName
        return name
    }
    
    func selectedDaysDidChange(day: Int) -> Bool {
        if schedule.contains(day) {
            guard let index = schedule.firstIndex(of: day) else { return false }
            schedule.remove(at: index)
            return false
        } else {
            schedule.append(day)
            return true
        }
    }
    
    func chooseColor(_ sender: Int) -> String {
        var color = "#c49dcc"
        switch sender {
        case 0:
            color = "#c49dcc"
        case 1:
            color = "#bbece6"
        case 2:
            color = "#b096e4"
        case 3:
            color = "#a8eabc"
        default:
            color = "#edc6e0"
        }
        return color
    }
    
    func getColorButton() -> Int {
        let sender: Int
        switch task?.color {
        case "#edc6e0":
            sender = 4
        case "#bbece6":
            sender = 1
        case "#b096e4":
            sender = 2
        case "#a8eabc":
            sender = 3
        default:
            sender = 0
        }
        return sender
    }
    
    func getSchedule(dayWeek: Int) -> Bool {
        guard task != nil else { return true }
        if let scheduleTemp = task?.schedule?.allObjects as? [Schedule] {
            let scheduleArray = scheduleTemp.map { ($0.day ) }
            schedule = scheduleArray.map { Int($0) }
        }
        guard schedule.contains(dayWeek) else { return false }
        return true
    }
    
    func checkUniqueName(nameNewTask: String, isChange: String?) -> Bool {
        guard isChange != "" else { return true }
        for task in tasks {
            if task.title == nameNewTask {
                return false
            }
        }
        return true
    }
    
    func createNotifications(title: String, time: Date, toggle: Bool) {
        guard toggle else { return }
        let time = date.getTime(currentDate: time)
        for day in getWeekday() {
            let dateComponents = date.getDateComponents(weekday: day, hour: time[0], minute: time[1])
            notifications.addNotification(title: title, id: "\(title) day \(day)", dataComponents: dateComponents)
        }
        
    }

    private func getWeekday() -> [Int] {
        var weekday: [Int] = []
        for day in schedule {
            if day < 6 {
                weekday.append(day + 2)
            } else {
                weekday.append(1)
            }
        }
        return weekday
    }
    
    private func replaseSchedule(task: Task) {
        storageManager.removeSchedule(task: task) { result in
            switch result {
            case .success(let taskWithoutSchedule):
                storageManager.createSchedule(taskWithoutSchedule, selectedDays: schedule) { task in
                    observersViewModel.changeData(data: task)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
