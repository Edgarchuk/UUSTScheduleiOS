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
    
    func getGroup(forId id: API.Group.Id) -> API.Group? {
        return groups?.first(where: {$0.id == id})
    }
    
    var selectedGroup: API.Group? {
        guard let selectedGroupId = selectedGroupId else { return nil }
        return getGroup(forId: selectedGroupId)
    }
    
    func filterIds(_ filter: (API.Group.Id) -> Bool) {
        var tmp = groupIds?.filter({filter($0)})
        groupIds = groupIds?.filter({filter($0)})
    }
}
