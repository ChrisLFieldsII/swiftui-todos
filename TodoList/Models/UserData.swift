//
//  UserData.swift
//  TodoList
//
//  Created by Christopher Fields on 12/1/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class UserData: ObservableObject {
    
    @Published var todos: [String:[Todo]] = loadTodos()
    @Published var selectedDate: Date? = nil
    @Published var showModal: Bool = false
    @Published var currentModal: CurrentModal = .TODOS
    @Published var showCalendar: Bool = true
    @Published var colors: (lessThan5:Color, lessThan10:Color, moreThan10:Color) = (lessThan5:Color.orange, lessThan10:Color.pink, moreThan10:Color.green)
    
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
//            fatalError("Failed to load todos")
            saveTodos(todosToSave: [:])
            return [:]
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
    
    public func getColor(_ amount: Int) -> Color {
        print("Getting color with amount \(amount)")
        if (amount == 0) { return Color.clear }
        if (amount < 5) { return self.colors.lessThan5 }
        if (amount < 10) { return self.colors.lessThan10 }
        return self.colors.moreThan10
    }
}
