import Foundation
import Combine

class SelectedGroupsStorage: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("groups") public var groupIds: [Int]? {
        didSet {
            objectWillChange.send()
        }
    }
}
