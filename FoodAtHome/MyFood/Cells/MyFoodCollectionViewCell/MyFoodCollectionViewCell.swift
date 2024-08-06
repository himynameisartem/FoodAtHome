//
//  MyFoodCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 18.04.2024.
//

import UIKit

class MyFoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeShadow(opacity: 0.4)
        configureText()
    }

    private func configureText() {
        foodName.font = UIFont(name: "Inter-ExtraLight", size: 12)
    }
    
    func setData(viewModel: MyFood.ShowMyFood.ViewModel.DisplayedMyFood) {
        foodImage.image = UIImage(named: viewModel.name)
        foodName.text = viewModel.name
    }
}
