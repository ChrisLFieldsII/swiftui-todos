//
//  Extensions.swift
//  TodoList
//
//  Created by Christopher Fields on 12/2/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Date {
    static func getKeyFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    static func getDateFromKey(key: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: key) ?? Date()
    }
    
    static func getYearSince2000(date: Date = Date()) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        var dateStr = dateFormatter.string(from: date)
        dateStr.removeFirst()
        return Int(dateStr) ?? 0
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // notification from background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler()
    }
    
    // notification while running
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler([.sound, .alert])
    }
}
