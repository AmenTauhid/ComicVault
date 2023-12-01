//
//  AddComicView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct AddComicView: View {
    @State private var name: String = ""
    @State private var issueNumber: String = ""
    @State private var releaseYear: String = ""
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCameraSheet = false
    @State private var capturedImage: UIImage?
    @State private var barcodeResults: [String] = []

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 70/255, green: 96/255, blue: 115/255) // Dark Grey/Blue

            VStack {
                Text("Add Comic")
                    .font(.system(size: 36, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue

                VStack {
                    TextField("Comic Name", text: $name)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    TextField("Issue Number", text: $issueNumber)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    TextField("Release Year", text: $releaseYear)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)

                    Button("Submit") {
                        submitComic()
//                        let comic = Comic(name: name, issueNumber: issueNumber, releaseYear: releaseYear)
//                        firestoreManager.addComic(comic) { result in
//                            switch result {
//                            case .success():
//                                alertMessage = "Comic added successfully"
//                                showAlert = true
//                                name = ""
//                                issueNumber = ""
//                                releaseYear = ""
//                                print("Comic added successfully")
//                            case .failure(let error):
//                                alertMessage = error.localizedDescription
//                                showAlert = true
//                            }
//                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color(red: 236/255, green: 107/255, blue: 102/255)) // Light Red
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }

                    ZStack{
                        Divider()
                            .background(Color.black)
                        Text("OR")
                            .background(Color(red: 70/255, green: 96/255, blue: 115/255)) // Dark Grey/Blue
                            .frame(width: 150)
                            .padding()
                            .font(.title2)
                    }

//                    Button("Scan Upc") {
//                        showCameraSheet.toggle()
//                    }
//                    .sheet(isPresented: $showCameraSheet) {
//                        CameraClickView(selectedImage: $capturedImage, isPresented: $showCameraSheet, barcodeResults: $barcodeResults)
//                            .onDisappear {
//                                updateBarcodeResults()
//                            }
//                    }
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color(red: 247/255, green: 227/255, blue: 121/255)) //Yellow
//                    .cornerRadius(10)
//                    .shadow(radius: 5)

//                    if !barcodeResults.isEmpty {
//                        VStack {
//                            Text("Detected Barcodes:")
//                                .foregroundColor(.black)
//                                .padding()
//
//                            ForEach(barcodeResults, id: \.self) { barcode in
//                                Text(barcode)
//                                    .foregroundColor(.black)
//                                    .padding()
//                            }
//
//                            Button("Search on eBay") {
//                                searchOnEbayForBarcodes()
//                            }
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                            .shadow(radius: 5)
//                        }
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .padding()
//                        .shadow(radius: 5)
//                    }
                }
                .padding(.top, 36)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func submitComic() {
        firestoreManager.addComicWithPrice(name: name, issueNumber: issueNumber, releaseYear: releaseYear) { result in
            switch result {
            case .success():
                alertMessage = "Comic added successfully with price"
                showAlert = true
                clearInputFields()
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private func clearInputFields() {
        name = ""
        issueNumber = ""
        releaseYear = ""
    }
    
    private func updateBarcodeResults() {
        // Update barcodeResults or perform any other action with the detected barcodes
        print("Detected Barcodes: \(barcodeResults.joined(separator: ", "))")
    }

//    private func searchOnEbayForBarcodes() {
//        // Iterate through the detected barcodes and perform eBay search
//        for barcode in barcodeResults {
//            // Call the function to search on eBay with the barcode
//            searchOnEbayByUPC(upc: barcode)
//        }
//    }
//
//    private func searchOnEbayByUPC(upc: String) {
//        // eBay Browse API endpoint for searching by UPC
//        let endpoint = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=UPC:\(upc)"
//
//        // Replace "YOUR_ACCESS_TOKEN" with your actual eBay API access token
//        let accessToken = "v^1.1#i^1#I^3#p^3#r^1#f^0#t^Ul4xMF8wOjI4NzQxRUI4RTBGRjBEMDEyM0I3Q0IxNzVDOUREREMxXzNfMSNFXjEyODQ="
//
//        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("Invalid response")
//                return
//            }
//
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                    // Parse and handle the response JSON here
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }
//
//        task.resume()
//    }
}

struct AddComicView_Previews: PreviewProvider {
    static var previews: some View {
        AddComicView()
    }
}
