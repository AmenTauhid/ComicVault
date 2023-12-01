import Foundation

struct EbaySearchResult: Decodable {
    let itemId: String
    let title: String
    let price: String
    let upc: String
}

func searchOnEbayByUPC(upc: String, completion: @escaping (Result<[EbaySearchResult], Error>) -> Void) {
    // eBay Browse API endpoint for searching by UPC
    let endpoint = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=UPC:\(upc)"

    // Replace "YOUR_ACCESS_TOKEN" with your actual eBay API access token
    let accessToken = "v^1.1#i^1#I^3#p^3#r^1#f^0#t^Ul4xMF8wOjI4NzQxRUI4RTBGRjBEMDEyM0I3Q0IxNzVDOUREREMxXzNfMSNFXjEyODQ="

    guard let url = URL(string: endpoint) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                let ebaySearchResults = try decoder.decode([EbaySearchResult].self, from: data)
                completion(.success(ebaySearchResults))
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}
