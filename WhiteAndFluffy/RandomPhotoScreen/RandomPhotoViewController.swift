//
//  RandomPhotoViewController.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

final class RandomPhotoViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService
    
    private lazy var collectionController = GalleryCollectionController(model: [], delegate: self)
    private var model: [PhotoID] = [] {
        didSet {
            guard oldValue != model else { return }
            collectionController.reloadData(model: model)
        }
    }
    
    private lazy var randomPhotoView = RandomPhotoView(searchDelegate: self)
    private let favoriteKeeper = FavoriteKeeper()
    
    
    // MARK: - Initializers
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
        fetchRandomImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = randomPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewFromController(controller: collectionController, rootView: randomPhotoView.containerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    
    private func fetchRandomImages() {
        networkService.fetchRandomPhotos { [weak self] result in
            switch result {
            case .success(let unsplashImages):
                self?.model = unsplashImages
            case .failure(let error):
                print(error)
                let alert = UIAlertController(
                    title: "Something went wrong ",
                    message: "The error is\n\(error.localizedDescription)",
                    preferredStyle: .alert
                )
                let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okayAction)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func fetchSearchResponse(query: String) {
        networkService.fetchSearchResponse(query: query) { [weak self] result in
            switch result {
            case .success(let unsplashImages):
                self?.model = unsplashImages
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addViewFromController (controller: UIViewController, rootView: UIView) {
        addChild(controller)
        rootView.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: rootView.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        controller.didMove(toParent: self)
    }
    
}

// MARK: - CollectionControllerDelegate

extension RandomPhotoViewController: CollectionControllerDelegate {
    func selectableCollection(_ collection: GalleryCollectionController, didSelectItemAt indexPath: IndexPath) {
        let photoID = model[indexPath.row]
        guard let cell = collection.viewCollection.cellForItem(at: indexPath) as? GalleryCollectionCell else { return }
        cell.setActivity(isOn: true)
        networkService.fetchPhotoDescription(photoID: photoID) { [weak self] result in
            switch result {
            case .success(let description):
                let descriptionViewController = DescriptionViewController(photoDescription: description, isFavorite: false)
                descriptionViewController.delegate = self
                self?.navigationController?.pushViewController(descriptionViewController, animated: true)
            case .failure(let error):
                print(error)
            }
            cell.setActivity(isOn: false)
        }
    }
}

// MARK: - DescriptionViewControllerDelegate

extension RandomPhotoViewController: DescriptionViewControllerDelegate {
    func favoriteDidTap(description: PhotoDescription, isFavorite: Bool) {
        if isFavorite {
            favoriteKeeper.save(description.toFavoriteModel())
        } else {
            favoriteKeeper.delete(description.toFavoriteModel())
        }
    }
}

// MARK: - TextFieldViewDelegate

extension RandomPhotoViewController: SearchTextFieldViewDelegate {
    func serchedText(text: String) {
        fetchSearchResponse(query: text)
    }
}
