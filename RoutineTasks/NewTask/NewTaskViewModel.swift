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
    
    func getSchedule(dayWeek: Int) -> Bool
    func checkNameTFFilled(title: String?, placeholder: String? ) -> String?
    func checkUniqueName(nameNewTask: String, isChange: String?) -> Bool
    func addTask(name: String, color: String)
    func selectedDaysDidChange(day: Int) -> Bool
    func chooseColor(_ sender: Int) -> String
    func getColorButton() -> Int
    
    //gthtltkfnm
    init(data: Task, dataList: [Task])
    init(data: [Task])
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
    private let daysWeek = [0, 1, 2, 3, 4, 5, 6]
    
    private var selectedDays = [true, true, true, true, true, true, true]
    private var schedule: [Int] = []
    private var task: Task?
    private var tasks: [Task] = []
    
    
    func addTask(name: String, color: String) {
        filSchedule()
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
                
                storageManager.createSchedule(newTask, selectedDays: schedule) { task in
                    observersViewModel.changeData(data: task)
                }
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
        selectedDays[day].toggle()
        return selectedDays[day]
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
    
    func checkUniqueName(nameNewTask: String, isChange: String?) -> Bool {
        if isChange != "" {
            for task in tasks {
                if task.title == nameNewTask {
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func getSchedule(dayWeek: Int) -> Bool {
        guard task != nil else { return true }
        
        if let scheduleTemp = task?.schedule?.allObjects as? [Schedule] {
            let scheduleTemp = scheduleTemp.map { ($0.day ) }
            schedule = scheduleTemp.map { Int($0) }
        }

        if schedule.contains(dayWeek) {
            return true
        }
        return false
    }
    
    private func filSchedule() {
        let activeDaysWeek = Array(zip(selectedDays, daysWeek))
        let activeDaysWeekFiltered = activeDaysWeek.filter { $0.0 == true }
        schedule = activeDaysWeekFiltered.map { $0.1 }
    }
}
