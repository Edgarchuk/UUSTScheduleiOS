//
//  ContentView.swift
//  uunitschedule
//
//  Created by Эдгар Назыров on 04.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var groupsStorage = GroupsStorageViewModel()
    @ObservedObject var groupsScheduleStorage = GroupScheduleViewModel(scheduleDelegate: GroupSchedule())
    @ObservedObject var colorScheme = ColorSchemeViewModel()
    
    @State var isLoaded: Bool = false
    
    var body: some View {
        if isLoaded == false {
            Spacer()
                .task {
                    await groupsStorage.update()
                    self.isLoaded = true
                }
        } else if groupsStorage.groupIds == nil {
            StartPageView()
                .environmentObject(groupsStorage)
                .environmentObject(groupsScheduleStorage)
                .preferredColorScheme(colorScheme.colorScheme)
                
        } else {
            TabView {
                SchedulePageView()
                    .tabItem {
                        Label("Расписание", systemImage: "brain.head.profile")
                    }
                ExamsView()
                    .tabItem {
                        Label("Экзамены", systemImage: "pencil.and.outline")
                    }
                NavigationView {
                    SettingsPage()
                }
                    .tabItem {
                        Label("Настройки", systemImage: "gearshape")
                    }
            }
            .background(Color.systemBackground)
            .environmentObject(groupsStorage)
            .environmentObject(groupsScheduleStorage)
            .environmentObject(colorScheme)
            .preferredColorScheme(colorScheme.colorScheme)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
