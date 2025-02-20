import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var multipeerManager: MultipeerManager
    var isHost: Bool
    var playerName: String

    @State private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            // Background color based on dark mode state
            (isDarkMode ? Color.black : Color.white)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top bar with dark mode toggle
                HStack {
                    Spacer()

                    // Dark mode toggle
                    Toggle("", isOn: $isDarkMode)
                        .toggleStyle(DarkModeToggleStyle())
                        .padding(.trailing, 20)
                }
                .padding(.top, 56)
                .background(isDarkMode ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                .edgesIgnoringSafeArea(.top)

                // Main game content
                Spacer()

                VStack(spacing: 20) {
                    // Dealer's hand
                    VStack {
                        HStack {
                            Text("Dealer's Hand (")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : .black)
                            AnimatedNumberText(value: gameViewModel.dealerScore, isDarkMode: isDarkMode)
                                .font(.title2)
                            Text(")")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                        HStack {
                            ForEach(gameViewModel.dealerHand.indices, id: \.self) { index in
                                CardView(card: gameViewModel.dealerHand[index], isDarkMode: isDarkMode, isFlipped: index != 0, cardPack: "Classic", delay: Double(index) * 0.2, isDealer: true)
                                    .transition(.scale)
                            }
                        }
                    }

                    // Player's hand
                    VStack {
                        HStack {
                            Text("Your Hand (")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : .black)
                            AnimatedNumberText(value: gameViewModel.playerScore, isDarkMode: isDarkMode)
                                .font(.title2)
                            Text(")")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                        HStack {
                            ForEach(gameViewModel.playerHand.indices, id: \.self) { index in
                                CardView(card: gameViewModel.playerHand[index], isDarkMode: isDarkMode, isFlipped: true, cardPack: "Classic", delay: Double(index) * 0.2, isDealer: false)
                                    .transition(.scale)
                            }
                        }
                    }

                    // Game message
                    Text(gameViewModel.message)
                        .font(.title)
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding()

                    // Game buttons
                    HStack {
                        Button(action: gameViewModel.hit) {
                            Text("Hit")
                                .font(.title2)
                                .padding()
                                .background(isDarkMode ? Color.blue.opacity(0.8) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(gameViewModel.gameOver)

                        Button(action: gameViewModel.stand) {
                            Text("Stand")
                                .font(.title2)
                                .padding()
                                .background(isDarkMode ? Color.blue.opacity(0.8) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(gameViewModel.gameOver)

                        Button(action: gameViewModel.resetGame) {
                            Text("Reset")
                                .font(.title2)
                                .padding()
                                .background(isDarkMode ? Color.blue.opacity(0.8) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()
            }
        }
    }
}
