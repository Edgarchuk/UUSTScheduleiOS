
import Alamofire
import Foundation
import OSLog

enum API {
    
    static let logger = Logger(subsystem: "com.uust.API", category: "")
    
    struct Group: Identifiable, Codable {
        typealias Id = Int
        let id: Id
        let title: String
        let faculty: String
        let course: Int
    }
    
    struct GroupsSchedule: Codable {
        let data: [ScheduleRow]
    }

    struct ScheduleRow: Codable, Hashable {
        let index, scheduleID: Int
        var scheduleWeeks: [String]
        let scheduleSubjectTitle: String
        let scheduleWeekdayID: Int
        let scheduleTimeTitle, buildingTitle, roomTitle, comment: String
        let type, teacher: String
        let teacherID: Int

        enum CodingKeys: String, CodingKey {
            case index
            case scheduleID = "schedule_id"
            case scheduleWeeks = "schedule_weeks"
            case scheduleSubjectTitle = "schedule_subject_title"
            case scheduleWeekdayID = "schedule_weekday_id"
            case scheduleTimeTitle = "schedule_time_title"
            case buildingTitle = "building_title"
            case roomTitle = "room_title"
            case comment, type, teacher
            case teacherID = "teacher_id"
        }
    }
    
    struct ScheduleDay: Codable, Hashable {
        let weekDayId: Int
        let rows: Array<ScheduleRow>
    }
    struct CurrentWeekResult: Codable {
        let data: [Int]
    }
    
    enum APIError: Error {
        case responseDataIsNil
        case parseJsonError
    }
    
    static let url = "https://isu.ugatu.su/api/schedule/"
    fileprivate static let login = "IOSArsen"
    fileprivate static let password = "hFFP5SjsRZapWVM"
    
    static func getGroups() async throws -> [Group] {
        async let response = AF.request(url, method: .get,  parameters: .groups, encoding: URLEncoding(destination: .queryString)).serializingData()
        guard let data = await response.response.data else {
            logger.error("getGroups:Response data is nil")
            throw APIError.responseDataIsNil
        }
        guard let json = (try JSONSerialization.jsonObject(with: data) as? [String: Any])?["data"] as? [String: Any] else {
            logger.error("getGroups:Parse json error")
            throw APIError.parseJsonError
        }
        var values = json.map({$0.value as? [String: Any]})
        if values.contains(where: {$0 == nil}) {
            logger.error("getGroups:Parse json error")
            throw APIError.parseJsonError
        }
        var groups = values.map({$0!}).filter({$0["group_id"] as? Int != 1842}).map({Group(json: $0)})
        if groups.contains(where: {$0 == nil}) {
            logger.error("getGroups:Parse json error")
            throw APIError.parseJsonError
        }
        
        return groups.map({$0!})
    }
    
    static func getGroupsSchedule(for groupId: Group.Id) async throws -> [ScheduleDay] {
        async let response = AF.request(url, method: .get, parameters: .groupsSchedule(for: groupId), encoding: URLEncoding(destination: .queryString)).serializingData()
        var data = try JSONDecoder().decode(GroupsSchedule.self,from: try await response.value).data
        data = data.map({item in
            var tmp = item
            tmp.scheduleWeeks = item.scheduleWeeks.filter({!$0.isEmpty})
            return tmp
        })
        
        var result: [ScheduleDay] = (0..<Constant.dayInWeek).map({ weekday in
            return ScheduleDay(weekDayId: weekday, rows: data.filter({$0.scheduleWeekdayID == weekday}))
        })
        return result
    }
    
    static func getCurrentWeek() async throws -> Int {
        async let response = AF.request(url, method: .get, parameters: .currentWeek, encoding: URLEncoding(destination: .queryString)).serializingData()
        let data = try JSONDecoder().decode(CurrentWeekResult.self,from: try await response.value).data
        return data.first ?? 0
    }
    
    
    
}

extension API.Group {
    init?(json: [String: Any]) {
        guard let id = json["group_id"] as? Int else {
            return nil
        }
        
        guard let title = json["group_title"] as? String else {
            return nil
        }
        
        guard let faculty = json["faculty"] as? String else {
            return nil
        }
        
        guard let course = json["course"] as? Int else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.faculty = faculty
        self.course = course
    }
}

extension Parameters {
    static fileprivate var loginAndPassword: Self {
        return [
            "login": API.login,
            "pass": API.password
        ]
    }
    
    static fileprivate var groups: Self {
        var tmp = loginAndPassword
        tmp["ask"] = "get_group_list"
        return tmp
    }
    
    static fileprivate func groupsSchedule(for id: Int) -> Self {
        var tmp = loginAndPassword
        tmp["ask"] = "get_group_schedule"
        tmp["id"] = "\(id)"
        return tmp
    }
    static fileprivate var currentWeek: Self {
        var tmp = loginAndPassword
        tmp["ask"] = "get_current_week"
        return tmp
    }
}
