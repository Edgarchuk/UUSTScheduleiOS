import Foundation
import SwiftUI

struct StartPageView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                VStack {
                    viewWithImage(name: "wifi.slash", text: "Получайте свежую информацию, даже когда нет доступа к интернету")
                    viewWithImage(name: "person.crop.rectangle.stack", text: "Быстро переключайтесь между расписанием разных групп")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.systemBackground)
                }
                .padding([.leading, .trailing])
                NavigationLink {
                    GroupSelectView()
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
