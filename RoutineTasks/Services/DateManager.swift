//
//  DateManager.swift
//  RoutineTasks
//
//  Created by Elenka on 02.10.2022.
//

import Foundation

class DateManager {
    private let date = Date()
    private let calendar = Calendar.current

    //e,hfnm
    var currentDate: Date {
        date.dayBefore(value: 0)
    }
    
    enum formatDate {
        case yyyyMMdd
        case d_EE
    }

    
    func getTime(currentDate: Date) -> [Int] {
        var timeComponent: [Int] = []
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        timeComponent.append(hour)
        timeComponent.append(minute)
        return timeComponent
    }
    
    func getNotificationDate(weekday: Int, hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.weekday = weekday
        guard let nextNotification = calendar.nextDate(after: date, matching: dateComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) else { return date }
        return nextNotification
    }
    
    func getDateComponents(weekday: Int, hour: Int, minute: Int) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.weekday = weekday
        return dateComponents
    }
    
    func getDateString(dayBefore: Int, format: formatDate ) -> String {
        let dateFormatter = DateFormatter()
        let date = date.dayBefore(value: -dayBefore)
        var dataFormatted = ""
        switch format {
        case .yyyyMMdd:
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dataFormatted = dateFormatter.string(from: date)
        case .d_EE:
            dateFormatter.setLocalizedDateFormatFromTemplate("d")
            let dayNumber = dateFormatter.string(from: date)
            dateFormatter.setLocalizedDateFormatFromTemplate("EE")
            let dayWeek = dateFormatter.string(from: date)
            dataFormatted = "\(dayNumber)\n\(dayWeek)"
        }
        return dataFormatted
    }
    
    func getDateInt(dayBefore: Int) -> Int {
        let date = date.dayBefore(value: -dayBefore)
        let weekday = calendar.component(.weekday, from: date)
        return weekday - 1
    }
    
    func dayBefore(value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
}

// переделать
// MARK:  - DateManager
extension Date {
    func dayBefore(value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
}
