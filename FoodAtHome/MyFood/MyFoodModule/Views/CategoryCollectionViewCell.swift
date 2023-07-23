//
//  CategoryCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 16.07.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .dark)
        view.alpha = 0.5
        view.effect = blurEffect
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
       return view
   }()
    
    private let backgroundImage: UIImageView =  {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let categoryImage: UIImageView =  {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let categoryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Light", size: 16)
        label.textColor = .white
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at indexPath: IndexPath) {
        categoryImage.image = UIImage(named: foodListArray[indexPath.row])
        categoryName.text = foodListArray[indexPath.row]
        backgroundImage.image = UIImage(named: "backgroundImage")
    }
    
    private func setupUI() {
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
                
                blurView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 60),
                blurView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -0),
                
                categoryName.topAnchor.constraint(equalTo: blurView.topAnchor),
                categoryName.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 5),
                categoryName.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -5),
                categoryName.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)

        ])
        
    }
    
}
