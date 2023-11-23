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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Comic Details")) {
                TextField("Name", text: $comic.name)
                TextField("Issue Number", text: $comic.issueNumber)
                TextField("Release Year", text: $comic.releaseYear)
            }

            Button("Save Changes") {
                firestoreManager.updateComic(comic) { result in
                    switch result {
                    case .success():
                        self.presentationMode.wrappedValue.dismiss()
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
