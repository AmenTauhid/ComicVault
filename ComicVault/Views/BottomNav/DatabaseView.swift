//
//  DatabaseView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//
import SwiftUI

struct DatabaseView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var isEditingComic = false
    @State private var selectedComic: Comic?
    
    var body: some View {
        List {
            ForEach(firestoreManager.comics) { comic in
                HStack {
                    VStack(alignment: .leading) {
                        Text(comic.name).font(.headline)
                        Text("Issue: \(comic.issueNumber)")
                        Text("Year: \(comic.releaseYear)")
                    }
                    
                    Spacer()
                    
                    Button("Edit") {
                        self.selectedComic = comic
                        self.isEditingComic = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(alignment: .trailing)
                }
            }
            .onDelete(perform: deleteComic)
        }
        .sheet(isPresented: $isEditingComic) {
            if let selectedComic = selectedComic {
                ComicDetailView(firestoreManager: firestoreManager, comic: selectedComic)
            }
        }
        .navigationBarTitle("My Comics")
    }

    private func deleteComic(at offsets: IndexSet) {
        offsets.forEach { index in
            let comic = firestoreManager.comics[index]
            firestoreManager.deleteComic(comic) { _ in }
        }
    }
}
