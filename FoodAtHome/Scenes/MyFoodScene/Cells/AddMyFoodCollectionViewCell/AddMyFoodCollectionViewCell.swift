//
//  AddMyFoodCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.06.2024.
//

import UIKit

class AddMyFoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addFoodButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addFoodButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        addFoodButton.makeShadow(opacity: 0.4)
        addFoodButton.configuration?.background.cornerRadius = addFoodButton.frame.height
        addFoodButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
