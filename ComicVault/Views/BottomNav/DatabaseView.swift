//
//  DatabaseView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct DatabaseView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var comics: [Comic] = []
    @State private var isEditingComic = false
    @State private var selectedComic: Comic?
    
    var body: some View {
        List {
            ForEach(comics) { comic in
                VStack(alignment: .leading) {
                    Text(comic.name).font(.headline)
                    Text("Issue: \(comic.issueNumber)")
                    Text("Year: \(comic.releaseYear)")
                    HStack {
                        Button("Edit") {
                            self.selectedComic = comic
                            self.isEditingComic = true
                        }
                        Button("Delete") {
                            firestoreManager.deleteComic(comic) { result in
                                switch result {
                                case .success():
                                    // Remove the comic from the local array to update the UI
                                    if let index = self.comics.firstIndex(where: { $0.id == comic.id }) {
                                        self.comics.remove(at: index)
                                    }
                                    print("Comic deleted successfully")
                                case .failure(let error):
                                    print("Error deleting comic: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
            .onDelete(perform: deleteComic)
        }
        .sheet(isPresented: $isEditingComic) {
                    if let selectedComic = selectedComic {
                        ComicDetailView(comic: selectedComic, firestoreManager: firestoreManager)
                    }
                }
        .onAppear {
            firestoreManager.fetchComics { result in
                switch result {
                case .success(let fetchedComics):
                    self.comics = fetchedComics
                case .failure(let error):
                    print("Error fetching comics: \(error.localizedDescription)")
                    // Handle error
                }
            }
        }
        .navigationBarTitle("My Comics")
    }

    private func deleteComic(at offsets: IndexSet) {
        offsets.forEach { index in
            let comic = comics[index]
            firestoreManager.deleteComic(comic) { _ in }
        }
    }
}
