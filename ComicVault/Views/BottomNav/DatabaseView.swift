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
        ZStack(alignment: .top) {
            Color(red: 70/255, green: 96/255, blue: 115/255) // Dark Grey/Blue

            VStack {
                Text("My Comics")
                    .font(.system(size: 36, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue

                List {
                    ForEach(comics) { comic in
                        VStack(alignment: .leading) {
                            Text(comic.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Issue: \(comic.issueNumber)")
                            Text("Year: \(comic.releaseYear)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .onDelete(perform: deleteComic)
                }
                .listStyle(PlainListStyle())
            }
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
        .edgesIgnoringSafeArea(.bottom)
    }

    private func deleteComic(at offsets: IndexSet) {
        offsets.forEach { index in
            let comic = comics[index]
            firestoreManager.deleteComic(comic) { _ in }
        }
    }
}

