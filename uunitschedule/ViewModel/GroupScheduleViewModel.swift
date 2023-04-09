import Foundation
import Combine

class GroupScheduleViewModel: ObservableObject {
    enum State {
        case loading
        case error(errorResult: String)
        case schedule
    }
    
    @Published private(set) var state: State = .loading
    @Published var currentWeek: Int?
    @Published private(set) var schedule: [ScheduleDay] = []
    @Published private(set) var exams: [ScheduleDay] = []
    
    private let scheduleDelegate: GroupScheduleDelegate
    
    init(scheduleDelegate: GroupScheduleDelegate) {
        self.scheduleDelegate = scheduleDelegate
    }
    
    func reload() {
        state = .loading
    }
    
    func updateSchedule(with schedule: [ScheduleDay]) {
        guard let currentWeek = currentWeek else { return }
        let tmp = schedule.map({ day in
            ScheduleDay(weekDay: day.weekDay, schedule: day.schedule.filter({
                $0.scheduleWeek == currentWeek
            }))
        }).filter({$0.schedule.count > 0})
        DispatchQueue.main.async {
            self.schedule = tmp
        }
        
        var tmpExams = schedule.map({ day in
            ScheduleDay(weekDay: day.weekDay, schedule: day.schedule.filter({
                $0.type == "Экзамен" || $0.type == "Консультация"
            }))
        }).filter({$0.schedule.count > 0})
        
        DispatchQueue.main.async {
            self.exams = tmpExams
        }
    }
    
    func loadSchedule(for id: API.Group.Id) async {
        await loadCurrentWeek()
        do {
            try await scheduleDelegate.load(for: id)
            let schedule = try scheduleDelegate.get(for: id)
            DispatchQueue.main.async {
                self.state = .schedule
            }
            updateSchedule(with: schedule)
        } catch(let error) {
            DispatchQueue.main.async {
                self.state = .error(errorResult: error.localizedDescription)
            }
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
