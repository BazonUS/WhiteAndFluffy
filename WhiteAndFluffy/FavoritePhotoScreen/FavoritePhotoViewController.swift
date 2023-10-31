//
//  FavoritePhotoViewController.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

final class FavoritePhotoViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            FavoritePhotoCell.self,
            forCellReuseIdentifier: NSStringFromClass(FavoritePhotoCell.self)
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .gray
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var model: [FavoriteModel] = []
    private let favoriteKeeper = FavoriteKeeper()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        model = favoriteKeeper.loadAll()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .gray
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension FavoritePhotoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(FavoritePhotoCell.self),
            for: indexPath
        ) as? FavoritePhotoCell,
               indexPath.row < model.count
        else { return UITableViewCell() }
        cell.configure(with: model[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritePhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < model.count else { return }
        let photoModel = model[indexPath.row]
        let descriptionViewController = DescriptionViewController(photoDescription: photoModel.toPhotoDescription(), isFavorite: true)
        descriptionViewController.delegate = self
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }
}

// MARK: - DescriptionViewControllerDelegate

extension FavoritePhotoViewController: DescriptionViewControllerDelegate {
    func favoriteDidTap(description: PhotoDescription, isFavorite: Bool) {
        if isFavorite {
            favoriteKeeper.save(description.toFavoriteModel())
        } else {
            favoriteKeeper.delete(description.toFavoriteModel())
        }
    }
}
