//
//  AddComicView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct AddComicView: View {
    @State private var name: String = ""
    @State private var issueNumber: String = ""
    @State private var releaseYear: String = ""
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Issue Number", text: $issueNumber)
            TextField("Release Year", text: $releaseYear)
            
            Button("Add Comic") {
                let comic = Comic(name: name, issueNumber: issueNumber, releaseYear: releaseYear)
                firestoreManager.addComic(comic) { result in
                    switch result {
                    case .success():
                        alertMessage = "Comic added successfully"
                        showAlert = true
                        
                        // Reset the input fields
                        name = ""
                        issueNumber = ""
                        releaseYear = ""
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Add Comic")
    }
    
}
