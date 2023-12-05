//
//  LoginView.swift
//  ComicVault
//
//  Created by Omar Al-Dulaimi on 2023-12-04.
//

import SwiftUI
import Firebase

extension AuthViewModel {
    func saveUserData(email: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(["email": email]) { error in
            completion(error == nil)
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingSignUp = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isShowingSignUp {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Sign Up") {
                    authViewModel.signUp(email: email, password: password)
                }
                .padding()
            } else {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Login") {
                    authViewModel.login(email: email, password: password)
                }
                .padding()
            }

            Button(isShowingSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                isShowingSignUp.toggle()
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle(isShowingSignUp ? "Sign Up" : "Login", displayMode: .inline)
        .padding()
    }
}
