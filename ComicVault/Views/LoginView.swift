//
//  HomeView.swift
//  ComicVault
//
//  Created by Omar Al-Dulaimi, Ayman Tauhid & Elias Alissandratos on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

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
        ZStack {
            ZStack {
                Color(red: 70/255, green: 96/255, blue: 115/255) //Dark Grey/Blue
                    .frame(maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    Color(red: 70/255, green: 96/255, blue: 115/255) //Dark Grey/Blue
                        .frame(maxHeight: .infinity / 2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Color(red: 130/255, green: 180/255, blue: 206/255) //Mid Blue/Grey
                            .frame(height: 300)
                            .rotationEffect(.degrees(-10))
                            .offset(x: -50)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                        
                        Color(red: 236/255, green: 107/255, blue: 102/255) //Light Red
                            .frame(height: 300)
                            .rotationEffect(.degrees(-10))
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                        
                        Color(red: 247/255, green: 227/255, blue: 121/255) //Yellow
                            .frame(height: 300)
                            .rotationEffect(.degrees(-10))
                            .offset(x: 50)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 5)
                    }
                }
            }

            VStack(alignment: .leading) {
                Spacer()
                Text("Welcome to ComicVault!")
                    .font(.system(size: 26, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .offset(y: -10)
                    .shadow(radius: 5)
                Text("Sign In to your account")
                    .font(.system(size: 16, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .offset(y: -10)
                    .shadow(radius: 5)

                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)

                    SecureField("Password", text: $password)
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                        .onChange(of: password) { newPassword in
                            isPasswordValid = isValidPassword(newPassword)
                        }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
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
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 231/255, green: 243/255, blue: 254/255))
                    .padding()
                    .frame(width: 200)
                    .background(Color(red: 70/255, green: 96/255, blue: 115/255))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(!isPasswordValid)

                    Button(action: {
                        self.rootView = .signup
                    }) {
                        Text("Don't have an account? ")
                            .foregroundColor(Color.black)
                        +
                        Text("Sign up now.")
                            .foregroundColor(Color(red: 70/255, green: 96/255, blue: 115/255))
                    }
                    .padding()
                }
                .padding()

                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .offset(y: -50)
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
