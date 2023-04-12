import Foundation
import SwiftUI

struct ScheduleView: View {
    var body: some View {
        content
    }
    
    let firstColumnWidth: CGFloat = 60
    
    @State var schedule: [ScheduleDay]
    
    @ViewBuilder var content: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(schedule, id: \.self) { day in
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
                                Text("\(row.paraCount1)")
                                    .foregroundColor(Color.white)
                                    .background(
                                        Circle()
                                            .foregroundColor(row.paraColor1)
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
                                    .cornerRadius(Constant.radius)
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
                        .cornerRadius(Constant.radius)
                    }
                }
            } header: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(schedule, id: \.self) { day in
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
    
    private static let paraColor: [String: Color] = [
        "Лекция": .blue,
        "Практика (семинар)": .orange,
        "Лабораторная работа": .purple,
        "Физвоспитание": .yellow
    ]
    private static let paraCount: [String: String] = [
        "08:00": "1",
        "09:45": "2",
        "12:10": "3",
        "13:55": "4",
        "16:10": "5",
        "17:55": "6",
        "19:40": "7"
    ]
    var paraColor1: Color {
        get {
            return ScheduleItem.paraColor[type] ?? .gray
        }
    }
    var paraCount1: String {
        get {
            return ScheduleItem.paraCount[self.formattedStartTime]!
        }
    }
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
