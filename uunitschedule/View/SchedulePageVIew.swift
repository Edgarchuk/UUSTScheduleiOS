
import Foundation
import SwiftUI

struct SchedulePageView: View {
    @State var test = 1...100
    
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
                ScheduleView()
            }.padding(20)
        }.background(Color.systemBackground)
        
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
    }
}
