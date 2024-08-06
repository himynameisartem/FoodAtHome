//
//  CategoryCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 16.07.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private var shadowView: UIView!
    private var blurView: UIVisualEffectView!
    private var backgroundImage: UIImageView!
    private var categoryView: UIView!
    private var categoryImage: UIImageView!
    private var categoryName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at indexPath: IndexPath) {
        if foodCatigoriesList[indexPath.row] == "Meat Products" {
            categoryImage.image = UIImage(named: "Meat Products (Cover)")
        } else {
            categoryImage.image = UIImage(named: foodCatigoriesList[indexPath.row])
        }
        categoryName.text = foodCatigoriesList[indexPath.row].localized()
    }
    
    private func setupUI() {
        
        
        shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowView.layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView()
        blurView.alpha = 0.5
        blurView.effect = blurEffect
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        
        backgroundImage = UIImageView(image: UIImage(named: "backgroundImage"))
        backgroundImage.layer.cornerRadius = 10
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        
        categoryView = UIView()
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.layer.cornerRadius = 10
        
        categoryImage = UIImageView()
        categoryImage.layer.cornerRadius = 10
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.clipsToBounds = true
        categoryImage.contentMode = .scaleAspectFill
        
        categoryName = UILabel()
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryName.font = UIFont(name: "Inter-Light", size: 16)
        categoryName.textColor = .white
        categoryName.contentMode = .center
        categoryName.textAlignment = .center
        categoryName.numberOfLines = 0
        categoryName.minimumScaleFactor = 0.8
        categoryName.adjustsFontSizeToFitWidth = true
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(categoryView)
        categoryView.addSubview(backgroundImage)
        categoryView.addSubview(categoryImage)
        categoryImage.addSubview(blurView)
        categoryView.addSubview(categoryName)
    }
    
    private func setupConstraints() {
     
        NSLayoutConstraint.activate([
                        
                shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                
                categoryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                
                backgroundImage.topAnchor.constraint(equalTo: categoryView.topAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor),
                
                categoryImage.topAnchor.constraint(equalTo: categoryView.topAnchor),
                categoryImage.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
                categoryImage.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
                categoryImage.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor),
                
                blurView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -0),
                blurView.heightAnchor.constraint(equalToConstant: frame.height / 2.6),
                
                categoryName.topAnchor.constraint(equalTo: blurView.topAnchor),
                categoryName.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 5),
                categoryName.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -5),
                categoryName.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)

        ])
        
    }
    
}
