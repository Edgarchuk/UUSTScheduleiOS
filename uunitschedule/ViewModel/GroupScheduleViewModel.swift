import Foundation
import Combine

class GroupScheduleViewModel: ObservableObject {
    enum State {
        case loading
        case error
        case schedule
    }
    
    @Published private(set) var state: State = .loading
    @Published var currentWeek: Int?
    @Published private(set) var schedule: [API.ScheduleDay] = []
    
    private let scheduleStorage = GroupsScheduleStorage()
    
    func reload() {
        state = .loading
    }
    
    func updateSchedule(with schedule: [API.ScheduleDay]) {
        guard let currentWeek = currentWeek else { return }
        let tmp = schedule.map({ day in
            API.ScheduleDay(weekDayId: day.weekDayId, rows: day.rows.filter({
                $0.scheduleWeeks.contains(where: {(Int($0) ?? 0) == currentWeek})
            }))
        }).filter({$0.rows.count > 0})
        DispatchQueue.main.async {
            self.schedule = tmp
        }
    }
    
    func loadSchedule(for id: API.Group.Id) async {
        await loadCurrentWeek()
        try? await scheduleStorage.update(for: id)
        if let schedule = try? scheduleStorage.get(for: id) {
            DispatchQueue.main.async {
                self.state = .schedule
            }
            updateSchedule(with: schedule)
            return
        }
        DispatchQueue.main.async {
            self.state = .error
        }
    }
    
    func loadCurrentWeek() async {
        if let week = try? await API.getCurrentWeek() {
            DispatchQueue.main.async {
                self.currentWeek = week
            }
            UserDefaults.standard.set(week, forKey: "currentWeek")
        } else {
            DispatchQueue.main.async {
                self.currentWeek = UserDefaults.standard.integer(forKey: "currentWeek")
            }
        }
        
    }
}
