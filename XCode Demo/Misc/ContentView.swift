import SwiftUI

struct ContentView: View {
    @StateObject private var roomCodeManager = RoomCodeManager()
    @StateObject private var multipeerManager = MultipeerManager()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var showPartyView: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // Main game view
                GameView(gameViewModel: gameViewModel, multipeerManager: multipeerManager, isHost: roomCodeManager.isHost, playerName: UIDevice.current.name)

                // Party button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showPartyView = true // Show the party view
                        }) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 24))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .sheet(isPresented: $showPartyView) {
                // Show the party view as a sheet
                PartyView(roomCodeManager: roomCodeManager, multipeerManager: multipeerManager)
            }
            .onChange(of: multipeerManager.isConnected) { isConnected in
                if isConnected {
                    gameViewModel.multipeerManager = multipeerManager // Connect GameViewModel to MultipeerManager
                }
            }
        }
    }
}
