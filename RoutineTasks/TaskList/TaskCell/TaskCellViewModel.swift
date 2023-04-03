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
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    private let task: Task
    
    var taskName: String {
        //убрать опционал
        task.title ?? "nan"
    }
    
    required init(task: Task) {
        self.task = task
    }
    
     
}
