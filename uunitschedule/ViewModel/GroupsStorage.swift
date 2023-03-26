import Foundation
import Combine

class GroupsStorageViewModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    let storage = GroupListStorage()
    
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
    
    @Published private(set) var groups: [API.Group]?
    
    func update() async {
        try? await storage.update()
        self.groups = try? storage.get()
    }
    
    var selectedGroup: API.Group? {
        guard let selectedGroupId = selectedGroupId else { return nil }
        return groups?.first(where: {$0.id == selectedGroupId})
    }
}
