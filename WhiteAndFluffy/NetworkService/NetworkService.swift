//
//  NetworkService.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import Alamofire
import Kingfisher
import UIKit

protocol NetworkService {

    func fetchRandomPhotos(completion: @escaping (Result<[PhotoID], Error>) -> Void)
    
    func fetchSearchResponse(query: String, completion: @escaping (Result<[PhotoID], Error>) -> Void)
    
    func fetchPhotoDescription(photoID: PhotoID, completion: @escaping (Result<PhotoDescription, Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    // MARK: - Private Properties
    
    private static let photoCount: Int = 30
    
    private enum UrlBuilder {
        case id(String)
        case query(String)
        case random
        
        var url: String {
            let token = "x-AMJSj6utWIGkVdE08WJ72BCLQt-0wXqan9cMgSiws"
            switch self {
            case .id(let id):
                return "https://api.unsplash.com/photos/\(id)?client_id=\(token)"
            case .query(let query):
                let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
                let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return !encodedQuery.isEmpty ? "https://api.unsplash.com/search/photos/?query=\(encodedQuery)&per_page=\(photoCount)&client_id=\(token)" : "https://api.unsplash.com/photos/?client_id=\(token)"
            case .random:
                return "https://api.unsplash.com/photos/random/?count=\(photoCount)&client_id=\(token)"
            }
        }
    }
    
    // MARK: - Public Methods
    
    func fetchRandomPhotos(completion: @escaping (Result<[PhotoID], Error>) -> Void) {
        let url = UrlBuilder.random.url
        fetchDataRandomPhotos(with: url) { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            case .success(let randomPhotos):
                self.createPhotoID(with: randomPhotos) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let unsplashImage):
                            completion(.success(unsplashImage))
                        }
                    }
                }
            }
        }
    }
    
    func fetchSearchResponse(query: String, completion: @escaping (Result<[PhotoID], Error>) -> Void) {
        let url = UrlBuilder.query(query).url
        fetchDataSearchPhotos(with: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let searchImages):
                self.createPhotoID(with: searchImages) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let unsplashImage):
                            completion(.success(unsplashImage))
                        }
                    }
                }
            }
        }
    }
    
    func fetchPhotoDescription(photoID: PhotoID, completion: @escaping (Result<PhotoDescription, Error>) -> Void) {
        let url = UrlBuilder.id(photoID.id).url
        fetchDataIDPhoto(with: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let pickedImage):
                let descriptionPhoto = PhotoDescription(
                    id: pickedImage.id,
                    url: photoID.url,
                    creationDate: pickedImage.created_at,
                    downloads: pickedImage.downloads ?? 0,
                    country: pickedImage.location?.country,
                    city: pickedImage.location?.city,
                    name: pickedImage.user.name
                )
                completion(.success(descriptionPhoto))

            }
        }
    }
    
    // MARK: - Private Methods

    private func fetchDataRandomPhotos(
        with url: String,
        completion: @escaping (Result<[URLPhoto], Error>) -> Void
    ) {
        AF.request(url, method: .get).validate().responseDecodable(of: [URLPhoto].self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let randomImages):
                completion(.success(randomImages))
            }
        }
    }
    
    private func fetchDataSearchPhotos(
        with url: String,
        completion: @escaping (Result<[URLPhoto], Error>) -> Void
    ) {
        AF.request(url, method: .get).validate().responseDecodable(of: SearchPhoto.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let searchImages):
                let result = searchImages.results
                completion(.success(result))
            }
        }
    }
    
    private func fetchDataIDPhoto(
        with url: String,
        completion: @escaping (Result<Photo, Error>) -> Void
    ) {
        AF.request(url, method: .get).validate().responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let idImage):
                completion(.success(idImage))
            }
        }
    }
    
    private func createPhotoID(
        with urlImages: [URLPhoto],
        completion: @escaping (Result<[PhotoID], Error>) -> Void
    ) {
        var unsplashImages: [PhotoID] = []
        var errors = [Error]()
        let dispatchGroup = DispatchGroup()
        
        urlImages.forEach({ urlImage in
            dispatchGroup.enter()
            guard let url = URL(string: urlImage.urls.small) else {
                dispatchGroup.leave()
                return
            }
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .failure(let error):
                    print("Error: \(error)")
                    errors.append(error)
                    dispatchGroup.leave()
                case .success(let value):
                    unsplashImages.append(PhotoID(id: urlImage.id, photo: value.image, url: value.source.url))
                    dispatchGroup.leave()
                }
            }
        })
        dispatchGroup.notify(queue: .main) {
            guard errors.isEmpty else {
                print("getUrlForItems ERRORs = \(errors)")
                completion(.failure(errors[0]))
                return
            }
            completion(.success(unsplashImages))
        }
        
    }
}

