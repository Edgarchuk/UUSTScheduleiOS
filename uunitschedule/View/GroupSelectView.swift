
import Foundation
import SwiftUI

struct GroupSelectView: View {
    @State var searchText: String = ""
    
    @State var groups: [API.Group]?
    
    var body: some View {
        NavigationStack {
            if groups != nil {
                List(searchResult) { group in
                    Text(group.title)
                }
                .searchable(text: $searchText)
            } else {
                Spacer()
                    .task {
                        groups = try? await API.getGroups()
                    }
            }
        }
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
