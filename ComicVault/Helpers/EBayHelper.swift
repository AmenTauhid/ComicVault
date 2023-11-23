//
//  EBayHelper.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//

import Foundation

class EbayAPIManager {
    // eBay API key constant
    private let ebayAPIKey = "YOUR_EBAY_API_KEY"

    // Function to create the eBay search URL
    private func createEbaySearchURL(forComicName name: String, issueNumber: String) -> URL? {
        let queryItems = [
            URLQueryItem(name: "_nkw", value: "\(name) issue \(issueNumber)"),
            URLQueryItem(name: "_sacat", value: "0")
        ]
        var urlComponents = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }

    // Function to fetch eBay search results
    func fetchEbaySearchResults(forComicName name: String, issueNumber: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = createEbaySearchURL(forComicName: name, issueNumber: issueNumber) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(ebayAPIKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let response = try JSONDecoder().decode(EbaySearchResponse.self, from: data)
                if let firstItemPrice = response.itemSummaries.first?.price?.value,
                   let price = Double(firstItemPrice) {
                    completion(.success(price))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Price not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Structs to decode the eBay API response
struct EbaySearchResponse: Codable {
    let itemSummaries: [EbayItemSummary]
}

struct EbayItemSummary: Codable {
    let price: EbayPrice?
}

struct EbayPrice: Codable {
    let value: String
}
