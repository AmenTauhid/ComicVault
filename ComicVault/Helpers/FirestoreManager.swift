//
//  FirestoreHelper.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    @Published var comics: [Comic] = []
    private let db = Firestore.firestore()
    private let ebayAPIManager = EbayAPIManager()
    
    init() {
            subscribeToComicsCollection()
        }

    // Subscribe to the comics collection for real-time updates
    private func subscribeToComicsCollection() {
        db.collection("comics").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'comics' collection")
                return
            }
            self?.comics = documents.compactMap { document -> Comic? in
                try? document.data(as: Comic.self)
            }
        }
    }
    
    //TODO: Doesn't work properly, need fixing...
    // Function to add comic with eBay price
    func addComicWithPrice(name: String, issueNumber: String, releaseYear: String, completion: @escaping (Result<Void, Error>) -> Void) {
        ebayAPIManager.fetchEbaySearchResults(forComicName: name, issueNumber: issueNumber, releaseYear: releaseYear) { result in
            switch result {
            case .success(let price):
                let comic = Comic(name: name, issueNumber: issueNumber, releaseYear: releaseYear, price: price)
                self.addComic(comic, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Function to add comic to Firestore
    func addComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection("comics").document(comic.id).setData(from: comic) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    // Fetch comics from Firestore
    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        db.collection("comics").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let comics = snapshot?.documents.compactMap { document -> Comic? in
                try? document.data(as: Comic.self)
            } ?? []

            completion(.success(comics))
        }
    }

    // Update comic in Firestore
    func updateComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("comics").document(comic.id).setData(from: comic) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    // Delete comic from Firestore
    func deleteComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("comics").document(comic.id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

