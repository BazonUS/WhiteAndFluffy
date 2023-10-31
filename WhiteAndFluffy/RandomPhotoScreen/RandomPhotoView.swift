//
//  RandomPhotoView.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

final class RandomPhotoView: UIView {
    
    // MARK: - Private Properties
    
    private weak var searchDelegate: SearchTextFieldViewDelegate?
    
    private lazy var searchTextField: SearchTextFieldView = {
        let textField = SearchTextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = searchDelegate
        return textField
    }()
    
    private var searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private (set) var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    init(searchDelegate: SearchTextFieldViewDelegate) {
        self.searchDelegate = searchDelegate
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        addSubviews()
        configureUI()
        setupConstraints()
    }
    
    private func addSubviews() {
        [
            containerView,
            searchContainerView,
            searchTextField
        ].forEach({
            addSubview($0)
        })
    }
    
    private func configureUI() {
        backgroundColor = .black
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: topAnchor),
            searchContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchContainerView.heightAnchor.constraint(equalToConstant: 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -10.scale),
            searchTextField.centerXAnchor.constraint(equalTo: searchContainerView.centerXAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40.scale),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 20.scale),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -20.scale),
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
