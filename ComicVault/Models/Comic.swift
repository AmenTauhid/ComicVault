//
//  Comic.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-11-22.
//
import Foundation

struct Comic: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var issueNumber: String
    var barcode: String?
}
