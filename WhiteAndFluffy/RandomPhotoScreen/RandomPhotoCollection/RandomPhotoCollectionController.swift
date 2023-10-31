//
//  RandomPhotoCollectionController.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

protocol CollectionControllerDelegate: AnyObject {
    func selectableCollection(_ collection: GalleryCollectionController, didSelectItemAt indexPath: IndexPath)
}

final class GalleryCollectionController: UIViewController {
    
    // MARK: - Private Properties
    
    private (set) var viewCollection: GalleryCollectionView
    private let itemSize: CGSize
    private let spacing: CGFloat
    private let collectionInsets: UIEdgeInsets
    
    private var model: [PhotoID] {
        didSet {
            guard oldValue != model else { return }
            viewCollection.reloadData()
        }
    }
    
    private weak var searchTextFieldDelegate: SearchTextFieldViewDelegate?
    
    private weak var delegate: CollectionControllerDelegate?
    
    // MARK: - Initializers
    
    init(
        model: [PhotoID],
        delegate: CollectionControllerDelegate,
        collectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        itemSize: CGSize = CGSize(width: 350.scale, height: 300.scale),
        itemSpacing: CGFloat = 16.scale,
        backgroundColor: UIColor = .gray
    ) {
        self.model = model
        self.delegate = delegate
        self.collectionInsets = collectionInsets
        self.itemSize = itemSize
        self.spacing = itemSpacing
        self.viewCollection = GalleryCollectionView(
            itemSize: itemSize,
            spacing: itemSpacing,
            backgroundColor: backgroundColor
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = viewCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: - Public Methods
    
    public func reloadData(model: [PhotoID]) {
        self.model = model
        viewCollection.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func configureCollectionView() {
        viewCollection.dataSource = self
        viewCollection.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryCollectionController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: GalleryCollectionCell = viewCollection.dequeueReusableCell(
            withReuseIdentifier: String(describing: GalleryCollectionCell.self), for: indexPath
        ) as! GalleryCollectionCell
        let item = model[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GalleryCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .centeredHorizontally
        )
        delegate?.selectableCollection(self, didSelectItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return collectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        itemSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }
}

