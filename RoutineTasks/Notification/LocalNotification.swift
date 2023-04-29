//
//  ScheduleNotification.swift
//  RoutineTasks
//
//  Created by Elenka on 25.04.2023.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let date = DateManager()
    
    func userRequest() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func addNotification(title: String, dataComponents: DateComponents) {
        let content = UNMutableNotificationContent()
        let userActions = "User Actions"
        
        content.title = title
        content.body = "Время выполнить " + title
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents , repeats: true)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let postpone15Action = UNNotificationAction(identifier: "15", title: "отложить на 15 минут", options: [])
        let postpone30Action = UNNotificationAction(identifier: "30", title: "отложить на 30 минут", options: [])
        let postpone60Action = UNNotificationAction(identifier: "15", title: "отложить на 60 минут", options: [])
        let deleteAction = UNNotificationAction(identifier: "Skip", title: "Skip", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions,
                                              actions: [postpone15Action, postpone30Action, postpone60Action, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
//            contentNotification(title: "sdfd", dataComponents: <#DateComponents#>)
        case "Skip":
            print("Skip")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
