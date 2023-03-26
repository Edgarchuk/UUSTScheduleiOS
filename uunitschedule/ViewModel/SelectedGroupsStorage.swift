import Foundation
import Combine

class SelectedGroupsStorage: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("groups") public var groupIds: [Int]? {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("selectedGroup") public var selectedGroupId: Int? {
        didSet {
            objectWillChange.send()
        }
    }
}
