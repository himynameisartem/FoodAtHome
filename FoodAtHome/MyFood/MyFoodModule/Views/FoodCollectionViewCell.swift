//
//  FoodCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    private var container: UIView!
    private var shadow: UIView!
    private var imageBackgroundColor: UIView!
    private var foodImage: UIImageView!
    private var foodName: UILabel!
    private var expiredIndication: UIImageView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(food: FoodRealm) {
        foodImage.image = UIImage(named: food.name)
        foodName.text = food.name.localized()
        if DateManager.shared.expirationDateCheck(experationDate: food.expirationDate) {
            expiredIndication.isHidden = false
        } else {
            expiredIndication.isHidden = true
        }
    }
    
    private func setupUI(){
        backgroundColor = .white
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = 10
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 10

        shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.backgroundColor = .white
        shadow.layer.shadowColor = UIColor.gray.cgColor
        shadow.layer.shadowRadius = 4
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadow.layer.cornerRadius = 10
        
        imageBackgroundColor = UIView()
        imageBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundColor.backgroundColor = .systemGray3
        imageBackgroundColor.alpha = 0.1
        imageBackgroundColor.layer.cornerRadius = 10
        imageBackgroundColor.clipsToBounds = true
        
        foodImage = UIImageView()
        foodImage.translatesAutoresizingMaskIntoConstraints = false
        foodImage.contentMode = .scaleAspectFit
        foodImage.layer.cornerRadius = 10
        foodImage.clipsToBounds = true
        
        foodName = UILabel()
        foodName.font = UIFont(name: "Inter-ExtraLight", size: 12)
        foodName.textAlignment = .center
        foodName.numberOfLines = 0
        foodName.translatesAutoresizingMaskIntoConstraints = false
        
        expiredIndication = UIImageView()
        expiredIndication.translatesAutoresizingMaskIntoConstraints = false
        expiredIndication.image = UIImage(systemName: "exclamationmark.circle.fill")
        expiredIndication.tintColor = .red
        expiredIndication.isHidden = true
        
        contentView.addSubview(container)
        container.addSubview(foodImage)
        container.addSubview(foodName)
        contentView.addSubview(expiredIndication)
    }

    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            expiredIndication.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            expiredIndication.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            expiredIndication.widthAnchor.constraint(equalToConstant: 23),
            expiredIndication.heightAnchor.constraint(equalToConstant: 23),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            foodImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            foodImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            foodImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            foodName.topAnchor.constraint(equalTo: foodImage.bottomAnchor, constant: 0),
            foodName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            foodName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            foodName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            foodName.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
