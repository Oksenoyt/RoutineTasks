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
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    private let task: Task
    private let date = DateManager()
    
    var taskName: String {
        //убрать опционал
        task.title ?? "nan"
        
    }
    
    required init(task: Task) {
        self.task = task
    }
    
    func getActiveDay(dayBefore: Int) -> Bool {
        let day = date.getDateString(dayBefore: dayBefore, format: .EE)
        var schedule: [String] = []
        
        if let scheduleTemp: [Schedule] = task.schedule?.allObjects as? [Schedule] {
            schedule = scheduleTemp.map { ($0.day ?? "") }
        }
        if schedule.contains(day) {
            return true
        }
        return false
    }
}
