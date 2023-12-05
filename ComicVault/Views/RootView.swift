//
//  RootView.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-12-04.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if authViewModel.isAuthenticated {
                HomeView() // Your authenticated home view
            } else {
                LoginView() // Your login view
            }
        }
    }
}

