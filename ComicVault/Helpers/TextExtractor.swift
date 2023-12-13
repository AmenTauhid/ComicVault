//
//  ComicVineHelper.swift
//  ComicVault
//
//  Group 10
//
//  Created by Ayman Tauhid on 2023-11-22.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import Foundation
import UIKit
import Vision

struct TextExtractor {
    
    // Function to recognize text from an image
    static func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                completion([])
                return
            }
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            completion(recognizedStrings)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        try? requestHandler.perform([request])
    }

    // Helper function to extract issue number from a string
    static func extractIssueNumber(from text: String) -> String {
        let issueNumberPattern = "\\b\\d+C (\\d+)\\b"
        if let regex = try? NSRegularExpression(pattern: issueNumberPattern, options: []) {
            let nsText = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
            if let match = results.first {
                return nsText.substring(with: match.range(at: 1))
            }
        }
        return ""
    }

    static func extractMonth(from text: String) -> String? {
        let monthsPattern = "\\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\\b"
        if let regex = try? NSRegularExpression(pattern: monthsPattern, options: .caseInsensitive) {
            let nsText = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
            for match in results {
                return nsText.substring(with: match.range)
            }
        }
        return nil
    }

    static func extractComicName(from text: String) -> String {
        // Attempt to match "MARVEL COMICS GROUP" followed by capitalized words which could be the title
        let comicNamePattern = "MARVEL COMICS GROUP[E]?\\s+([A-Z]+\\s+[A-Z]+)"
        if let regex = try? NSRegularExpression(pattern: comicNamePattern, options: []) {
            let nsText = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
            if let match = results.first {
                // Attempt to correct common OCR errors by replacing recognized character errors
                var name = nsText.substring(with: match.range(at: 1))
                let ocrCorrections = ["AMAZNS": "AMAZING", "SPIDERMA": "SPIDER-MAN"]
                for (incorrect, correct) in ocrCorrections {
                    name = name.replacingOccurrences(of: incorrect, with: correct)
                }
                return name
            }
        }
        return ""
    }

}
