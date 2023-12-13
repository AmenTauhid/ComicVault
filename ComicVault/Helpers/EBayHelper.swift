//
//  EBayHelper.swift
//  ComicVault
//
//  Created by Ayman Tauhid & Omar Al-Dulaimi on 2023-11-22.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import Foundation

class EbayAPIManager {
    // eBay API key constant
    private let ebayAPIKey = "OmarAlDu-ComicVau-PRD-ff4c095ff-f4147499"  // Replace with your actual eBay API key

    // Function to create the eBay Finding API search URL
    private func createEbaySearchURL(forComicName name: String, issueNumber: String, releaseYear: String) -> URL? {
        let formattedQuery = "\(name) \(issueNumber) \(releaseYear)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=\(ebayAPIKey)&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=\(formattedQuery ?? "")&GLOBAL-ID=EBAY-ENCA")
        return url
    }

    // Function to fetch eBay Finding API search results
    func fetchEbaySearchResults(forComicName name: String, issueNumber: String, releaseYear: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = createEbaySearchURL(forComicName: name, issueNumber: issueNumber, releaseYear: releaseYear) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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
                // Parse the response to extract prices
                let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let searchResult = responseDict?["findItemsByKeywordsResponse"] as? [[String: Any]],
                   let items = searchResult.first?["searchResult"] as? [[String: Any]],
                   let itemArray = items.first?["item"] as? [[String: Any]] {
                    let prices = itemArray.prefix(10).compactMap { item -> Double? in
                        if let sellingStatus = item["sellingStatus"] as? [[String: Any]],
                           let currentPriceArray = sellingStatus.first?["currentPrice"] as? [[String: Any]],
                           let priceValue = currentPriceArray.first?["__value__"] as? String {
                            return Double(priceValue)
                        }
                        return nil
                    }
                    let averagePrice = prices.reduce(0, +) / Double(prices.count)
                    completion(.success(averagePrice))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Price not found"])))
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Function to create the eBay Finding API search URL for UPC
    private func createEbaySearchURLByUPC(upc: String) -> URL? {
        let url = URL(string: "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByProduct&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=\(ebayAPIKey)&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&productId.@type=UPC&productId=\(upc)")
        return url
    }

        // Function to fetch eBay Finding API search results by UPC
    func fetchEbaySearchResultsByUPC(upc: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = createEbaySearchURLByUPC(upc: upc) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let searchResult = responseDict?["findItemsByProductResponse"] as? [[String: Any]],
                   let items = searchResult.first?["searchResult"] as? [[String: Any]],
                   let itemArray = items.first?["item"] as? [[String: Any]] {
                    let prices = itemArray.prefix(10).compactMap { item -> Double? in
                        if let sellingStatus = item["sellingStatus"] as? [[String: Any]],
                           let currentPriceArray = sellingStatus.first?["currentPrice"] as? [[String: Any]],
                           let priceValue = currentPriceArray.first?["__value__"] as? String {
                            return Double(priceValue)
                        }
                        return nil
                    }
                    if !prices.isEmpty {
                        let averagePrice = prices.reduce(0, +) / Double(prices.count)
                        completion(.success(averagePrice))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No prices found"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No items found"])))
                }
            } catch let error {
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
