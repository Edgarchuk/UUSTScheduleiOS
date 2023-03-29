
import Foundation
import SwiftUI

struct SchedulePageView: View {
    @EnvironmentObject var groupsSchedule: GroupScheduleViewModel
    @EnvironmentObject var groupsStorage: GroupsStorageViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Grid {
                        GridRow {
                            Image(systemName: "person.3.fill")
                            Text("Выбранная группа")
                                .font(.title2)
                        }
                        GridRow {
                            Spacer()
                            Text("\(groupsStorage.selectedGroup?.title ?? "nil")")
                                .font(.title)
                        }
                    }
                    .padding([.top, .bottom, .leading])
                    Spacer()
                }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(20)
                    .padding(.bottom)
                
                HStack {
                    Image(systemName: "arrow.left")
                        .padding(.leading)
                    Spacer()
                    VStack {
                        Text("Весенний семестр 2022/2023")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("Неделя \(groupsSchedule.currentWeek ?? 0)")
                            .font(.title)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .padding(.trailing)
                }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(20)
                    .padding(.bottom)
                ScheduleView()
            }.padding(20)
        }.background(Color.systemBackground)
        
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var groupsStorage = GroupsStorageViewModel()
    static var groupsScheduleStorage = GroupScheduleViewModel()
    
    static var previews: some View {
        SchedulePageView()
            .environmentObject(groupsStorage)
            .environmentObject(groupsScheduleStorage)
    }
}
