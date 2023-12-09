//
//  PriceListView.swift
//  ComicVault
//
//  Created by Omar Al-Dulaimi on 2023-12-6.
//

import SwiftUI

struct DatabaseView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var isEditingComic = false
    @State private var selectedComic: Comic?
    
    var body: some View {
        List {
            ForEach(firestoreManager.comics) { comic in
                ComicRow(comic: comic)
            }
            .onDelete(perform: deleteComic)
        }
        .sheet(isPresented: $isEditingComic) {
            if let selectedComic = selectedComic {
                ComicDetailView(firestoreManager: firestoreManager, comic: selectedComic)
            }
        }
        .navigationTitle("My Comics")
    }

    private func deleteComic(at offsets: IndexSet) {
        offsets.forEach { index in
            let comic = firestoreManager.comics[index]
            firestoreManager.deleteComic(comic) { _ in }
        }
    }
}

struct ComicRow: View {
    let comic: Comic
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(comic.name)
                    .font(.headline)
                Text("Issue: \(comic.issueNumber)")
                Text("Year: \(comic.releaseYear)")
                if let price = comic.price {
                    Text("Price: $\(price, specifier: "%.2f")")
                } else {
                    Text("Price: N/A")
                }
            }
            
            Spacer()
            
            Button("Edit") {
                // Handle edit action
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .frame(alignment: .trailing)
        }
    }
}
