//
//  FoodListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 30.08.2024.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addFoodButton: UIButton!
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(from viewModel: ChoiseFood.ShowFood.ViewModel.DispalyedFood) {
        foodImage.image = UIImage(named: viewModel.imageName)
        foodNameLabel.text = viewModel.name
        caloriesLabel.text = viewModel.calories + " " + "kCal".localized() + " / " + "100g.".localized()
    }
    
    private func setupUI() {
        containerView.makeShadow(opacity: 0.4)
        addFoodButton.configuration?.background.cornerRadius = addFoodButton.frame.height
        addFoodButton.makeShadow(opacity: 0.4)
        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        foodNameLabel.font = UIFont(name: "Inter-Light", size: 15)
        caloriesLabel.font = UIFont(name: "Inter-ExtraLight", size: 10)
        caloriesLabel.alpha = 0.7
        
        addFoodButton.addTarget(self, action: #selector(callAddFoodMenu), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            foodNameLabel.topAnchor.constraint(equalTo: foodImage.topAnchor),
            foodNameLabel.leadingAnchor.constraint(equalTo: caloriesLabel.leadingAnchor),
            foodNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func callAddFoodMenu() {
        buttonAction?()
    }
}
