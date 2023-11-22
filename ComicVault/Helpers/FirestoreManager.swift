//
//  FirestoreHelper.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()

    // Add comic to Firestore
    func addComic(_ comic: Comic, completion: @escaping (Result<Void, Error>) -> Void) {
        let query = db.collection("comics").whereField("name", isEqualTo: comic.name)
            .whereField("issueNumber", isEqualTo: comic.issueNumber)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                // Comic already exists
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Comic already exists"])))
                return
            }
            
            do {
                _ = try self.db.collection("comics").document(comic.id).setData(from: comic) { error in
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

