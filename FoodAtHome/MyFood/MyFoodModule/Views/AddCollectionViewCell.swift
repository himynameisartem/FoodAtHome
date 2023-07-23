//
//  AddCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 26.05.2022.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    var foodImage = UIImageView()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.tintColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addButton)
        
        addConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraint() {
        
        NSLayoutConstraint.activate([
        
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
}
