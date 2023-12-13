//
//  HomeView.swift
//  ComicVault
//
//  Group 10
//
//  Created by Ayman Tauhid on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import Foundation
import Vision
import CoreML
import UIKit

class MLHelper: ObservableObject {
    @Published var classification = "XXXX"
    @Published var comicTitle = "Unknown Title"
    @Published var issueNumber = "Unknown Issue"

    private var classificationRequest: VNCoreMLRequest?

    func createRequest() {
        do {
            let model = try VNCoreMLModel(for: ComicVaultML_1(configuration: MLModelConfiguration()).model)

            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                if let error = error {
                    print(#function, "Error during classification: \(error.localizedDescription)")
                    return
                }
                self?.processClassification(for: request)
            }

            request.imageCropAndScaleOption = .centerCrop
            self.classificationRequest = request

        } catch {
            print(#function, "Unable to create request: \(error.localizedDescription)")
        }
    }

    func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classification = "Unable to classify image."
                return
            }

            let identifier = topResult.identifier
            self.classification = identifier
            self.parseComicDetails(from: identifier)
        }
    }

    func updateClassification(for selectedImage: UIImage) {
        guard let imageInput = CIImage(image: selectedImage),
              let classificationRequest = self.classificationRequest else {
            self.classification = "Unable to process image."
            return
        }

        let handler = VNImageRequestHandler(ciImage: imageInput)
        do {
            try handler.perform([classificationRequest])
        } catch {
            print(#function, "Error performing classification: \(error.localizedDescription)")
        }
    }

    private func parseComicDetails(from identifier: String) {
        let components = identifier.split(separator: "_#")
        if components.count == 2 {
            let title = components[0].replacingOccurrences(of: "_", with: " ")
            let issue = components[1]
            self.comicTitle = title
            self.issueNumber = String(issue)
        } else {
            self.comicTitle = "Unknown Title"
            self.issueNumber = "Unknown Issue"
        }
    }
}
