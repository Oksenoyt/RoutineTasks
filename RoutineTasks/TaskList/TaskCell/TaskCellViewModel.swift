//
//  TaskCellViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var taskName: String { get }
    init(task: Task)
    
    func getActiveDay(dayBefore: Int) -> Bool
    func checkDayIsDone(dayBefore: Int) -> Bool
    func setDayStatus(dayBefore: Int)
    func getColor() -> String
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    var taskName: String {
        task.title
    }
    private let observersViewModel = ObserversViewModel.shared
    private let task: Task
    private let date = DateManager()
    private var completionDay: [String] = []
    
    required init(task: Task) {
        self.task = task
    }
    
    func getActiveDay(dayBefore: Int) -> Bool {
        let day = date.getDateInt(dayBefore: dayBefore)
        var schedule: [Int] = []
        if let scheduleTemp = task.schedule?.allObjects as? [Schedule] {
            let scheduleTemp = scheduleTemp.map { ($0.day ) }
            schedule = scheduleTemp.map { Int($0) }
        }
        if schedule.contains(day) {
            return true
        }
        return false
    }
    
    func setDayStatus(dayBefore: Int) {
        let day = date.getDateString(dayBefore: dayBefore, format: .yyyyMMdd)
        completionDay = getCompletionDay()
        if completionDay.contains(day) {
            StorageManager.shared.deleteCompletionDay(task, completionDay: day)
        } else {
            StorageManager.shared.createCompletionDay(task, date: day)
        }
    }
    
    func checkDayIsDone(dayBefore: Int) -> Bool {
        let day = date.getDateString(dayBefore: dayBefore, format: .yyyyMMdd)
        completionDay = getCompletionDay()
        if completionDay.contains(day) {
            return true
        }
        return false
    }
    
    func getColor() -> String {
        task.color
    }
    
    private func getCompletionDay() -> [String] {
        var completionDay: [String] = []
        if let completionDayTemp = task.completionDay?.allObjects as? [CompletionDay] {
            completionDay = completionDayTemp.map { ($0.date ?? "") }
        }
        return completionDay
    }
}
