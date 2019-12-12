//
//  LocalNotificationManager.swift
//  TodoList
//
//  Created by Christopher Fields on 12/9/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification: Identifiable {
    var id:String
    var title:String
    var datetime:DateComponents
}

class LocalNotificationManager {
    
    static let instance: LocalNotificationManager = LocalNotificationManager()
    
    private init() {}
    
    var notifications = [Notification]()

    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    func addNotification(id: String, title: String, datetime: DateComponents) {
        let foundNoti = self.notifications.first(where: { $0.id == id })
        if foundNoti != nil {
            print("Notification with id \(id) already exists")
            return
        }
        
        let newNoti = Notification(id: id, title: title, datetime: datetime)
        notifications.append(newNoti)
        print("Added notification with id \(id)")
    }
}
