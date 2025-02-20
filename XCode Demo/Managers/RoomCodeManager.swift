import Foundation

class RoomCodeManager: ObservableObject {
    @Published var roomCode: String = ""
    @Published var isHost: Bool = false

    // Generate a 4-digit room code
    func generateRoomCode() {
        roomCode = String(format: "%04d", Int.random(in: 0..<10000))
        isHost = true
    }

    // Validate if the entered room code is valid (4 digits)
    func validateRoomCode(_ code: String) -> Bool {
        return code.count == 4 && code.allSatisfy({ $0.isNumber })
    }
}
