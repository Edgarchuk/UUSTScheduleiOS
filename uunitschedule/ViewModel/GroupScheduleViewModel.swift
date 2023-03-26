import Foundation
import Combine

class GroupScheduleViewModel: ObservableObject {
    enum State {
        case loading
        case error
        case schedule(schedule: [API.ScheduleDay])
    }
    
    @Published private(set) var state: State = .loading
    
    private let scheduleStorage = GroupsScheduleStorage()
    
    func loadSchedule(for id: API.Group.Id) async {
        try? await scheduleStorage.update(for: id)
        if let schedule = try? scheduleStorage.get(for: id) {
            DispatchQueue.main.async {
                self.state = .schedule(schedule: schedule)
            }
            return
        }
        DispatchQueue.main.async {
            self.state = .error
        }
    }
}
