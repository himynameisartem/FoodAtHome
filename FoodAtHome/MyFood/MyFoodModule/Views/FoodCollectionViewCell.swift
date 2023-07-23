//
//  FoodCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let shadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let imageBackgroundColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.alpha = 0.1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private var foodImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private var foodName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-ExtraLight", size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var attentionView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "exclamationmark.circle.fill")
        view.tintColor = .red
        view.isHidden = true
        return view
    }()
    
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
        foodName.text = food.name
    }
    
    private func setupUI(){
        backgroundColor = .white
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = 10
        
        contentView.addSubview(container)
        container.addSubview(foodImage)
        container.addSubview(foodName)
        contentView.addSubview(attentionView)
    }

    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            attentionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            attentionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            attentionView.widthAnchor.constraint(equalToConstant: 23),
            attentionView.heightAnchor.constraint(equalToConstant: 23),
            
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
