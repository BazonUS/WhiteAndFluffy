//
//  APIPhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

// MARK: - API Photo Model

struct URLPhoto: Codable {
    let id: String
    let urls: Urls
}

struct Photo: Codable {
    let id: String
    let created_at: String
    let downloads: Int?
    let location: Location?
    let urls: Urls
    let user: User
    
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
}

struct Location: Codable {
    let city: String?
    let country: String?
}

struct User: Codable {
    let name: String
}

struct SearchPhoto: Codable {
    let results: [URLPhoto]
}
