//
//  UserData.swift
//  TodoList
//
//  Created by Christopher Fields on 12/1/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    @Published var todos: [String:[Todo]] = todosData
    @Published var selectedDate: Date? = nil
    @Published var showTodos: Bool = false
    @Published var showCalendar: Bool = true
}
