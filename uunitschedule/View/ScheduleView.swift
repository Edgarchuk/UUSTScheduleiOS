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
                        HStack {
                            Text(day.schedule.first?.localizedDay ?? "")
                                .font(.caption)
                            Spacer()
                        }
                        ForEach(day.schedule, id: \.self) { row in
                            HStack(alignment: .top) {
                                VStack(spacing: 5) {
                                    Text("\(row.index)")
                                        .foregroundColor(Color.white)
                                        .background(
                                            Circle()
                                                .foregroundColor(.green)
                                                .frame(width: 30, height: 30)
                                        )
                                    Text(row.formattedStartTime)
                                        .font(.title3)
                                    Text(row.formattedEndTime)
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
        case .error(let errorString):
            Text(errorString)
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var groupsStorage = GroupsStorageViewModel()
    static var groupsScheduleStorage = GroupScheduleViewModel(scheduleDelegate: GroupSchedule())
    
    static var previews: some View {
        SchedulePageView()
            .environmentObject(groupsStorage)
            .environmentObject(groupsScheduleStorage)
    }
}

extension ScheduleDay {
    private static let dayNames: [WeekDay: String] = [
        .sunday: "Воскресение",
        .monday: "Понедельник",
        .tuesday: "Вторник",
        .wednesday: "Среда",
        .thursday: "Четверг",
        .friday: "Пятница",
        .saturday: "Суббота"
    ]
    
    var weekdayName: String {
        get {
            return ScheduleDay.dayNames[self.weekDay] ?? ""
        }
    }
}

extension ScheduleItem {
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    var formattedStartTime: String {
        return Self.timeFormatter.string(from: self.timeStart)
    }
    var formattedEndTime: String {
        return Self.timeFormatter.string(from: self.timeEnd)
    }
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter
    }()
    
    var localizedDay: String {
        Self.dayFormatter.string(from: self.timeStart)
    }
}
