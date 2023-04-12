
import Foundation
import SwiftUI

struct SchedulePageView: View {
    @EnvironmentObject var groupsSchedule: GroupScheduleViewModel
    @EnvironmentObject var groupsStorage: GroupsStorageViewModel
    
    var body: some View {
        ScrollView {
            VStack {
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
                .cornerRadius(Constant.radius)
                .padding(.bottom)
                
                HStack {
                    Button(action:
                            { if groupsSchedule.currentWeek! > 0 {
                                groupsSchedule.currentWeek = groupsSchedule.currentWeek!-1
                            }
                        print(groupsSchedule.currentWeek)
                        
                        groupsSchedule.reload()
                       
                    }){
                        Image(systemName: "arrow.left")
                        .padding(.trailing)}
                    Spacer()
                    VStack {
                        Text("Весенний семестр 2022/2023")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("Неделя \(groupsSchedule.currentWeek ?? 0)")
                            .font(.title)
                    }
                    Spacer()
                    Button(action:
                            { if groupsSchedule.currentWeek! < 53 {
                                groupsSchedule.currentWeek = groupsSchedule.currentWeek!+1
                            }
                        print(groupsSchedule.currentWeek)
                        
                        groupsSchedule.reload()
                       
                    }){
                        Image(systemName: "arrow.right")
                        .padding(.trailing)}
                }
                .background(Color.secondarySystemBackground)
                .cornerRadius(Constant.radius)
                .padding(.bottom)
                switch (groupsSchedule.state) {
                case .schedule:
                    ScheduleView(schedule: groupsSchedule.schedule)
                case .loading:
                    Text("Loading")
                        .task {
                            guard let selectedGroup = groupsStorage.selectedGroupId else {
                                return
                            }
                            await groupsSchedule.loadSchedule(for: selectedGroup)
                        }
                case .error(let errorResult):
                    Text(errorResult)
                }
            }
            .padding()
        }
            .background(Color.systemBackground)
            .navigationBarTitle("Расписание")
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var groupsStorage = GroupsStorageViewModel()
    static var groupsScheduleStorage = GroupScheduleViewModel(scheduleDelegate: GroupSchedule())
    
    static var previews: some View {
        SchedulePageView()
            .environmentObject(groupsStorage)
            .environmentObject(groupsScheduleStorage)
    }
}
