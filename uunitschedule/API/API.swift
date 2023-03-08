
import Alamofire
import Foundation
import OSLog

enum API {
    
    static let logger = Logger(subsystem: "com.uust.API", category: "")
    
    struct Group: Identifiable, Decodable {
        let id: Int
        let title: String
        let faculty: String
        let course: Int
    }
    
    enum APIError: Error {
        case responseDataIsNil
        case parseJsonError
    }
    
    static let url = "https://isu.ugatu.su/api/schedule/"
    fileprivate static let login = "arpakit"
    fileprivate static let password = "vPDPhQAE"
    
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
    static fileprivate var groups: Self {
        return [
            "ask": "get_group_list",
            "login": API.login,
            "pass": API.password
        ]
    }
}
