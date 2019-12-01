//
//  UserData.swift
//  TodoList
//
//  Created by Christopher Fields on 11/21/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    @Published var todos: [Todo] = todosData
}
