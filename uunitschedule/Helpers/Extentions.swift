import Foundation

public extension UserDefaults {
    func set<T: Codable>(object: T, forKey key: String) throws {
        let data = try PropertyListEncoder().encode([object])
        set(data, forKey: key)
    }
    
    func get<T: Codable>(forKey key: String) throws -> T?{
        guard let data = value(forKey: key) as? Data else {
            return nil
        }
        
        return (try PropertyListDecoder().decode([T].self, from: data)).first
    }
}
