//
//  FoodListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 03.08.2023.
//

import UIKit

class DetailFoodCell: UITableViewCell {
    
    var addButton: UIButton!
    private var shadowView: UIView!
    private var containerView: UIView!
    private var image: UIImageView!
    private var imageBackgroundColor: UIView!
    private var stack: UIStackView!
    private var title: UILabel!
    private var colories: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupUI() {
        
        backgroundColor = .clear
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 20
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.shadowColor = UIColor.gray.cgColor
        addButton.layer.shadowRadius = 8
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        shadowView = UIView()
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowView.layer.cornerRadius = 10
        
        containerView = UIView()
        shadowView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10

        image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true

        imageBackgroundColor = UIView()
        imageBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundColor.backgroundColor = .systemGray2
        imageBackgroundColor.alpha = 0.2
        imageBackgroundColor.layer.cornerRadius = 10
        imageBackgroundColor.clipsToBounds = true

        stack = UIStackView()
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
     
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        title.font = UIFont(name: "Inter-Light", size: 15)
        
        colories = UILabel()
        colories.translatesAutoresizingMaskIntoConstraints = false
        colories.font = UIFont(name: "Inter-ExtraLight", size: 10)
        colories.alpha = 0.7
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(colories)
        containerView.addSubview(image)
        containerView.addSubview(addButton)
        image.addSubview(imageBackgroundColor)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 8),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            
            imageBackgroundColor.topAnchor.constraint(equalTo: image.topAnchor),
            imageBackgroundColor.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            imageBackgroundColor.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            imageBackgroundColor.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
            
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            shadowView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -20),
            shadowView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: -20),
        ])

    }
    
    func configure(_ food: FoodRealm) {
        image.image = UIImage(named: food.name)
        title.text = food.name
        colories.text = ("\(food.calories) кКал. / 100г.")
    }
}

