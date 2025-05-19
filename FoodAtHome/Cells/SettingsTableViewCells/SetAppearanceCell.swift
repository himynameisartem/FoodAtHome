//
//  SetAppearanceCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 14.05.2025.
//

import UIKit

struct SetAppearanceCellViewModel {
    let title: String
    let isOn: Bool
}

class SetAppearanceCell: UITableViewCell {
    
    var switchAction: ((Bool)-> Void)?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let switchMode: UISwitch = {
        let switchMode = UISwitch()
        switchMode.isOn = false
        switchMode.translatesAutoresizingMaskIntoConstraints = false
        return switchMode
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
        switchConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetAppearanceCell {
    func configure(with viewModel: SetAppearanceCellViewModel) {
        titleLabel.text = viewModel.title
        switchMode.isOn = viewModel.isOn
    }
    
    private func switchConfigure() {
        switchMode.addTarget(self, action: #selector(swicthedMode), for: .valueChanged)
    }
    
    func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchMode)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            switchMode.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchMode.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func setSwitchState(_ isOn: Bool, animated: Bool) {
        switchMode.setOn(isOn, animated: animated)
    }
    
    @objc func swicthedMode(_ sender: UISwitch) {
        switchAction?(sender.isOn)
    }
}
