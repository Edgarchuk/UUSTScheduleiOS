
import Foundation
import SwiftUI

struct SchedulePageView: View {
    @State var test = 1...100
    let days: [SchoolDay] = [
        SchoolDay(dayWeek: "Понедельник", lessons: [
            .init(name: "Тест1", audience: "Тест", timeStart: "8:00", timeEnd: "9:35", type: "Лекция", professor: "Test"),
            .init(name: "Тест2", audience: "Тест", timeStart: "9:40", timeEnd: "11:20", type: "Лекция", professor: "Test")
        ]),
        SchoolDay(dayWeek: "Вторник", lessons: [
            .init(name: "Тест2", audience: "Тест", timeStart: "8:00", timeEnd: "9:35", type: "Лекция", professor: "Test")
        ]),
        SchoolDay(dayWeek: "Стреда", lessons: [
            .init(name: "Тест3", audience: "Тест", timeStart: "8:00", timeEnd: "9:35", type: "Лекция", professor: "Test")
        ])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Grid {
                        GridRow {
                            Image(systemName: "person.3.fill")
                            Text("Selected study group:")
                                .font(.title2)
                        }
                        GridRow {
                            Spacer()
                            Text("ПРО-426")
                                .font(.title)
                        }
                    }
                    .padding([.top, .bottom, .leading])
                    Spacer()
                }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(20)
                    .padding(.bottom)
                
                HStack {
                    Image(systemName: "arrow.left")
                        .padding(.leading)
                    Spacer()
                    VStack {
                        Text("Весенний семестр 2022/2023")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("Неделя 27")
                            .font(.title)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .padding(.trailing)
                }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(20)
                    .padding(.bottom)
                ScheduleView(days: days)
            }.padding(20)
        }.background(Color.systemBackground)
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
    }
}
