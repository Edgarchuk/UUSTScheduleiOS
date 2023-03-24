import Foundation
import SwiftUI

struct ScheduleView: View {
    @State var days: [API.ScheduleRow]
    
    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(days, id: \.self) { day in
                    HStack {
                        Text(day.)
                            .font(.title)
                        Spacer()
                    }
                    
                    ForEach(day.lessons, id: \.self) { lesson in
                        HStack {
                            Grid {
                                GridRow {
                                    Text("1")
                                        .background(Circle()
                                            .foregroundColor(.green)
                                            .frame(width: 30, height: 30))
                                    Text(lesson.type)
                                        .font(.title2)
                                        .padding(5)
                                        .background(Color.tertiarySystemBackground)
                                        .cornerRadius(20)
                                    
                                }
                                GridRow {
                                    Text(lesson.timeStart)
                                        .font(.title)
                                    Text(lesson.name)
                                        .font(.title)
                                }
                                GridRow {
                                    Text(lesson.timeEnd)
                                        .font(.title3)
                                    HStack {
                                        Image(systemName: "person.fill")
                                        Text(lesson.professor)
                                            .font(.title3)
                                    }
                                }
                                GridRow {
                                    VStack{}
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.secondarySystemBackground)
                        .cornerRadius(20)
                    }
                }
            } header: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(days, id: \.self) { day in
                            Button {
                                
                            } label: {
                                Text(day.dayWeek)
                                    .tag(day.dayWeek)
                            }.buttonStyle(.bordered)
                        }
                    }
                }
                .padding([.top, .bottom])
                .background(Color.systemBackground)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
    }
}
