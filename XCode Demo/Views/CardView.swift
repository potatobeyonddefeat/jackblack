import SwiftUI

struct CardView: View {
    let card: String
    let isDarkMode: Bool
    let isFlipped: Bool
    let cardPack: String
    let delay: Double
    let isDealer: Bool
    
    @State private var flipped: Bool = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Card Back (visible when not flipped)
            if !flipped {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDarkMode ? Color.blue.opacity(0.8) : Color.white)
                    .frame(width: 60, height: 90)
                    .overlay(
                        Image(systemName: "suit.diamond.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(isDarkMode ? .white : .black)
                    )
                    .shadow(radius: 5)
            }
            
            // Card Front (visible when flipped)
            if flipped {
                Text(card)
                    .font(.system(size: 20))
                    .foregroundColor(isDarkMode ? .white : .black)
                    .frame(width: 60, height: 90)
                    .background(isDarkMode ? Color.blue.opacity(0.8) : Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .rotation3DEffect(
            .degrees(flipped ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .offset(y: offset)
        .onChange(of: isFlipped) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    flipped = newValue
                }
            }
        }
        .onAppear {
            // Set initial offset based on whether it's a dealer or player card
            offset = isDealer ? -UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 2
            
            // Animate the card sliding into place
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    offset = 0
                }
            }
            
            // Flip the card after sliding into place
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    flipped = isFlipped
                }
            }
        }
    }
}
