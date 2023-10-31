//
//  RandomPhotoCollectionView.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

final class GalleryCollectionView: UICollectionView {
    
    // MARK: - Private properties
    
    private let spacing: CGFloat
    
    private var itemSize: CGSize
    
    // MARK: - Initialization
    
    init(
        itemSize: CGSize,
        spacing: CGFloat,
        backgroundColor: UIColor
    ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.itemSize = itemSize
        self.spacing = spacing
        super.init(frame: .zero, collectionViewLayout: layout)
        setupSelf(with: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private Methods
    
    private func setupSelf(with color: UIColor) {
        register(GalleryCollectionCell.self, forCellWithReuseIdentifier: String(describing: GalleryCollectionCell.self))
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        self.backgroundColor = color
    }
}
