//
//  SetLanguageCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 14.05.2025.
//

import UIKit

struct SetLanguageCellViewModel {
    let title: String
    let language: String
}

class SetLanguageCell: UITableViewCell {
    
    var buttonTappedAction: (() -> Void)?
    
    let titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetLanguageCell {
    func configure(with viewModel: SetLanguageCellViewModel) {
        titleButton.setTitle(viewModel.title, for: .normal)
        languageLabel.text = viewModel.language
    }
    
    func configureUI() {
        contentView.addSubview(titleButton)
        contentView.addSubview(languageLabel)
        titleButton.addTarget(self, action: #selector(setLanguageButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            languageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc func setLanguageButtonTapped() {
        buttonTappedAction?()
    }
    
}
