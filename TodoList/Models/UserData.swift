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
    
    @Published var todos: [String:[Todo]] = loadTodos()
    @Published var selectedDate: Date? = nil
    @Published var showTodos: Bool = false
    @Published var showCalendar: Bool = true
    
    private static var fileUrl:URL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todos.json"))!
    }
    
    public static func loadTodos() -> [String:[Todo]] {
        let data: Data
        
        do {
            data = try Data(contentsOf: self.fileUrl)
            let decoder = JSONDecoder()
            let loadedTodos = try decoder.decode([String: [Todo]].self, from: data)
            print("loaded todos: \(loadedTodos)")
            return loadedTodos
        }
        catch {
            fatalError("Failed to load todos")
        }
    }
    
    public static func saveTodos(todosToSave: [String:[Todo]]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(todosToSave)
            try data.write(to: self.fileUrl)
            print("saved todos!")
        }
        catch {
            fatalError("Failed to save todos: \(error.localizedDescription)")
        }
    }
}
