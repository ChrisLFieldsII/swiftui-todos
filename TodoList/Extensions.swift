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
}
