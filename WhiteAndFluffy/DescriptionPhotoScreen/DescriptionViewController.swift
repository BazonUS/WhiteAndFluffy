//
//  DescriptionViewController.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

protocol DescriptionViewControllerDelegate: AnyObject {
    func favoriteDidTap(description: PhotoDescription, isFavorite: Bool)
}

final class DescriptionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: DescriptionViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var photoDescription: PhotoDescription
    private var isFavorite : Bool
    private lazy var descriptionView = DescriptionView(photoDescription: photoDescription, isFavorite: isFavorite, delegate: self)
    
    // MARK: - Initializers
    
    init(photoDescription: PhotoDescription, isFavorite: Bool) {
        self.photoDescription = photoDescription
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = descriptionView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - DescriptionViewDelegate

extension DescriptionViewController: DescriptionViewDelegate {
    func favoriteButtonDidTap(isFavorite: Bool) {
        delegate?.favoriteDidTap(description: photoDescription, isFavorite: isFavorite)
        let alertAdd = UIAlertController(title: "Changes were made", message: "Photo added to favorites!", preferredStyle: .alert)
        let alertRemove = UIAlertController(title: "Changes were made", message: "Photo removed from favorites!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertAdd.addAction(okAction)
        alertRemove.addAction(okAction)
        if isFavorite == true {
            self.present(alertAdd, animated: true, completion: nil)
        } else {
            self.present(alertRemove, animated: true, completion: nil)
        }
    }
}
