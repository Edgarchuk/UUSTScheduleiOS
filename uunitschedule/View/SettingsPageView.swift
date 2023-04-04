import Foundation
import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject var selectedGroups: GroupsStorageViewModel
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    @EnvironmentObject var groupSchedule: GroupScheduleViewModel
    
    var body: some View {
        Form {
            HStack {
                VStack(alignment: .leading) {
                    Text("Расписание УУНиТ")
                        .font(.title2)
                    Text("Объединяя усилия, создаем будущее")
                }
                Spacer()
                Image("iconRound")
            }
            
            Section {
                List {
                    ForEach(selectedGroups.groupIds ?? [], id: \.self) { id in
                        if let group = selectedGroups.getGroup(forId: id) {
                            Button {
                                selectedGroups.selectedGroupId = id
                                groupSchedule.reload()
                            } label: {
                                HStack {
                                    Image(systemName: id == selectedGroups.selectedGroupId ? "circle.fill" : "circle")
                                    Text(group.title)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        } else {
                            Text("Nill")
                        }
                    }.onDelete(perform: deleteItemsId)
                    NavigationLink {
                        GroupSelectView(onSelect: {group in
                            if selectedGroups.groupIds == nil {
                                selectedGroups.groupIds = [group]
                            }
                            selectedGroups.groupIds?.append(group)
                        })
                        .environmentObject(selectedGroups)
                    } label: {
                        Text("Добавить группу")
                    }
                }
            } header: {
                Text("Быстрый выбор учебной группы")
            }
            
            Section {
                Picker("Тема", selection: $colorScheme.colorScheme) {
                    Text("Систамная")
                        .tag(nil as ColorScheme?)
                    Text("Cветлая")
                        .tag(ColorScheme.light as ColorScheme?)
                    Text("Темная")
                        .tag(ColorScheme.dark as ColorScheme?)
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Тема приложения:")
            }
            
            Section {
                List {
                    link(withText: "Telegram-bot с расписанием",
                         andUrl: "https://t.me/uust_bot ")
                    link(withText: "Сайт Уфимского университета",
                         andUrl: "https://uust.ru/")
                    link(withText: "Есть вопросы или предложения?",
                         andUrl: "https://t.me/arpakit")
                }
            } header: {
                Text("Контакты")
            }
            
        }.navigationTitle("Настройки")
    }
    
    @ViewBuilder func link(withText text: String, andUrl url: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .onTapGesture {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                    }
            }
            Spacer()
            Image(systemName: "link")
        }
    }
    
    func deleteItemsId(at offsets: IndexSet) {
        for id in offsets.makeIterator() {
            selectedGroups.filterIds({$0 != selectedGroups.groupIds?[id]})
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var groupsStorage = GroupsStorageViewModel()
    static var colorScheme = ColorSchemeViewModel()
    static var previews: some View {
        NavigationView {
            SettingsPage()
        }
        .environmentObject(groupsStorage)
        .environmentObject(colorScheme)
        .preferredColorScheme(colorScheme.colorScheme)
    }
}
