//
//  AuthViewModel.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-12-04.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = (user != nil)
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle error - You might want to use a published property to display error messages
                print("Login error: \(error.localizedDescription)")
            } else {
                // Update authentication state
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                }
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle error - You might want to use a published property to display error messages
                print("Sign up error: \(error.localizedDescription)")
            } else {
                // Update authentication state
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                }
            }
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

