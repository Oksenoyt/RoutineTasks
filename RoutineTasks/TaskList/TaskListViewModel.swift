//
//  TaskListViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol TaskListViewModelProtocol {
    func fetchTasks(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getTaskCellViewModel(at indexPath: IndexPath) -> TaskCellViewModelProtocol
}

class TaskListViewModel: TaskListViewModelProtocol {
    private var tasks: [Task] = []

    init(observersViewModel: ObserversViewModel) {
        observersViewModel.addObserver(observer: self)
       }
    
    func fetchTasks(completion: @escaping () -> Void) {
        StorageManager.shared.fetchTasks { result in
            switch result {
            case .success(let taskList):
                tasks = taskList
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        tasks.count
    }
    
    func getTaskCellViewModel(at indexPath: IndexPath) -> TaskCellViewModelProtocol {
        TaskCellViewModel(task: tasks[indexPath.row])
    }
}


extension TaskListViewModel: DataObserver {
    func didAddData(task: Task) {
        tasks.append(task)
    }

}


