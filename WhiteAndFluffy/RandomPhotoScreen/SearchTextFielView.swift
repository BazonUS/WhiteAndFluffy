//
//  SearchTextFielView.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

protocol SearchTextFieldViewDelegate: AnyObject {
    func serchedText(text: String)
}

final class SearchTextFieldView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: SearchTextFieldViewDelegate?
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    private var previousText = ""
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(.black).withAlphaComponent(0.5),
            .font: UIFont.systemFont(ofSize: 18)
            ]
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor(.black)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "searchIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        addSubviews()
        configureUI()
        setupConstraints()
    }
    
    private func addSubviews() {
        [
            textField,
            clearButton
        ].forEach({
            stackView.addArrangedSubview($0)
        })
        
        self.addSubview(stackView)
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        self.layer.cornerRadius = 12
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            clearButton.widthAnchor.constraint(equalToConstant: 22.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 22.scale)
        ])
    }

    // MARK: - Actions
    
    @objc private func clearButtonTapped() {
        textField.text = ""
        previousText = ""
        clearButton.setImage(UIImage(named: "searchIcon"), for: .normal)
        clearButton.isUserInteractionEnabled = false
    }
    
    @objc func checkText() {
        delegate?.serchedText(text: previousText)
    }
}

// MARK: - UITextFieldDelegate

extension SearchTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    )-> Bool {
        let newText = (previousText as NSString).replacingCharacters(in: range, with: string)
        if !newText.isEmpty {
            clearButton.setImage(UIImage(named: "clearIcon"), for: .normal)
            clearButton.isUserInteractionEnabled = true
        }
        if previousText != newText {
            previousText = newText
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                timeInterval: 2.0,
                target: self,
                selector: #selector(checkText),
                userInfo: nil,
                repeats: false
            )
        }
        return true
    }
}

