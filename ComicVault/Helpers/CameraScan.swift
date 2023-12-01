import Foundation
import SwiftUI
import PhotosUI
import Vision

extension String {
    func trimmingLeadingZeros() -> String {
        var result = self
        if result.hasPrefix("0") {
            result.removeFirst()
        }
        return result
    }
}


struct CameraClickView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    @Binding var barcodeResults: [String] // New binding for barcode results

    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = context.coordinator

        return cameraPicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Nothing to update on PhotosLibrary
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraClickView

        init(parent: CameraClickView) {
            self.parent = parent
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // User didn't click any picture and cancelled the operation
            self.parent.isPresented.toggle()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // User clicked the picture

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Perform barcode recognition
                recognizeBarcode(uiImage: image)
            } else {
                print(#function, "Image not available from camera")
            }

            picker.dismiss(animated: true)
            self.parent.isPresented.toggle()
        }

        private func recognizeBarcode(uiImage: UIImage) {
            guard let cgImage = uiImage.cgImage else { return }

            let barcodeRequest = VNDetectBarcodesRequest { request, error in
                if let error = error {
                    print("Barcode detection error: \(error.localizedDescription)")
                    return
                }

                guard let observations = request.results as? [VNBarcodeObservation] else { return }

                self.parent.barcodeResults = observations.compactMap { observation in
                    // Handle the recognized barcodes here, e.g., extract the payloadStringValue
                    var barcode = observation.payloadStringValue ?? ""
                    barcode = barcode.trimmingLeadingZeros() // Trim leading zeros

                    // Call the function to search on eBay with the barcode
                    self.searchOnEbayByUPC(upc: barcode)

                    return barcode
                }
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            do {
                try handler.perform([barcodeRequest])
            } catch {
                print("Error performing barcode request: \(error.localizedDescription)")
            }
        }

        // Function to search on eBay by UPC
        private func searchOnEbayByUPC(upc: String) {
            // eBay Browse API endpoint for searching by UPC
            let endpoint = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=UPC:\(upc)"

            // Replace "YOUR_ACCESS_TOKEN" with your actual eBay API access token
            let accessToken = "YOUR_ACCESS_TOKEN"

            guard let url = URL(string: endpoint) else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        // Parse and handle the response JSON here
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }

            task.resume()
        }
    }
}
