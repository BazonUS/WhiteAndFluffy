//
//  FavoriteModel.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 30.10.2023.
//

import Foundation

struct FavoriteModel: Codable {
    let id: String
    let name: String?
    let downloads: Int?
    let country: String?
    let city: String?
    var isFavorite: Bool = false
    let date: String?
    let imageURL: URL?
    
    func toPhotoDescription() -> PhotoDescription {
        PhotoDescription(
            id: id,
            url: imageURL,
            creationDate: date,
            downloads: downloads,
            country: country,
            city: city,
            name: name
        )
    }
}

extension PhotoDescription {
    func toFavoriteModel() -> FavoriteModel {
        FavoriteModel(
            id: id,
            name: name,
            downloads: downloads,
            country: country,
            city: city,
            date: creationDate,
            imageURL: url
        )
    }
}
