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
    func addTask(name: String, color: String)
    func selectedDaysDidChange(day: Int) -> Bool
}

class NewTaskViewModel: NewTaskViewModelProtocol {
    private let observersViewModel = ObserversViewModel.shared
    private var selectedDays = [true, true, true, true, true, true, true]
    private var activeDays: [String] = []
    
    func addTask(name: String, color: String) {
        setActiveDay()
        print(activeDays)
        StorageManager.shared.createTask(name: name, color: color, activeDays: activeDays) { task in
            StorageManager.shared.createSchedule(task, selectedDays: activeDays) { task in
                observersViewModel.addData(data: task)
            }
        }
    }

    func selectedDaysDidChange(day: Int) -> Bool {
        selectedDays[day].toggle()
        return selectedDays[day]
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
