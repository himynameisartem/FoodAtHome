//
//  CategoryListTableViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2022.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {
        
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Light", size: 18)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            self.addSubview(image)
            contentView.addSubview(name)
        
        addConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
        
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 60),
            image.widthAnchor.constraint(equalToConstant: 60),
            
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100)
            
        ])
        
    }
}
