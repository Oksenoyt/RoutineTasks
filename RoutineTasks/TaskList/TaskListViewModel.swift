//
//  TaskListViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol TaskListViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    
    func fetchTasks(completion: @escaping() -> Void)
    func deleteTask(at indexPath: IndexPath)
    
    func numberOfRows() -> Int
    func getTaskCellViewModel(at indexPath: IndexPath) -> TaskCellViewModelProtocol
    
}

class TaskListViewModel: TaskListViewModelProtocol {
    
    private let observersViewModel = ObserversViewModel.shared
    private let storageManager = StorageManager.shared

    private var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.dataDidChange()
            }
        }
    }
    
    
    weak var delegate: ViewModelDelegate?
    
    init(observersViewModel: ObserversViewModel) {
        observersViewModel.addObserver(observer: self)
    }
    
    func fetchTasks(completion: @escaping () -> Void) {
        storageManager.fetchTasks { result in
            switch result {
            case .success(let taskList):
                tasks = taskList
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        storageManager.deleteTask(task)
        observersViewModel.deleteData(data: task)
    }
    
    func numberOfRows() -> Int {
        tasks.count
    }
    
    func getTaskCellViewModel(at indexPath: IndexPath) -> TaskCellViewModelProtocol {
        TaskCellViewModel(task: tasks[indexPath.row])
    }
    
    func getTask(at indexPath: IndexPath) -> Task {
        tasks[indexPath.row]
    }
    
}

extension TaskListViewModel: DataObserver {
    func didAddData(task: Task) {
        tasks.append(task)
    }
    
    func didDeleteData(task: Task) {
        if let index = tasks.firstIndex(of: task) {
            tasks.remove(at: index)
        }
    }
}


