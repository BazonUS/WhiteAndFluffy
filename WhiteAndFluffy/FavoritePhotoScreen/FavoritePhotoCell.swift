//
//  FavoritePhotoCell.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/29/23.
//

import UIKit
import Kingfisher

final class FavoritePhotoCell: UITableViewCell {
   
    // MARK: - Private Properties
    
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.metering.unknown")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        photoView.image = nil
    }
    
    // MARK: - Public methods
    
    func configure(with model: FavoriteModel) {
        nameLabel.text = model.name
        photoView.kf.setImage(
            with: model.imageURL,
            placeholder: nil,
            options: [.transition(
                ImageTransition.flipFromRight(
                    0.3
                )
            )]
        )
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
        
        backgroundColor = .gray
    }
    
    private func addSubviews() {
        [   photoView,
            nameLabel
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            photoView.heightAnchor.constraint(equalToConstant: 100.scale),
            photoView.widthAnchor.constraint(equalToConstant: 100.scale),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 15.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
    }
}
