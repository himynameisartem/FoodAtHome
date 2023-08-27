//
//  CategoryListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2022.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {
    
    private var foodImage: UIImageView!
    
    private var foodName: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        foodImage = UIImageView()
        foodImage.translatesAutoresizingMaskIntoConstraints = false
        foodImage.layer.cornerRadius = 10
        addSubview(foodImage)
        
        foodName = UILabel()
        foodName.translatesAutoresizingMaskIntoConstraints = false
        foodName.font = UIFont(name: "Inter-Light", size: 18)
        addSubview(foodName)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            foodImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            foodImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            foodImage.heightAnchor.constraint(equalToConstant: 60),
            foodImage.widthAnchor.constraint(equalToConstant: 60),
            
            foodName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            foodName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100)
            
        ])
    }
    
    func configure(_ food: FoodRealm) {
        foodImage.image = UIImage(named: food.name)
        foodName.text = food.name
    }
}
