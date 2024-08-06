//
//  CategoryDetailsHeaderView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 22.07.2024.
//

import UIKit

class CategoryDetailsHeaderView: UIView {
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerViewHeight = NSLayoutConstraint()
    
    private var containerView: UIView!
    var imageView = UIImageView()
    private var categoryContainerView: UIView!
    var categoryName = UILabel()
    private var blurView: UIVisualEffectView!
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        containerView = UIView()
        self.addSubview(containerView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
        
        categoryContainerView = UIView()
        categoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(categoryContainerView)
        
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryName.font = UIFont(name: "Inter-SemiBold", size: 24)
        categoryName.textColor = .white
        categoryName.alpha = 0.8
        categoryName.adjustsFontSizeToFitWidth = true
        categoryName.minimumScaleFactor = 0.8
        containerView.addSubview(categoryName)
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView()
        blurView.alpha = 0.7
        blurView.effect = blurEffect
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        categoryContainerView.addSubview(blurView)
        
        gradientView = UIView()
        gradientLayer = CAGradientLayer()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemGray5.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
        imageView.addSubview(gradientView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            categoryContainerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            categoryContainerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            categoryContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50),
            categoryContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            blurView.topAnchor.constraint(equalTo: categoryContainerView.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor),
            blurView.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 50),
             
            categoryName.topAnchor.constraint(equalTo: categoryContainerView.topAnchor),
            categoryName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            categoryName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            categoryName.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor),
        ])

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
