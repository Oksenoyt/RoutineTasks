//
//  StorageManagerTests.swift
//  RoutineTasksTests
//
//  Created by Elenka on 02.06.2023.
//

import XCTest
@testable import RoutineTasks

final class StorageManagerTests: XCTestCase {
    let sut = StorageManager.shared
    var task: Task!
    
    
    //todo throws
    override func setUpWithError() throws {
        sut.createTask(name: "Swim", color: "#c49dcc") { result in
            task = result
        }
        super.setUp()
    }

    override func tearDownWithError() throws {
        sut.deleteTask(task)
        task = nil
        super.tearDown()
    }

    func testCreateTaskReturnTask() throws {
        sut.createTask(name: "Run", color: "#c49dcc") { result in
            XCTAssertTrue(result is Task, "\n!!!Error - CreateTask return is not correct data: \n expected result Task \n   actual result \(String(describing: type(of: result)))")
            sut.deleteTask(result)
        }
    }
    
    func testCreateTaskCheckTaskInCoreData() throws {
        sut.fetchTasks { result in
            switch result {
            case .success(let tasks):
                let task = tasks.contains { task in
                        task.title == "Swim"
                    }
                XCTAssertTrue(task, "\n!!!Error - CreateTask doesn't save task: \n expected result true \n   actual result \(task)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testUpdateTaskReturnTask() throws {
        sut.updateTask(task, newTitle: "Swim+", color: "#bbece6") { result in
            switch result {
            case .success(let task):
                XCTAssertTrue(task is Task, "\n!!!Error - CreateTask return is not correct data: \n expected result Task \n   actual result \(String(describing: type(of: task)))")
            case .failure(let error):
                print(error)
            }
        }
        sut.updateTask(task, newTitle: "Swim", color: "#c49dcc") {_ in }
    }
    
    func testUpdateTaskCheckSaveChangeName() throws {
        sut.updateTask(task, newTitle: "Swim2", color: "#c49dcc") {_ in }
        sut.fetchTasks { result in
            switch result {
            case .success(let tasks):
                let task = tasks.contains { task in
                        task.title == "Swim2"
                    }
                XCTAssertTrue(task, "\n!!!Error - CreateTask doesn't save task: \n expected result true \n   actual result \(task)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testUpdateTaskCheckSaveChangeColor() throws {
        sut.updateTask(task, newTitle: "Swim", color: "#b096e4") {_ in }
        sut.fetchTasks { result in
            switch result {
            case .success(let tasks):
                let task = tasks.contains { task in
                    task.color == "#b096e4"
                    }
                XCTAssertTrue(task, "\n!!!Error - CreateTask doesn't save task: \n expected result true \n   actual result \(task)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testCreateScheduleReturnTask() {
        sut.createSchedule(task, selectedDays: [2,4]) { result in
            XCTAssertTrue(result is Task, "\n!!!Error - CreateSchedule return is not correct data: \n expected result Task \n   actual result \(String(describing: type(of: task)))")
        }
    }
    
    func testCreateScheduleCheckResult() {
        sut.createSchedule(task, selectedDays: [2,4]) { result in
            let containsDay4 = (result.schedule?.allObjects.contains { object in
                    if let schedule = object as? Schedule {
                        return schedule.day == 4
                    }
                    return false
                }) ?? false

            XCTAssertTrue(containsDay4, "\n!!!Error - CreateSchedule doesn't save task: \n expected result true \n   actual result \(containsDay4)")
        }
        sut.removeSchedule(task: task) { _ in }
    }
    
    func testRemoveScheduleCheckRemoveSchedule() {
        sut.createSchedule(task, selectedDays: [2,4]) { _ in }
        sut.removeSchedule(task: task) { result in
            switch result {
            case .success(let task):
                let containsDay4 = (task.schedule?.allObjects.contains { object in
                        if let schedule = object as? Schedule {
                            return schedule.day == 4
                        }
                        return false
                    }) ?? false
                XCTAssertFalse(containsDay4, "\n!!!Error - CreateSchedule doesn't save task: \n expected result false \n   actual result \(containsDay4)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testCreateCompletionDayCheckSaveCompletionDay() {
        sut.createCompletionDay(task, date: "2023-05-31")
        sut.fetchTasks { result in
            switch result {
            case .success(let tasks):
                task = tasks.first
            case .failure(let error):
                print(error)
            }
        }
        let containsDate = (task.completionDay?.allObjects.contains { object in
                if let completionDay = object as? CompletionDay {
                    return completionDay.date == "2023-05-31"
                }
                return false
            }) ?? false
        XCTAssertTrue(containsDate, "\n!!!Error - CreateSchedule doesn't save task: \n expected result true \n   actual result \(containsDate)")
    }
    
    func testDeleteCompletionDay() {
        sut.createCompletionDay(task, date: "2023-05-30")
        sut.deleteCompletionDay(task, completionDay: "2023-05-30")
        sut.fetchTasks { result in
            switch result {
            case .success(let tasks):
                task = tasks.last
            case .failure(let error):
                print(error)
            }
        }
        let containsDate = (task.completionDay?.allObjects.contains { object in
                if let completionDay = object as? CompletionDay {
                    return completionDay.date == "2023-05-30"
                }
                return false
            }) ?? false
        XCTAssertFalse(containsDate, "\n!!!Error - CreateSchedule doesn't save task: \n expected result false \n   actual result \(containsDate)")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
