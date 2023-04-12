//
//  TaskListViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol TaskListViewModelProtocol {
    var delegate: TaskListViewModelDelegate? { get set }
    
    func fetchTasks(completion: @escaping() -> Void)
    func deleteTask(at indexPath: IndexPath)
    
    func numberOfRows() -> Int
    func getTaskCellViewModel(at indexPath: IndexPath) -> TaskCellViewModelProtocol
    
    func getCalendar(days: Int) -> [String]
}

class TaskListViewModel: TaskListViewModelProtocol {
    weak var delegate: TaskListViewModelDelegate?
    private let observersViewModel = ObserversViewModel.shared
    private let storageManager = StorageManager.shared
    private let date = DateManager()
    private var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.dataDidChange()
            }
        }
    }
    
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
    
    //проверить - - в передаче
    func getCalendar(days: Int) -> [String] {
        var dayLabels: [String] = []
        for day in -2..<days-2 {
            let label = date.getDateString(dayBefore: -day, format: .d_EE)
            dayLabels.append(label)
        }
        return dayLabels
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


