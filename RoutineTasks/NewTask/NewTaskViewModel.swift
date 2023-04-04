//
//  NewTaskViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol NewTaskViewModelProtocol {
    func addTask(name: String, color: String)
}

class NewTaskViewModel: NewTaskViewModelProtocol {
    private let observersViewModel = ObserversViewModel.shared
    
    func addTask(name: String, color: String) {
        StorageManager.shared.createTask(name: name, color: color) { task in
            observersViewModel.addData(data: task)
        }
    }
}
