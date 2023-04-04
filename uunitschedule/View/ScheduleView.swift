import Foundation
import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var groupsSchedule: GroupScheduleViewModel
    @EnvironmentObject var selectedGroupsStorage: GroupsStorageViewModel
    
    var body: some View {
        content
    }
    
    let firstColumnWidth: CGFloat = 60
    
    @ViewBuilder var content: some View {
        switch groupsSchedule.state {
        case .schedule:
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(groupsSchedule.schedule, id: \.self) { day in
                        HStack {
                            Text(day.weekdayName)
                                .font(.title)
                            Spacer()
                        }
                        ForEach(day.rows, id: \.self) { row in
                            HStack(alignment: .top) {
                                VStack(spacing: 5) {
                                    Text("\(row.index)")
                                        .foregroundColor(Color.white)
                                        .background(
                                            Circle()
                                                .foregroundColor(.green)
                                                .frame(width: 30, height: 30)
                                        )
                                    Text(row.timeStart)
                                        .font(.title3)
                                    Text(row.timeEnd)
                                        .font(.caption)
                                }
                                .frame(width: firstColumnWidth)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(row.type)")
                                        .font(.title2)
                                        .padding([.leading, .trailing])
                                        .background(Color.tertiarySystemBackground)
                                        .cornerRadius(20)
                                    Text(row.scheduleSubjectTitle)
                                        .font(.title3)
                                    Text(row.teacher)
                                        .font(.caption)
                                    Text(row.roomTitle)
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondarySystemBackground)
                            .cornerRadius(20)
                        }
                    }
                } header: {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(groupsSchedule.schedule, id: \.self) { day in
                                Button {

                                } label: {
                                    Text(day.weekdayName)
                                        .tag(day.weekdayName)
                                }.buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding([.top, .bottom])
                    .background(Color.systemBackground)
                }
            }
        case .loading:
            Text("Loading")
                .task {
                    guard let selectedGroup = selectedGroupsStorage.selectedGroupId else {
                        return
                    }
                    await groupsSchedule.loadSchedule(for: selectedGroup)
                }
        case .error:
            Text("Error")
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var groupsStorage = GroupsStorageViewModel()
    static var groupsScheduleStorage = GroupScheduleViewModel()
    
    static var previews: some View {
        SchedulePageView()
            .environmentObject(groupsStorage)
            .environmentObject(groupsScheduleStorage)
    }
}

extension API.ScheduleDay {
    private static let dayNames: [Int: String] = [
        0: "Понедельник",
        1: "Вторник",
        2: "Среда",
        3: "Четверг",
        4: "Пятница",
        5: "Суббота"
    ]
    
    var weekdayName: String {
        get {
            return API.ScheduleDay.dayNames[self.weekDayId] ?? ""
        }
    }
}

extension API.ScheduleRow {
    var timeStart: String {
        return String(self.scheduleTimeTitle.split(separator: "-").first ?? "")
    }
    var timeEnd: String {
        return String(self.scheduleTimeTitle.split(separator: "-").last ?? "")
    }
}
