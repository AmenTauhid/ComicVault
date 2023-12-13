//
//  PriceListView.swift
//  ComicVault
//
//  Created by Omar Al-Dulaimi on 2023-12-6.
//

import SwiftUI

struct DatabaseView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var selectedComic: Comic?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("    Total Comics: \(firestoreManager.comics.count)")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.gray)

                List {
                    ForEach(firestoreManager.comics.indices, id: \.self) { index in
                        NavigationLink(destination: ComicDetailView(firestoreManager: firestoreManager, comic: firestoreManager.comics[index])) {
                            ComicRow(comic: firestoreManager.comics[index], firestoreManager: firestoreManager, index: index + 1)
                        }
                    }
                    .onDelete(perform: deleteComic)
                }
            }
            .background(Color(red: 70/255, green: 96/255, blue: 115/255))
            .navigationBarItems(leading:
                Text("My Comics")
                    .font(.system(.title, design: .serif))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            )
        }
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
    var firestoreManager: FirestoreManager
    var index: Int
    
    var body: some View {
        HStack {
            Text(" \(index) ")
                .font(.headline)
                .padding(5)
                .foregroundColor(.white)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("\(comic.name)")
                    .font(.headline)
                Text("Issue: \(comic.issueNumber)")
                Text("Year: \(comic.releaseYear)")
                if let price = comic.price {
                    Text("Price: $\(price, specifier: "%.2f")")
                } else {
                    Text("Price: N/A")
                }
            }
            .foregroundColor(.black)
            .padding(.vertical, 5)
            Spacer()
            EmptyView()
        }
        .background(rowColor(for: index))
        .cornerRadius(10)
    }
    
    private func rowColor(for index: Int) -> Color {
        let colors: [Color] = [Color(red: 247/255, green: 227/255, blue: 121/255), Color(red: 130/255, green: 180/255, blue: 206/255), Color(red: 236/255, green: 107/255, blue: 102/255)]
        return colors[index % colors.count]
    }
}
