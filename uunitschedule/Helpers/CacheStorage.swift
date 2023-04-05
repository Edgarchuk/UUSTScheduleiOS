import Foundation
import Cache

class CacheStorage<Key: Hashable, Value: Codable> {
    private let storage: Storage = {
        let diskConfig = DiskConfig(name: "Storage<\(Key.self),\(Value.self)>")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        let storage = try! Storage<Key, Value>(
            diskConfig: diskConfig, memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Value.self)
        )
        return storage
    }()
    
    func get(forKey key: Key) throws -> Value {
        return try storage.object(forKey: key)
    }
    
    func set(value: Value, forKey key: Key) throws {
        try storage.setObject(value, forKey: key)
    }
}
