import SwiftUI
import Firebase

class SignUpViewModel: ObservableObject {
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let userId = authResult?.user.uid {
                    self.saveUserDataToFirestore(userId: userId, email: email, completion: completion)
                }
            }
        }
    }

    func saveUserDataToFirestore(userId: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()

        let userData: [String: Any] = [
            "email": email,
            // Add additional user data fields as needed
        ]

        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("User registered successfully!"))
            }
        }
    }
}

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isPasswordValid = false

    var body: some View {
        VStack {
            Spacer()

            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.black)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: password, perform: { newPassword in
                    // Validate password and update UI accordingly
                    isPasswordValid = isValidPassword(newPassword)
                })
                .background(isPasswordValid ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                .cornerRadius(12)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }

            Button("Sign Up") {
                // Perform email and password validation
                if isValidEmail(email) && isPasswordValid {
                    viewModel.signUp(email: email, password: password) { result in
                        switch result {
                        case .success(let message):
                            errorMessage = message
                        case .failure(let error):
                            errorMessage = "Error: \(error.localizedDescription)"
                        }
                    }
                } else {
                    errorMessage = "Invalid email or password"
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(isPasswordValid ? Color.blue : Color.gray)
            .cornerRadius(12)
            .disabled(!isPasswordValid)

            Spacer()
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-\\?])[A-Za-z0-9!@#$%^&*()_+\\-\\?]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
