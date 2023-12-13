//
//  HomeView.swift
//  ComicVault
//
//  Created by Omar Al-Dulaimi on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

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
    @Binding var rootView : RootView

    @StateObject var viewModel = SignUpViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isPasswordValid = false

    var body: some View {
        ZStack{
            ZStack {
                Color(red: 70/255, green: 96/255, blue: 115/255) // Dark Grey/Blue
                    .frame(maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Color(red: 70/255, green: 96/255, blue: 115/255) // Dark Grey/Blue
                        .frame(maxHeight: .infinity / 2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Color(red: 130/255, green: 180/255, blue: 206/255) // Mid Blue/Grey
                            .frame(height: 300)
                            .rotationEffect(.degrees(190))
                            .offset(x: 50)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                        
                        Color(red: 236/255, green: 107/255, blue: 102/255) // Light Red
                            .frame(height: 300)
                            .rotationEffect(.degrees(190))
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                        
                        Color(red: 247/255, green: 227/255, blue: 121/255) // Yellow
                            .frame(height: 300)
                            .rotationEffect(.degrees(190))
                            .offset(x: -50)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                    }
                }
            }
            VStack(alignment: .trailing) {
                Spacer()
                Text("Register with ComicVault!")
                    .font(.system(size: 26, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .offset(y: -10)
                    .shadow(radius: 5)
                Text("Create your new account")
                    .font(.system(size: 16, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .offset(y: -10)
                    .shadow(radius: 5)
                VStack {
                    TextField("Yout email address", text: $email)
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)

                    SecureField("Create a password", text: $password)
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                        .onChange(of: password, perform: { newPassword in
                            isPasswordValid = isValidPassword(newPassword)
                        })
                        .background(isPasswordValid ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))

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
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 231/255, green: 243/255, blue: 254/255))
                    .padding()
                    .frame(width: 200)
                    .background(Color(red: 70/255, green: 96/255, blue: 115/255))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(!isPasswordValid)
                    
                    Button(action: {
                        self.rootView = .login
                    }) {
                        Text("Already have an account? ")
                            .foregroundColor(Color.black)
                        +
                        Text("Login now.")
                            .foregroundColor(Color(red: 70/255, green: 96/255, blue: 115/255))
                    }
                    .padding()
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .offset(y: 225)
        }
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
