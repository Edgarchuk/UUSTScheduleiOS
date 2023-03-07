
import Foundation
import SwiftUI

struct GroupSelectView: View {
    @State var groups: [API.Group]?
    
    var body: some View {
        if let groups = groups {
            List(groups) { group in
                Text(group.title)
            }
        } else {
            Spacer()
                .task {
                    groups = try? await API.getGroups()
                    print(groups)
                }
        }
    }
}

struct GroupSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelectView()
    }
}
