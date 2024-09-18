//
//  CategoryMyFoodCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 16.04.2024.
//

import UIKit

class CategoryMyFoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeShadow(opacity: 0.1)
        configureText()
    }
    
    private func configureText() {
        categoryName.font = UIFont(name: "Inter-Light", size: 16)
    }
    
    func setData(viewModel: MyFood.ShowCategories.ViewModel.DiplayedCategories) {
        categoryImage.image = UIImage(named: viewModel.imageName)
        categoryName.text = viewModel.name
    }
}
