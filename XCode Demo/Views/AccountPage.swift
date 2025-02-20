import SwiftUI

struct AccountPage: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack {
            Text("Account Page")
                .font(.largeTitle)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            Text("Sign in with your Apple ID to save your progress.")
                .font(.title2)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            // Add Apple Sign In Button Here
            Button(action: {
                // Handle Apple Sign In
            }) {
                Text("Sign in with Apple")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
    }
}
