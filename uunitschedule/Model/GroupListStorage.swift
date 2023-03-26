import Foundation
import Cache
import Combine

class GroupListStorage: ObservableObject {
    private let storage: Storage = {
        let diskConfig = DiskConfig(name: "GroupsScheduleStorage")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        let storage = try! Storage<String, [API.Group]>(
            diskConfig: diskConfig, memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Array<API.Group>.self)
        )
        return storage
    }()
    
    func update() async throws {
        let groups = try await API.getGroups()
        try storage.setObject(groups, forKey: "groups")
    }
    
    func get() throws -> [API.Group] {
        let groups = try storage.object(forKey: "groups")
        return groups
    }
}
