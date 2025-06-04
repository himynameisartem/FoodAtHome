//
//  ShoppingListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 16.10.2024.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(viewModel: ShoppingListModel.FetchShoppingList.ViewModel.DisplayedFood) {
        foodImageView.image = UIImage(named: viewModel.imageName)
        foodNameLabel.text = viewModel.name
        weightLabel.text = viewModel.weight + " " + viewModel.unit
        caloriesLabel.text = viewModel.calories + " " + "kCal".localized() + "/" + "100g.".localized()
    }
    
    private func setupUI() {
        containerView.makeShadow(opacity: 0.4)
        foodNameLabel.font = UIFont(name: "Inter", size: 17)
        caloriesLabel.font = UIFont(name: "Inter-ExtraLight", size: 14)
        weightLabel.font = UIFont(name: "Inter", size: 17)
        foodImageView.clipsToBounds = true
    }
}
