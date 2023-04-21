//
//  NewTaskViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

enum DayWeek: String {
    case mo = "Monday"
    case tu = "Tuesday"
    case we = "Wednesday"
    case th = "Thursday"
    case fr = "Friday"
    case sa = "Saturday"
    case su = "Sunday"
}

protocol NewTaskViewModelProtocol {
    var taskName: String { get }
    var createButton: String { get }
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
    private var selectedDays = [true, true, true, true, true, true, true]
    private var activeDays: [String] = []
    private var task: Task?
    private var tasks: [Task] = []
    
    
    func addTask(name: String, color: String) {
        setActiveDay()
        guard let currentTask = task else {
            storageManager.createTask(name: name, color: color) { task in
                storageManager.createSchedule(task, selectedDays: activeDays) { task in
                    observersViewModel.addData(data: task)
                }
            }
            return
        }
        storageManager.updateTask(currentTask, newTitle: name, color: color) { result in
            switch result {
            case .success(let newTask):
                
                storageManager.createSchedule(newTask, selectedDays: activeDays) { task in
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
    
    private func setActiveDay() {
        var dayNumber = 0
        for day in selectedDays {
            if day {
                switch dayNumber {
                case 0: activeDays.append(DayWeek.mo.rawValue)
                case 1: activeDays.append(DayWeek.tu.rawValue)
                case 2: activeDays.append(DayWeek.we.rawValue)
                case 3: activeDays.append(DayWeek.th.rawValue)
                case 4: activeDays.append(DayWeek.fr.rawValue)
                case 5: activeDays.append(DayWeek.sa.rawValue)
                default: activeDays.append(DayWeek.su.rawValue)
                }
            }
            dayNumber += 1
        }
    }
    
    
}
