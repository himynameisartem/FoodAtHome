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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        containerView.makeShadow(opacity: 0.4)
        addFoodButton.configuration?.background.cornerRadius = addFoodButton.frame.height
        addFoodButton.makeShadow(opacity: 0.4)
    }
    
}
