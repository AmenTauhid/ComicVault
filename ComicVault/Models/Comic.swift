//
//  Comic.swift
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

struct Comic: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var issueNumber: String
    var releaseYear: String
    var price: Double?
}
