import SwiftUI
import MultipeerConnectivity

class GameViewModel: ObservableObject {
    @Published var playerHand: [String] = []
    @Published var dealerHand: [String] = []
    @Published var deck: [String] = []
    @Published var gameOver: Bool = false
    @Published var playerScore: Int = 0
    @Published var dealerScore: Int = 0
    @Published var message: String = ""

    // Multipeer manager for syncing card data
    var multipeerManager: MultipeerManager?

    // Initialize the game
    init() {
        resetGame()
    }

    // Reset the game state
    func resetGame() {
        deck = createDeck()
        playerHand = []
        dealerHand = []
        playerScore = 0
        dealerScore = 0
        gameOver = false
        message = ""

        // Deal initial cards
        playerHand.append(drawCard())
        dealerHand.append(drawCard())
        playerHand.append(drawCard())
        dealerHand.append(drawCard())

        updateScores()
    }

    // Player draws a card
    func hit() {
        playerHand.append(drawCard())
        updateScores()
        if playerScore > 21 {
            gameOver = true
            message = "Bust! You lose."
        }
        syncCards() // Sync updated player hand with other peers
    }

    // Player stands, dealer draws cards
    func stand() {
        while dealerScore < 17 {
            dealerHand.append(drawCard())
            updateScores()
        }
        gameOver = true
        determineWinner()
        syncCards() // Sync final game state with other peers
    }

    // Draw a card from the deck
    func drawCard() -> String {
        return deck.removeLast()
    }

    // Update player and dealer scores
    func updateScores() {
        let newPlayerScore = calculateScore(for: playerHand)
        let newDealerScore = calculateScore(for: dealerHand)
        
        withAnimation(.easeInOut(duration: 1.0)) {
            playerScore = newPlayerScore
            dealerScore = newDealerScore
        }
    }

    // Calculate the score for a hand
    func calculateScore(for hand: [String]) -> Int {
        var score = 0
        var aceCount = 0
        for card in hand {
            let value = String(card.dropLast())
            if value == "A" {
                aceCount += 1
                score += 11
            } else if value == "J" || value == "Q" || value == "K" {
                score += 10
            } else {
                score += Int(value) ?? 0
            }
        }
        while score > 21 && aceCount > 0 {
            score -= 10
            aceCount -= 1
        }
        return score
    }

    // Determine the winner
    func determineWinner() {
        if playerScore > 21 {
            message = "Bust! You lose."
        } else if dealerScore > 21 {
            message = "Dealer busts! You win."
        } else if playerScore > dealerScore {
            message = "You win!"
        } else if playerScore < dealerScore {
            message = "You lose."
        } else {
            message = "It's a tie."
        }
    }

    // Create a shuffled deck of cards
    func createDeck() -> [String] {
        let suits = ["H", "D", "C", "S"]
        let values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
        var deck: [String] = []
        for suit in suits {
            for value in values {
                deck.append("\(value)\(suit)")
            }
        }
        return deck.shuffled()
    }

    // Sync card data with other players
    func syncCards() {
        guard let multipeerManager = multipeerManager else { return }

        // Create a dictionary to send player and dealer hands
        let cardData: [String: Any] = [
            "playerHand": playerHand,
            "dealerHand": dealerHand,
            "playerScore": playerScore,
            "dealerScore": dealerScore,
            "message": message
        ]

        // Encode and send the data
        if let data = try? JSONSerialization.data(withJSONObject: cardData, options: .fragmentsAllowed) {
            multipeerManager.send(data: data)
        }
    }

    // Handle received card data from other peers
    func handleReceivedCardData(_ data: Data) {
        if let cardData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            DispatchQueue.main.async {
                if let playerHand = cardData["playerHand"] as? [String] {
                    self.playerHand = playerHand
                }
                if let dealerHand = cardData["dealerHand"] as? [String] {
                    self.dealerHand = dealerHand
                }
                if let playerScore = cardData["playerScore"] as? Int {
                    self.playerScore = playerScore
                }
                if let dealerScore = cardData["dealerScore"] as? Int {
                    self.dealerScore = dealerScore
                }
                if let message = cardData["message"] as? String {
                    self.message = message
                }
            }
        }
    }
}
