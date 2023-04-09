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
    
    var currentDate: Date {
        date.dayBefore(value: 0)
    }
    
    enum formatDate {
        case yyyyMMdd
        case d_EE
        case EE
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
        case .EE:
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
            dataFormatted = dateFormatter.string(from: date)
        }
        return dataFormatted
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
