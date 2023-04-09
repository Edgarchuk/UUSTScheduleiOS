import Foundation
import SwiftUI

struct ExamsView: View {
    @EnvironmentObject var groupsSchedule: GroupScheduleViewModel
    
    var body: some View {
        ScrollView {
            ScheduleView(schedule: groupsSchedule.exams)
                .padding()
        }
        .background(Color.systemBackground)
            .navigationBarTitle("Экзамены")
    }
}

struct ExamsView_Previews: PreviewProvider {
    static var groupsScheduleStorage = GroupScheduleViewModel(scheduleDelegate: GroupSchedule())
    static var previews: some View {
        ExamsView()
            .environmentObject(groupsScheduleStorage)
    }
}
