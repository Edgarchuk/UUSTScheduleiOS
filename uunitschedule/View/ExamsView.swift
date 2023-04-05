import Foundation
import SwiftUI

struct ExamsView: View {
    @EnvironmentObject var groupsSchedule: GroupScheduleViewModel
    
    var body: some View {
        List {
            ForEach(groupsSchedule.exams, id: \.self) { row in
                VStack {
                    HStack {
                        Text(row.localizedDay)
                            .font(.caption)
                        Spacer()
                    }
                    HStack(alignment: .top) {
                        VStack(spacing: 5) {
                            Text("\(row.index)")
                                .foregroundColor(Color.white)
                                .background(
                                    Circle()
                                        .foregroundColor(.green)
                                        .frame(width: 30, height: 30)
                                )
                            Text(row.formattedStartTime)
                                .font(.title3)
                            Text(row.formattedEndTime)
                                .font(.caption)
                        }
                        .frame(width: 80)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(row.type)")
                                .font(.title2)
                                .padding([.leading, .trailing])
                                .background(Color.tertiarySystemBackground)
                                .cornerRadius(20)
                            Text(row.scheduleSubjectTitle)
                                .font(.title3)
                            Text(row.teacher)
                                .font(.caption)
                            Text(row.roomTitle)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct ExamsView_Previews: PreviewProvider {
    static var groupsScheduleStorage = GroupScheduleViewModel(scheduleDelegate: GroupSchedule())
    static var previews: some View {
        ExamsView()
            .environmentObject(groupsScheduleStorage)
    }
}
