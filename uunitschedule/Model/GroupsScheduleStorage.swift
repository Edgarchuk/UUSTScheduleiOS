import Foundation
import Cache


class GroupsScheduleStorage {
    private let storage: Storage = {
        let diskConfig = DiskConfig(name: "GroupsScheduleStorage")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        let storage = try! Storage<Int, [API.ScheduleDay]>(
            diskConfig: diskConfig, memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Array<API.ScheduleDay>.self)
        )
        return storage
    }()
    
    func update(for id: API.Group.Id) async throws {
        let schedule = try await API.getGroupsSchedule(for: id)
        try storage.setObject(schedule, forKey: id)
    }
    
    func get(for id: API.Group.Id) throws -> [API.ScheduleDay] {
        let schedule = try storage.object(forKey: id)
        return schedule
    }
}
