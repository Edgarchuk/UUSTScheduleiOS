
import Foundation
import SwiftUI

struct GroupSelectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var searchText: String = ""
    @EnvironmentObject var groupsStorage: GroupsStorageViewModel
    @State var groups: [API.Group]?
    
    let onSelect: (API.Group.Id) -> ()
    
    var body: some View {
        VStack {
            if groups != nil {
                List(searchResult) { group in
                    Button(group.title) {
                        onSelect(group.id)
                        dismiss()
                    }
                }
                .searchable(text: $searchText)
            } else {
                Spacer()
                    .task {
                        await groupsStorage.update()
                        groups = groupsStorage.groups
                    }
            }
        }.background(Color.secondarySystemBackground)
            .navigationTitle("Добавление группы")
    }
    
    var searchResult: [API.Group] {
        guard let groups = groups else {
            return []
        }
        if searchText.isEmpty {
            return groups
        } else {
            return groups.filter({$0.title.lowercased().contains(searchText.lowercased())})
        }
    }
}

struct GroupSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelectView(onSelect: {_ in })
    }
}
