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
    @EnvironmentObject var calendarManager: RKManager
    @State var editMode: EditMode = .inactive
    @State var todoDescription: String = ""
    @State var selectedTodo: Todo? = nil
    @State var selectedTodoIndex: Int = -1
    var dateKey: String
    
    var date: Date? {
        return Date.getDateFromKey(key: self.dateKey)
    }
    
    var todos: [Todo] {
        return self.userData.todos[self.dateKey] ?? []
    }
    
    func dismissKeyboard() {
        UIApplication.shared.endEditing()
    }
    
    func deleteTodo(at offsets: IndexSet) {
        userData.todos[self.dateKey]?.remove(atOffsets: offsets)
    }
    
    func moveTodo(fromSource: IndexSet, toDestination: Int) {
        userData.todos[self.dateKey]?.move(fromOffsets: fromSource, toOffset: toDestination)
    }
    
    func reset() {
        todoDescription = ""
        selectedTodo = nil
        self.dismissKeyboard()
    }
    
    func addTodo() {
        if todoDescription.count == 0 {
            return
        }
        
        let nextId: String = UUID().uuidString
        let id: String = selectedTodo?.id ?? nextId
        let isUpdate: Bool = selectedTodo != nil
        
        if isUpdate && todoDescription == userData.todos[self.dateKey]?[self.selectedTodoIndex].description {
            return self.reset()
        }
        
        editMode = .active // have to activate edit mode so references are used and dont cause index errors
        // CREATE
        if !isUpdate {
            if userData.todos[self.dateKey] == nil {
                userData.todos[self.dateKey] = []
            }
            userData.todos[self.dateKey]?.append(Todo(id: id, description: todoDescription))
        }
        // UPDATE
        else {
            userData.todos[self.dateKey]?[self.selectedTodoIndex].description = todoDescription
        }
        
        self.reset()
    }
    
    func getToggleBinding(todo: Todo) -> Binding<Bool> {
        return Binding(
            get: {
                return todo.isDone
            },
            set: { (newValue) in
                let foundTodoIndex = self.userData.todos[self.dateKey]?.firstIndex(of: todo)
                self.userData.todos[self.dateKey]?[foundTodoIndex!].isDone = newValue
            }
        )
    }
    
    func getToggleBinding(todoIndex: Int) -> Binding<Bool> {
        return Binding(
            get: {
                return (self.userData.todos[self.dateKey]?[todoIndex].isDone ?? false)
            },
            set: { (newValue) in
                self.userData.todos[self.dateKey]?[todoIndex].isDone = newValue
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
        VStack {
            // EDITING
            if self.$editMode.wrappedValue == .active {
                VStack {
                    DateHeader(date: self.getFormattedDate(date: self.date ?? Date()), todos: self.todos, userData: self.userData, calendarManager: self.calendarManager)
                    TextField("Add Todo", text: self.$todoDescription, onCommit: self.addTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .modifier(ClearTextButton(text: self.$todoDescription))
                    if (self.userData.todos[self.dateKey] ?? []).count > 0 {
                        List {
                            ForEach(self.userData.todos[self.dateKey] ?? []) { todo in
                                Toggle(todo.description, isOn: self.getToggleBinding(todo: todo))
                                    .disabled(true)
                            }
                            .onDelete(perform: self.deleteTodo)
                            .onMove(perform: self.moveTodo)
                        }
                    }
                    else {
                        NoTodos()
                    }
                }
            }
                
            // NOT EDITING
            else {
                VStack {
                    DateHeader(date: self.getFormattedDate(date: self.date ?? Date()), todos: self.todos, userData: self.userData, calendarManager: self.calendarManager)
                    TextField("Add Todo", text: self.$todoDescription, onCommit: self.addTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .modifier(ClearTextButton(text: self.$todoDescription))
                    if (self.userData.todos[self.dateKey] ?? []).count > 0 {
                        ScrollView {
                            ForEach(self.userData.todos[self.dateKey]?.indices ?? 0..<0) { todoIndex in
                                VStack {
                                    HStack {
                                        Button(action: {
                                            let currTodo = self.userData.todos[self.dateKey]?[todoIndex]
                                            self.todoDescription = currTodo?.description ?? ""
                                            self.selectedTodo = currTodo
                                            self.selectedTodoIndex = todoIndex
                                        }) {
                                            Text(self.userData.todos[self.dateKey]?[todoIndex].description ?? "N/A")
                                        }
                                        Toggle("", isOn: self.getToggleBinding(todoIndex: todoIndex).animation(.spring()))
                                    }
                                    Divider()
                                }
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    else {
                        NoTodos()
                    }
                }
            }
        }
        .navigationBarTitle(Text("Todos"))
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, self.$editMode)
    }
}

struct ClearTextButton: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

fileprivate struct NoTodos: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No Todos")
            Spacer()
        }
    }
}

fileprivate struct DateHeader: View {
    var date: String
    var todos: [Todo]
    var userData: UserData
    var calendarManager: RKManager
    
    var numComplete: Int {
        let _numComplete = todos.filter { $0.isDone == true }
        return _numComplete.count
    }
    
    var body: some View {
        HStack {
            Badge(text: "\(self.numComplete)/\(self.todos.count)", backgroundColor: Color.clear)
            Spacer()
            Button(action: {
                UIApplication.shared.endEditing()
            }) {
                Text(date)
            }
            Spacer()
            EditButton()
        }
        .padding(.all, 10)
    }
}

struct KeyboardDismissBackground<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .overlay(content)
    }
}

struct TodosList_Previews: PreviewProvider {
    static var previews: some View {
        TodosList(dateKey: "11_30_2019")
            .environmentObject(UserData())
            .environmentObject(RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            .environment(\.editMode, Binding.constant(.active))
    }
}
