//
//  ScheduleNotification.swift
//  RoutineTasks
//
//  Created by Elenka on 25.04.2023.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotification: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let date = DateManager()
    
    func userRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { granted, error in
            guard granted else {
                print("User has declined notifications")
                return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
    
    func addNotification(title: String, id: String, dataComponents: DateComponents? = nil, postpone: Int = 0) {
        let content = getContent(title: title)
        let trigger = getTrigger(dataComponents: dataComponents, postpone: postpone)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        notificationCenter.setNotificationCategories([getCategory()])
    }

    private func getContent(title: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Время выполнить " + title
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "User Actions"
        return content
    }
    
    private func getTrigger(dataComponents: DateComponents? = nil, postpone: Int) -> UNNotificationTrigger {
        let trigger: UNNotificationTrigger
        if let dataComponents = dataComponents {
            trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents , repeats: true)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(postpone), repeats: false)
        }
        return trigger
    }
    
    private func getCategory() -> UNNotificationCategory {
        let postpone15Action = UNNotificationAction(identifier: "15", title: "отложить на 15 минут", options: [])
        let postpone30Action = UNNotificationAction(identifier: "30", title: "отложить на 30 минут", options: [])
        let postpone60Action = UNNotificationAction(identifier: "60", title: "отложить на 60 минут", options: [])
        let deleteAction = UNNotificationAction(identifier: "Skip", title: "Skip", options: [.destructive])
        let category = UNNotificationCategory(identifier: "User Actions",
                                              actions: [postpone15Action, postpone30Action, postpone60Action, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        return category
    }
}

extension LocalNotification: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let title = response.notification.request.content.title
        switch response.actionIdentifier {
//        case UNNotificationDismissActionIdentifier:
//            print("Dismiss Action")
//        case UNNotificationDefaultActionIdentifier:
//            print("Default")
        case "15":
            addNotification(title: title, id: "15", postpone: 15*60)
        case "30":
            addNotification(title: title, id: "30", postpone: 30*60)
        case "60":
            addNotification(title: title, id: "60", postpone: 60*60)
        case "Skip":
            print("Skip")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
