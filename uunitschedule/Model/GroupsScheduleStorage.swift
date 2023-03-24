import Foundation
import Cache


class GroupsScheduleStorage {
    let storage: Storage = {
        let diskConfig = DiskConfig(name: "GroupsScheduleStorage")
        let storage = try! Storage(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: API.)
        )
    }()
}
