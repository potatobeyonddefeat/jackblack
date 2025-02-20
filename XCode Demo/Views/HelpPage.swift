import SwiftUI

struct HelpPage: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack {
            Text("Help Page")
                .font(.largeTitle)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Text("Welcome to Blackjack! Here are some tips to get started:")
                .font(.title2)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Text("1. The goal is to get as close to 21 as possible without going over.")
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Text("2. You can 'Hit' to draw a new card or 'Stand' to keep your current hand.")
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Text("3. The dealer must draw until they reach at least 17.")
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
    }
}
