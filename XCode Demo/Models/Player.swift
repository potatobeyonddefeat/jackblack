import Foundation

struct Player: Identifiable {
    let id: String
    let name: String
    var cards: [String]
    var score: Int
}
