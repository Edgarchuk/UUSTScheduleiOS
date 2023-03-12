//
//  ContentView.swift
//  uunitschedule
//
//  Created by Эдгар Назыров on 04.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var groupsStorage = SelectedGroupsStorage()
    
    var body: some View {
        if groupsStorage.groupIds == nil {
            StartPageView()
                .environmentObject(groupsStorage)
        } else {
            TabView {
                SchedulePageView()
                    .tabItem {
                        Text("Schedule")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
