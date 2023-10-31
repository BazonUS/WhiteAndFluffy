//
//  AppPhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/30/23.
//

import UIKit

// MARK: - App Photo Model

struct PhotoID: Equatable {
    let id: String
    let photo: UIImage
    let url: URL?
}

struct PhotoDescription: Equatable {
    let id: String
    let url: URL?
    let creationDate: String?
    let downloads: Int?
    let country: String?
    let city: String?
    let name: String?
}
