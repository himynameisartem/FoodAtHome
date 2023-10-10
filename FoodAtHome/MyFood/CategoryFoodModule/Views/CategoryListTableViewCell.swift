//
//  CategoryListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2022.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {
    
    private var shadowView: UIView!
    private var containerView: UIView!
    private var image: UIImageView!
    private var imageBackgroundColor: UIView!
    private var stack: UIStackView!
    private var title: UILabel!
    private var colories: UILabel!
    private var weight: UILabel!
    private var expirationDateIndicator: UIView!
    private var expirationSign: UILabel!
    
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
        isUserInteractionEnabled = false
        
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
        title.numberOfLines = 2
        title.font = UIFont(name: "Inter-Light", size: 15)

        colories = UILabel()
        colories.font = UIFont(name: "Inter-ExtraLight", size: 10)
        colories.alpha = 0.7
        
        weight = UILabel()
        weight.translatesAutoresizingMaskIntoConstraints = false
        weight.contentMode = .bottom
        weight.textAlignment = .right
        weight.numberOfLines = 2
        weight.font = UIFont(name: "Inter-Light", size: 12)
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(colories)
        containerView.addSubview(image)
        image.addSubview(imageBackgroundColor)
        addSubview(weight)
        
        expirationDateIndicator = UIView()
        expirationDateIndicator.translatesAutoresizingMaskIntoConstraints = false
        expirationDateIndicator.layer.cornerRadius = 10
        addSubview(expirationDateIndicator)
        
        expirationSign = UILabel()
        expirationSign.translatesAutoresizingMaskIntoConstraints = false
        expirationSign.text = "!"
        expirationSign.font = UIFont(name: "Inter-SemiBold", size: 18)
        expirationSign.textColor = .white
        expirationSign.textAlignment = .center
        expirationDateIndicator.addSubview(expirationSign)
        
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
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
            stack.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -50),
            stack.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
            
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            shadowView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: -30),
            
            weight.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
            weight.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -10),
            
            expirationDateIndicator.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 8),
            expirationDateIndicator.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -10),
            expirationDateIndicator.heightAnchor.constraint(equalToConstant: 20),
            expirationDateIndicator.widthAnchor.constraint(equalToConstant: 20),
            
            expirationSign.topAnchor.constraint(equalTo: expirationDateIndicator.topAnchor),
            expirationSign.bottomAnchor.constraint(equalTo: expirationDateIndicator.bottomAnchor),
            expirationSign.leadingAnchor.constraint(equalTo: expirationDateIndicator.leadingAnchor),
            expirationSign.trailingAnchor.constraint(equalTo: expirationDateIndicator.trailingAnchor)
            
        ])
    }
    
    private func experationIndication(from dateIndicator: UIView, sign: UILabel, from date1: Date?, to date2: Date?) {
        
        dateIndicator.isHidden = true
        sign.isHidden = true
        
        guard let date1 = date1, let date2 = date2 else { return }
        let differenceOfDays = DateManager.shared.differenceDays(from: date1, to: date2)

        if differenceOfDays >= 0.5 {
            dateIndicator.isHidden = true
            sign.isHidden = true
        } else if differenceOfDays < 0.5 && differenceOfDays >= 0.2 {
            dateIndicator.backgroundColor = .orange
            dateIndicator.isHidden = false
            sign.isHidden = false
        } else {
            dateIndicator.backgroundColor = .red
            dateIndicator.isHidden = false
            sign.isHidden = false
        }
    }
    
    func configure(_ food: FoodRealm) {
        
        image.image = UIImage(named: food.name)
        title.text = food.name.localized()
        colories.text = ("\(food.calories) \("kCal".localized()) / \("100g.".localized())")
        weight.text = ("\(food.weight) \(food.unit.localized())")
        experationIndication(from: expirationDateIndicator, sign: expirationSign, from: food.productionDate, to: food.expirationDate)
    }
}
