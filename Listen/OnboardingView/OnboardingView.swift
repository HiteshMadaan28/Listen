import SwiftUI

struct OnboardingView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var showValidation: Bool = false
    var onComplete: ((String, String) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            // App Welcome
            VStack(spacing: 12) {
                Image(systemName: "book.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                Text("Welcome to Listen")
                    .font(.largeTitle).bold()
                Text("Your private space for mindful journaling, mood tracking, and self-reflection.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            // User Details Form
            VStack(spacing: 16) {
                TextField("Full Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
            }
            if showValidation && (name.isEmpty || email.isEmpty) {
                Text("Please enter your name and email to continue.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            // Continue Button
            Button(action: {
                if name.isEmpty || email.isEmpty {
                    showValidation = true
                } else {
                    onComplete?(name, email)
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
} 