import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("Login successful!"))
            }
        }
    }
}

struct LoginView: View {
    @Binding var rootView: RootView

    @StateObject var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isPasswordValid = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: password) { newPassword in
                        isPasswordValid = isValidPassword(newPassword)
                    }
                    .background(isPasswordValid ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    .cornerRadius(8)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Login") {
                    if isValidEmail(email) && isPasswordValid {
                        viewModel.login(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                self.rootView = .main
                            case .failure(let error):
                                errorMessage = "Error: \(error.localizedDescription)"
                            }
                        }
                    } else {
                        errorMessage = "Invalid email or password"
                    }
                }
                .padding()
                .disabled(!isPasswordValid)

                Button("Don't have an account? Sign up now.") {
                    self.rootView = .signup
                }
                .padding()
            }
            .padding()
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@(hotmail|gmail|outlook)\\.[a-zA-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-\\?])[A-Za-z0-9!@#$%^&*()_+\\-\\?]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
