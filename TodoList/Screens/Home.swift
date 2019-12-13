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
    @State var showInfo: Bool = true
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
    
    var navbarTrailingItems: some View {
        HStack {
            Button(action:{withAnimation(.spring()) {self.showInfo.toggle()}}) {
                Image(systemName: self.showInfo ? "minus" : "plus")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .accessibility(label: Text("Toggle Info"))
                    .padding()
            }
            Button(action: { self.userData.showModal = true; self.userData.currentModal = .SETTINGS }) {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .accessibility(label: Text("Toggle Settings"))
                    .rotationEffect(.degrees(90))
                    .padding()
            }
        }
    }
    
    fileprivate var badgeTitles = [BadgeKey("< 5 Todos", Color.orange), BadgeKey("< 10 Todos", Color.pink), BadgeKey("10+ Todos", Color.green)]
    
    var body: some View {
        NavigationView {
            VStack {
                if self.showInfo {
                    VStack(alignment: .leading) {
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Color Key")
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(self.badgeTitles) { badgeTitle in
                                        Badge(text: badgeTitle.id, backgroundColor: badgeTitle.color)
                                    }
                                }
                            }
                        }
                        
                        Text("Today: " + Date.getKeyFromDate(date: Date()).replacingOccurrences(of: "_", with: "/"))
                        Stepper(onIncrement: self.onYearInc, onDecrement: self.onYearDec) {
                            Text("Current Year: \((2000 + self.currYear).description)")
                        }
                        Divider()
                    }
                    .transition(.slide)
                }
                
                RKViewController(isPresented: self.$userData.showCalendar, rkManager: self.calendarManager, userData: self.userData)
                    .sheet(isPresented: self.$userData.showModal, onDismiss: { UserData.saveTodos(todosToSave: self.userData.todos) }) {
                        if self.userData.currentModal == .SETTINGS {
                            Settings()
                        }
                        else {
                            TodosList(dateKey: Date.getKeyFromDate(date: self.userData.selectedDate ?? Date()))
                                .environmentObject(self.userData)
                                .environmentObject(self.calendarManager)
                        }
                   }
            }
            .navigationBarTitle("Home")
            .navigationBarItems(trailing: self.navbarTrailingItems)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

fileprivate struct BadgeKey: Identifiable {
    var id: String
    var color: Color
    
    init(_ id: String, _ color: Color) {
        self.id = id
        self.color = color
    }
}
