import Foundation
import Combine

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return try? UserDefaults.standard.get(forKey: key)
        }
        set {
            try? UserDefaults.standard.set(object: newValue, forKey: key)
        }
    }
}
