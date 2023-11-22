//
//  ComicDetailView.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//

import SwiftUI

struct ComicDetailView: View {
    @ObservedObject var firestoreManager: FirestoreManager
    @State var comic: Comic
    @State private var name: String
    @State private var issueNumber: String
    @State private var releaseYear: String
    @Environment(\.presentationMode) var presentationMode

    init(comic: Comic, firestoreManager: FirestoreManager) {
        _comic = State(initialValue: comic)
        _name = State(initialValue: comic.name)
        _issueNumber = State(initialValue: comic.issueNumber)
        _releaseYear = State(initialValue: comic.releaseYear)
        self.firestoreManager = firestoreManager
    }

    var body: some View {
        Form {
            Section(header: Text("Comic Details")) {
                TextField("Name", text: $name)
                TextField("Issue Number", text: $issueNumber)
                TextField("Release Year", text: $releaseYear)
            }

            Button("Save Changes") {
                let updatedComic = Comic(id: comic.id, name: name, issueNumber: issueNumber, releaseYear: releaseYear)
                firestoreManager.updateComic(updatedComic) { result in
                    switch result {
                    case .success():
                        self.presentationMode.wrappedValue.dismiss()
                        // Optionally update the local comics array in firestoreManager
                    case .failure(let error):
                        print("Error updating comic: \(error.localizedDescription)")
                        // Handle error
                    }
                }
            }
        }
        .navigationBarTitle("Edit Comic", displayMode: .inline)
    }
}
