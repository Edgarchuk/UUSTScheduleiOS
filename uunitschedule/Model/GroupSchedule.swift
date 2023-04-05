import Foundation
import Cache

struct SemesterComponents {
    let name: String
    let startYear: Int
    let endYear: Int
}

protocol GroupScheduleDelegate {
    func updateSemesterInfo() async throws
    var semesterComponents: SemesterComponents { get }
    func load(for id: API.Group.ID) async throws
    func get(for id: API.Group.ID) throws -> [ScheduleDay]
}

enum WeekDay: Int, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

struct ScheduleDay: Codable, Hashable {
    let weekDay: WeekDay
    let schedule: [ScheduleItem]
}

struct ScheduleItem: Codable, Hashable {
    let index, scheduleID: Int
    var scheduleWeek: Int
    let scheduleSubjectTitle: String
    let scheduleWeekdayID: Int
    let timeStart: Date
    let timeEnd: Date
    let buildingTitle, roomTitle, comment: String
    let type, teacher: String
    let teacherID: Int
}

class GroupSchedule: GroupScheduleDelegate {
    typealias GroupID = API.Group.ID
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private let storage = CacheStorage<GroupID, [ScheduleDay]>()
    private var semesterName: String = ""
    private var semesterStartYear: Int = 0
    private var semesterEndYear: Int = 0
    
    var semesterComponents: SemesterComponents {
        get {
            SemesterComponents(name: semesterName, startYear: semesterStartYear, endYear: semesterEndYear)
        }
    }
    
    enum Errors: Error {
        case semesterParseError
        case parseScheduleError
    }
    
    func updateSemesterInfo() async throws {
        let semester = (try await API.getCurrentSemester()).split(separator: " ")
        if semester.count < 2 {
            throw Errors.semesterParseError
        }
        semesterName = String(semester.first!)
        let year = semester.last!.split(separator: "/")
        guard let start = Int(year.first ?? "") else {
            throw Errors.semesterParseError
        }
        guard let end = Int(year.last ?? "") else {
            throw Errors.semesterParseError
        }
        semesterStartYear = start
        semesterEndYear = end
    }
    
    //TODO: Fix this shit
    func load(for id: GroupID) async throws {
        try await updateSemesterInfo()
        
        let schedule = try (try await API.getGroupsSchedule(for: id)).map({item in
            let weekday = (item.weekDayId + 1) % 7 + 1
            return ScheduleDay(weekDay: WeekDay(rawValue: weekday) ?? .wednesday,
                               schedule: try item.rows.map({ row in
                let tmp = try row.scheduleWeeks.map({ week in
                    guard let week = Int(week) else { throw Errors.parseScheduleError }
                    guard let day = getDay(forYear: semesterStartYear,weekday: weekday, andWeek: week) else { throw Errors.parseScheduleError }
                    let tmp = row.scheduleTimeTitle.split(separator: "-")
                    guard let timeStart = getDate(fromStringTime: String(tmp.first ?? ""), andDay: day) else { throw Errors.parseScheduleError }
                    guard let timeEnd = getDate(fromStringTime: String(tmp.last ?? ""), andDay: day) else { throw Errors.parseScheduleError }
                    return ScheduleItem(index: row.index,
                                        scheduleID: row.scheduleID,
                                        scheduleWeek: week,
                                        scheduleSubjectTitle: row.scheduleSubjectTitle,
                                        scheduleWeekdayID: row.scheduleWeekdayID,
                                        timeStart: timeStart,
                                        timeEnd: timeEnd,
                                        buildingTitle: row.buildingTitle,
                                        roomTitle: row.roomTitle,
                                        comment: row.comment,
                                        type: row.type,
                                        teacher: row.teacher,
                                        teacherID: row.teacherID)
                })
                return tmp
            }).flatMap({ $0 })
            )
        })
        try storage.set(value: schedule, forKey: id)
    }
    
    func get(for id: GroupID) throws -> [ScheduleDay] {
        return try storage.get(forKey: id)
    }
    
    private func getDay(forYear year: Int,weekday: Int, andWeek week: Int) -> Date? {
        let firstSeptember = DateComponents(calendar: calendar,timeZone: calendar.timeZone, year: year, month: 9, day: 1)
        var date = calendar.date(from: firstSeptember)!
        let components = calendar.dateComponents([.weekday], from: date)
        let resultDay = calendar.date(byAdding: .day, value: week * 7 + weekday + (7 - components.weekday!), to: date)
        return resultDay
    }
    
    private func getDate(fromStringTime time: String, andDay day: Date) -> Date? {
        var components = calendar.dateComponents([.year, .month, .day], from: day)
        let tmp = time.split(separator: ":").map({Int(String($0))})
        guard let hourTmp = tmp.first, let hour = hourTmp else { return nil }
        guard let minuteTmp = tmp.last, let minute = minuteTmp else { return nil }
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)
    }
}
