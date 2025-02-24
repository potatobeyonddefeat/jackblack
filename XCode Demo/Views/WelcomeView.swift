import SwiftUI

struct WelcomeView: View {
    @Binding var isFirstLaunch: Bool
    @State private var showWelcomeMessage: Bool = true
    @State private var fadeOut: Bool = false

    var body: some View {
        ZStack {
            // Background color
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                if showWelcomeMessage {
                    Text(isFirstLaunch ? "Welcome" : "Welcome Back")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .opacity(fadeOut ? 0 : 1) // Fade out animation
                        .animation(.easeInOut(duration: 1), value: fadeOut)
                }
            }
        }
        .onAppear {
            // Start the fade-out animation after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    fadeOut = true
                }
            }

            // Transition to the main game after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showWelcomeMessage = false
                    isFirstLaunch = false // Mark the app as launched
                    UserDefaults.standard.set(false, forKey: "isFirstLaunch") // Save the flag
                }
            }
        }
    }
}