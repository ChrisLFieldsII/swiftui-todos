//
//  TodosList.swift
//  TodoList
//
//  Created by Christopher Fields on 11/21/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import SwiftUI

struct TodosList: View {
    @EnvironmentObject var userData: UserData
    @State var editMode: EditMode = .inactive
    @State var todoDescription: String = ""
    @State var selectedTodo: Todo? = nil
    @State var selectedTodoIndex: Int = -1
    
    func deleteTodo(at offsets: IndexSet) {
        userData.todos.remove(atOffsets: offsets)
    }
    
    func moveTodo(fromSource: IndexSet, toDestination: Int) {
        userData.todos.move(fromOffsets: fromSource, toOffset: toDestination)
    }
    
    func addTodo() {
        let nextId: String = (userData.todos.count + 1).description
        let id: String = selectedTodo?.id ?? nextId
        editMode = .active // have to activate edit mode so references are used and dont cause index errors
        if selectedTodo == nil {
            userData.todos.append(Todo(id: id, description: todoDescription))
        }
        else {
            userData.todos[self.selectedTodoIndex].description = todoDescription
        }
        
        todoDescription = ""
        selectedTodo = nil
    }
    
    func getToggleBinding(todo: Todo) -> Binding<Bool> {
        return Binding(
            get: {
                return todo.isDone
            },
            set: { (newValue) in
                let foundTodoIndex = self.userData.todos.firstIndex(of: todo)
                self.userData.todos[foundTodoIndex!].isDone = newValue
            }
        )
    }
    
    func getToggleBinding(todoIndex: Int) -> Binding<Bool> {
        return Binding(
            get: {
                return self.userData.todos[todoIndex].isDone
            },
            set: { (newValue) in
                self.userData.todos[todoIndex].isDone = newValue
            }
        )
    }
    
    func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d, yyyy")
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // EDITING
                if self.$editMode.wrappedValue == .active {
                    VStack {
                        Text(self.getFormattedDate(date: Date()))
                        TextField("Add Todo", text: $todoDescription, onCommit: addTodo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        List {
                            ForEach(userData.todos) { todo in
                                Toggle(todo.description, isOn: self.getToggleBinding(todo: todo))
                                .disabled(true)
                            }
                            .onDelete(perform: deleteTodo)
                            .onMove(perform: moveTodo)
                        }
                    }
                }
                    
                // NOT EDITING
                else {
                    VStack {
                        Text(self.getFormattedDate(date: Date()))
                        TextField("Add Todo", text: $todoDescription, onCommit: addTodo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        List {
                            ForEach(userData.todos.indices) { todoIndex in
                                HStack {
                                    Button(action: {
                                        let currTodo = self.userData.todos[todoIndex]
                                        self.todoDescription = currTodo.description
                                        self.selectedTodo = currTodo
                                        self.selectedTodoIndex = todoIndex
                                    }) {
                                        Text(self.userData.todos[todoIndex].description)
                                    }
                                    Toggle("", isOn: self.getToggleBinding(todoIndex: todoIndex))
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Todos"))
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, self.$editMode)
        }
    }
}

struct TodosList_Previews: PreviewProvider {
    static var previews: some View {
        TodosList()
            .environmentObject(UserData())
            .environment(\.editMode, Binding.constant(.active))
    }
}
