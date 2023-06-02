//
//  DateManagerTests.swift
//  DateManagerTests
//
//  Created by Elenka on 01.06.2023.
//

import XCTest
@testable import RoutineTasks

final class DateManagerTests: XCTestCase {
    let calendar = Calendar.current
    var weekday: Int!
    var hour: Int!
    var minute: Int!
    var sut: DateManager!
    var dateComponents : DateComponents!
    

    override func setUp() {
        super.setUp()
        sut = DateManager()
        dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        dateComponents.weekday = 1
        weekday = 1
        hour = 10
        minute = 30
    }

    override func tearDown() {
        sut = nil
        dateComponents = nil
        weekday = nil
        hour = nil
        minute = nil
        super.tearDown()
    }

    func testGetTimeReturnTimeInArreyInt() {
        dateComponents.year = 2023
        dateComponents.month = 5
        dateComponents.day = 26
        dateComponents.second = 0

        guard let date = calendar.date(from: dateComponents) else {
            return
        }
        let time = sut.getTime(currentDate: date)
        XCTAssert(time == [10, 30], "\n!!!Error - Time received is not correct: expected result \([10, 30]), actual result \(time)")
        
    }
    
    func testGetNotificationDateReturnDayAndTimeNotification() {
        let date = Date()
        guard let expectedResult = calendar.nextDate(
            after: date,
            matching: dateComponents,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        ) else { return }
        let notificationDate = sut.getNotificationDate(
            weekday: weekday,
            hour: hour,
            minute: minute
        )
        XCTAssert(notificationDate == expectedResult, "\n!!!Error - Notification date is not correct: expected result \(expectedResult), actual result \(notificationDate)")
    }

    func testGetDateComponentsReturnHourMinuteWeekday() {
        let result = sut.getDateComponents(
            weekday: weekday,
            hour: hour,
            minute: minute
        )
        XCTAssert(result == dateComponents, "\n!!!Error - Date components is not correct: expected result \(String(describing: dateComponents)), actual result \(result)")
    }

    func testGetDateStringReturnYearMonthDay() {
        let result = sut.getDateString(
            dayBefore: weekday,
            format: DateManager.formatDate.yyyyMMdd
        )
        XCTAssert(result == "2023-05-31", "\n!!!Error - String date is not correct: expected result 2023-05-31, actual result \(result)")
    }
    
    func testGetDateStringReturnDayWeekday() {
        let result = sut.getDateString(
            dayBefore: weekday,
            format: DateManager.formatDate.d_EE
        )
        XCTAssert(result == "31\nСр", "\n!!!Error - String date is not correct: expected result 31 Ср, actual result \(result)")
    }
    
    func testGetDataIntReturnWeekday() {
        let result = sut.getDateInt(dayBefore: -2)
        XCTAssert(result == 6, "\n!!!Error - String date is not correct: \n expected result 6 \n   actual result \(result)")
    }
}
