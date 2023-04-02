//
//  ContentView.swift
//  uunitschedule
//
//  Created by Эдгар Назыров on 04.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var groupsStorage = GroupsStorageViewModel()
    @ObservedObject var groupsScheduleStorage = GroupScheduleViewModel()
    
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
        } else {
            NavigationView {
                TabView {
                    SchedulePageView()
                        .tabItem {
                            Text("Schedule")
                        }
                    SettingsPage()
                        .tabItem {
                            Text("Settings")
                        }
                }
                .environmentObject(groupsStorage)
                .environmentObject(groupsScheduleStorage)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
