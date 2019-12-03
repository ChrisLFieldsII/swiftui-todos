//
//  Home.swift
//  TodoList
//
//  Created by Christopher Fields on 12/2/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var userData: UserData
            
    var calendarManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*365), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var body: some View {
        NavigationView {
            VStack {
                RKViewController(isPresented: self.$userData.showCalendar, rkManager: self.calendarManager, userData: self.userData)
                    .sheet(isPresented: self.$userData.showTodos) {
                        TodosList(dateKey: Date.getKeyFromDate(date: self.userData.selectedDate ?? Date()))
                            .environmentObject(self.userData)
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
