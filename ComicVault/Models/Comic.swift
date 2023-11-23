//
//  Comic.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//
import Foundation

struct Comic: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var issueNumber: String
    var releaseYear: String
    var price: Double?
}
