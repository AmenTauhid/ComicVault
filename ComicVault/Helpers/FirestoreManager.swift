//
//  FirestoreHelper.swift
//  ComicVault
//
//  Group 10
//
//  Created by Ayman Tauhid & Elias Alissandratos on 2023-11-22.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager: ObservableObject {
    @Published var comics: [Comic] = []
    @Published var userEmail: String = ""
    @Published var totalValue: Double = 0.0
    @Published var totalComics: Int = 0
    
    private let db = Firestore.firestore()
    private let ebayAPIManager = EbayAPIManager()

    init() {
        if let userID = Auth.auth().currentUser?.uid {
            subscribeToComicsCollection(userID: userID)
        }
    }

    private func subscribeToComicsCollection(userID: String) {
        db.collection("users").document(userID).addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            if let data = document.data(), let email = data["email"] as? String {
                self?.userEmail = email
            }
        }

        db.collection("users").document(userID).collection("comics").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'comics' collection for user \(userID)")
                return
            }
            
            self?.comics = documents.compactMap { document -> Comic? in
                try? document.data(as: Comic.self)
            }

            // Update total value and total comics
            self?.updateTotalValues()
        }
    }

    private func updateTotalValues() {
        totalComics = comics.count
        totalValue = comics.reduce(0.0) { $0 + ($1.price ?? 0.0) }
    }
    
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
    
    func addComicWithPriceByUPC(upc: String, completion: @escaping (Result<Void, Error>) -> Void) {
        ebayAPIManager.fetchEbaySearchResultsByUPC(upc: upc) { [weak self] result in
            switch result {
            case .success(let averagePrice):
                let comic = Comic(name: "Unknown", issueNumber: "Unknown", releaseYear: "Unknown", price: averagePrice)
                self?.addComic(comic, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        do {
            _ = try db.collection("users").document(userID).collection("comics").document(comic.id).setData(from: comic) { error in
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
    
    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userID).collection("comics").getDocuments { snapshot, error in
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
    
    func updateComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        do {
            try db.collection("users").document(userID).collection("comics").document(comic.id).setData(from: comic) { error in
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
    
    func deleteComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userID).collection("comics").document(comic.id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
