//
//  RandomPhotoCollectionCell.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

final class GalleryCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Public Methods

    /// Setting up cell with image
    func configure(with item: PhotoID) {
        imageView.image = item.photo
    }
    
    func setActivity(isOn: Bool) {
        if isOn {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityView)
        setupContent()
    }
    
    private func setupContent() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

