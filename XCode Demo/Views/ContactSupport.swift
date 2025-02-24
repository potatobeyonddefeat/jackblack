import SwiftUI

struct ContactSupport: View {
    @Binding var isDarkMode: Bool
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var isSubmitted: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Contact Support")
                .font(.largeTitle)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()

            TextField("Name", text: $name)
                .padding()
                .background(isDarkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(isDarkMode ? .white : .black)

            TextField("Email", text: $email)
                .padding()
                .background(isDarkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(isDarkMode ? .white : .black)

            TextEditor(text: $message)
                .frame(height: 150)
                .padding()
                .background(isDarkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(isDarkMode ? .white : .black)

            Button(action: {
                // Handle form submission
                isSubmitted = true
            }) {
                Text("Submit")
                    .font(.title2)
                    .padding()
                    .background(isDarkMode ? Color.blue.opacity(0.8) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(name.isEmpty || email.isEmpty || message.isEmpty)

            if isSubmitted {
                Text("Thank you for contacting support!")
                    .font(.title2)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
    }
}