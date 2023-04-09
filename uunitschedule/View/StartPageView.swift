import Foundation
import SwiftUI

struct StartPageView: View {
    
    @EnvironmentObject var groupsStorage: GroupsStorageViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    Image("iconRound")
                        .frame(width: 40, height: 40)
                        .padding([.trailing])
                    Text("Расписание Уфимского Университета")
                        .font(.largeTitle)
                }
                .padding([.leading, .trailing])
                VStack {
                    viewWithImage(name: "wifi.slash", text: "Получайте свежую информацию, даже когда нет доступа к интернету")
                    viewWithImage(name: "person.crop.rectangle.stack", text: "Быстро переключайтесь между расписанием разных групп")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: Constant.radius)
                        .fill(Color.systemBackground)
                }
                .padding([.leading, .trailing])
                NavigationLink {
                    GroupSelectView(onSelect: {group in
                        groupsStorage.selectedGroupId = group
                        groupsStorage.groupIds = [group]
                    })
                } label: {
                    Text("Выбрать учебную группу")
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding([.leading, .trailing])
                Spacer()
            }
            .ignoresSafeArea()
            .background(Color.secondarySystemBackground)
        }
    }
    
    @ViewBuilder func viewWithImage(
                       @ViewBuilder imageView: () -> Image,
                       @ViewBuilder content: () -> some View )
                       -> some View {
        HStack(alignment: .top, spacing: 20) {
            imageView()
                .resizable()
                .frame(width: 30, height: 30)
            content()
        }
    }
    @ViewBuilder func viewWithImage(name imageSystemName: String,
                                    text: String ) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: imageSystemName)
                .resizable()
                .frame(width: 30, height: 30)
            Text(text)
                .font(.title2)
        }
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
