import SwiftUI

struct AnimatedNumberText: View {
    var value: Int
    var isDarkMode: Bool
    @State private var currentValue: Int = 0

    var body: some View {
        Text("\(currentValue)")
            .font(.title2)
            .foregroundColor(isDarkMode ? .white : .black)
            .onChange(of: value) { newValue in
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentValue = newValue
                }
            }
            .onAppear {
                currentValue = value
            }
    }
}
