//
//  RoomCodeView.swift
//  XCode Demo
//
//  Created by Jasper Dragoo on 2/20/25.
//


import SwiftUI

struct RoomCodeView: View {
    @ObservedObject var roomCodeManager: RoomCodeManager
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var enteredCode: String = ""

    var body: some View {
        VStack(spacing: 20) {
            if roomCodeManager.isHost {
                Text("Room Code: \(roomCodeManager.roomCode)")
                    .font(.largeTitle)
                    .padding()
            } else {
                TextField("Enter Room Code", text: $enteredCode)
                    .font(.title)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            Button(action: {
                if roomCodeManager.isHost {
                    multipeerManager.startHosting(roomCode: roomCodeManager.roomCode)
                } else {
                    if roomCodeManager.validateRoomCode(enteredCode) {
                        multipeerManager.startBrowsing(roomCode: enteredCode)
                    }
                }
            }) {
                Text(roomCodeManager.isHost ? "Start Game" : "Join Game")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}