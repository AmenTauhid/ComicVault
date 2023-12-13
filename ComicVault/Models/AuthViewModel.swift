//
//  AuthViewModel.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-12-04.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
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

