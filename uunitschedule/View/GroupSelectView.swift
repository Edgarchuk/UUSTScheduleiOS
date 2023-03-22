
import Foundation
import SwiftUI

struct GroupSelectView: View {
    @State var searchText: String = ""
    
    @State var groups: [API.Group]?
    @EnvironmentObject var groupsStorage: SelectedGroupsStorage
    
    var body: some View {
        VStack {
            if groups != nil {
                TextField("Search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(Color.systemBackground)
                    .cornerRadius(20)
                    .padding([.leading, .trailing])
                List(searchResult) { group in
                    Button(group.title) {
                        groupsStorage.groupIds = [group.id]
                    }
                }
            } else {
                Spacer()
                    .task {
                        groups = try? await API.getGroups()
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
            return groups.filter({$0.title.contains(searchText)})
        }
    }
}

struct GroupSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelectView()
    }
}
