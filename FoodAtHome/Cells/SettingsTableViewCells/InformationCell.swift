//
//  InformationCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 14.05.2025.
//

import UIKit

struct InformationCellViewModel {
    let title: String
}

class InformationCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
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

extension InformationCell {
     func configure(with viewModel: InformationCellViewModel) {
         titleLabel.text = viewModel.title
    }
    
    func configureUI() {
        self.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
        ])
    }
}
