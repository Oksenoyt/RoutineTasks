//
//  TasksObserversViewModel.swift
//  RoutineTasks
//
//  Created by Elenka on 02.04.2023.
//

import Foundation

protocol DataObserver: AnyObject {
    func didAddData(task: Task)
    func didDeleteData(task: Task)
    func didChangeData(task: Task)
}

class ObserversViewModel {
    static let shared = ObserversViewModel()
    private var observers = [DataObserver]()
    
    private init() { }
    
    func addObserver(observer: DataObserver) {
        observers.append(observer)
    }

    func removeObserver(observer: DataObserver) {
        observers.removeAll { $0 === observer }
    }

    func addData(data: Task) {
        for observer in observers {
            observer.didAddData(task: data)
        }
    }
    
    func changeData(data: Task) {
        for observer in observers {
            observer.didChangeData(task: data)
        }
    }
    
    func deleteData(data: Task) {
        for observer in observers {
            observer.didDeleteData(task: data)
        }
    }
}
