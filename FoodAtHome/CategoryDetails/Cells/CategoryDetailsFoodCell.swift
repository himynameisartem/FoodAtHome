//
//  CategoryDetailsFoodCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 22.07.2024.
//

import UIKit

class CategoryDetailsFoodCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CategoryDetailsFoodCell {
    
    private func setupUI() {
        containerView.makeShadow(opacity: 0.4)
        foodLabel.font = UIFont(name: "Inter", size: 17)
        caloriesLabel.font = UIFont(name: "Inter-ExtraLight", size: 14)
        weightLabel.font = UIFont(name: "Inter", size: 17)
        foodImageView.clipsToBounds = true
    }
}
