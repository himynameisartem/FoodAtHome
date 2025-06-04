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
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.isHidden = true
        configureUI()
    }

    private func configureUI() {
        makeShadow(opacity: 0.3)
        foodName.font = UIFont(name: "Inter-ExtraLight", size: 12)
        layer.masksToBounds = true
    }
    
    func setData(viewModel: MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood) {
        foodImage.image = UIImage(named: viewModel.imageName)
        foodName.text = viewModel.name
        if viewModel.daysLeftIndicator {
            indicatorView.isHidden = false
        } else {
            indicatorView.isHidden = true
        }
    }
}
