import SwiftUI

struct DarkModeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "moon.fill" : "sun.max.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .white : .black)
                .padding(8)
                .background(configuration.isOn ? Color.blue : Color.yellow)
                .clipShape(Circle())
                .onTapGesture {
                    withAnimation {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
