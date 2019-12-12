//
//  Home.swift
//  TodoList
//
//  Created by Christopher Fields on 12/2/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import SwiftUI

struct Home: View {
    // 0 reps year 2000. only support 2000 and beyond!
    @State var currYear: Int = Date.getYearSince2000()
    @EnvironmentObject var userData: UserData
    
    var minDate: Date {
        let year: Int = 2000 + self.currYear
        let dateStr = "01_01_\(year)"
        return Date.getDateFromKey(key: dateStr)
    }
    
    var maxDate: Date {
        let year: Int = 2000 + self.currYear
        let dateStr = "12_31_\(year)"
        return Date.getDateFromKey(key: dateStr)
    }
            
    var calendarManager = RKManager(calendar: Calendar.current, minimumDate: Date.getDateFromKey(key: "01_01_\(2000 + Date.getYearSince2000())"), maximumDate: Date.getDateFromKey(key: "12_31_\(2000 + Date.getYearSince2000())"), mode: 0)
    
    func onYearInc() {
        self.currYear += 1
        self.calendarManager.minimumDate = self.minDate
        self.calendarManager.maximumDate = self.maxDate
    }
    
    func onYearDec() {
        if (self.currYear == 0) { return }
        self.currYear -= 1
        self.calendarManager.minimumDate = self.minDate
        self.calendarManager.maximumDate = self.maxDate
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Divider()
                    Text("Today: " + Date.getKeyFromDate(date: Date()).replacingOccurrences(of: "_", with: "/"))
                    Stepper(onIncrement: self.onYearInc, onDecrement: self.onYearDec) {
                        Text("Current Year: \((2000 + self.currYear).description)")
                    }
                    Divider()
                }
                RKViewController(isPresented: self.$userData.showCalendar, rkManager: self.calendarManager, userData: self.userData)
                    .sheet(isPresented: self.$userData.showTodos, onDismiss: { UserData.saveTodos(todosToSave: self.userData.todos) }) {
                        TodosList(dateKey: Date.getKeyFromDate(date: self.userData.selectedDate ?? Date()))
                            .environmentObject(self.userData)
                            .environmentObject(self.calendarManager)
                   }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
