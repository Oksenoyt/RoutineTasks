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
    func checkUniqueName(nameNewTask: String) -> Bool
    func addTask(name: String, color: String)
    func selectedDaysDidChange(day: Int) -> Bool
    func getColor(_ sender: Int) -> String
    
    init(data: Task)
    init()
}

class NewTaskViewModel: NewTaskViewModelProtocol {
    required init() {}
    
    required init(data: Task) {
        task = data
        print(task)
    }
    
    private let observersViewModel = ObserversViewModel.shared
    private let storageManager = StorageManager.shared
    private var selectedDays = [true, true, true, true, true, true, true]
    private var activeDays: [String] = []
    private var task: Task?
    
    func addTask(name: String, color: String) {
        setActiveDay()
        storageManager.createTask(name: name, color: color, activeDays: activeDays) { task in
            storageManager.createSchedule(task, selectedDays: activeDays) { task in
                observersViewModel.addData(data: task)
            }
        }
    }
    
    func selectedDaysDidChange(day: Int) -> Bool {
        selectedDays[day].toggle()
        return selectedDays[day]
    }
    
    func getColor(_ sender: Int) -> String {
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
    
    func checkUniqueName(nameNewTask: String) -> Bool {
        var tasks: [Task] = []

        print(tasks.count)
        for task in tasks {
            if task.title == nameNewTask {
                print("name doeasn't unique")
                return false
            }
        }
        print("unique")
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
