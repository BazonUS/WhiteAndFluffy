//
//  DescriptionView.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit
import Kingfisher

protocol DescriptionViewDelegate: AnyObject {
    func favoriteButtonDidTap(isFavorite: Bool)
}

final class DescriptionView: UIView{
    
    // MARK: - Private Properties
    
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [creatorNameLabel, creationDateLabel, locationLabel, downloadsCountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let photoDescription: PhotoDescription
    
    private weak var delegate: DescriptionViewDelegate?
    
    private var isFavorite: Bool = false
    
    // MARK: - Initializers
    
    init(photoDescription: PhotoDescription, isFavorite: Bool, delegate: DescriptionViewDelegate?) {
        self.photoDescription = photoDescription
        self.isFavorite = isFavorite
        self.delegate = delegate
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func favoriteButtonDidTap() {
        UIView.animate(withDuration: 0.3) { [self] in
            isFavorite.toggle()
            setButton()
        }
        delegate?.favoriteButtonDidTap(isFavorite: isFavorite)
        
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        backgroundColor = .gray
    
        if let creatorName = photoDescription.name {
            creatorNameLabel.text = "The photo was taken by " + creatorName
        } else {
            creatorNameLabel.text = "The photographer is unknown"
        }
        if let creationDate = photoDescription.creationDate {
            creationDateLabel.text = "The date of creation is " + String(creationDate.prefix(10))
        } else {
            creationDateLabel.text = "Unknown date"
        }
        if let location = photoDescription.country {
            locationLabel.text = "The location is " + location
        } else {
            locationLabel.text = "The location is unknown"
        }
        if let downloads = photoDescription.downloads {
            downloadsCountLabel.text = String(downloads) + " downloads"
        } else {
            downloadsCountLabel.text = "0 downloads"
        }
        setButton()
        setupImage()
    }
    
    private func setButton() {
        if isFavorite == true {
            favoriteButton.setTitle("Remove Photo from Favorites", for: .normal)
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.setTitle("Add Photo to Favorites", for: .normal)
            favoriteButton.tintColor = .systemGreen
        }
    }
    
    private func setupImage() {
        photoView.kf.setImage(
            with: photoDescription.url,
            placeholder: nil,
            options: [.transition(
                ImageTransition.flipFromRight(
                    0.3
                )
            )]
        )
    }
    
    private func addSubviews() {
        [
            photoView,
            infoStackView,
            favoriteButton
        ].forEach({
            self.addSubview($0)
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 280.scale),
            
            infoStackView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10.scale),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            infoStackView.heightAnchor.constraint(equalToConstant: 200.scale),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 280.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40.scale),
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 10.scale),
        ])
    }
}
