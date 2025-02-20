import Foundation

struct GameMessage: Codable {
    let type: String
    let playerID: String
    let card: String?
    let action: String?
}
