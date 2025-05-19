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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetLanguageCell {
    func configure(with viewModel: SetLanguageCellViewModel) {
        titleLabel.text = viewModel.title
        languageLabel.text = viewModel.language
    }
    
    func configureUI() {
        self.addSubview(titleLabel)
        self.addSubview(languageLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            languageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}
