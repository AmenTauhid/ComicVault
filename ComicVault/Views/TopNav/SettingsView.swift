//
//  SettingsView.swift
//  ComicVault
//
//  Group 10
//
//  Created by Elias Alissandratos on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("App Settings")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: LaunchView().navigationBarBackButtonHidden(true)) {
                    Text("Log Out")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
