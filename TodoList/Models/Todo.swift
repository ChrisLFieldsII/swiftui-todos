//
//  Todo.swift
//  TodoList
//
//  Created by Christopher Fields on 11/21/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation

struct Todo: Codable, Identifiable, Equatable {
    var id: String
    var description: String
    var isDone: Bool = false
}
