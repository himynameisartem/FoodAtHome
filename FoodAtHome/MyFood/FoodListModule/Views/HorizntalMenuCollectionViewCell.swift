//
//  HorizntalMenuCollectionViewCell.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import UIKit

class HorizontalMenuCollectionViewCell: UICollectionViewCell {
    
    private var selectedCellImage: UIImageView!
    private var categoryName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    override var isSelected: Bool {
        didSet {
            categoryName.font = self.isSelected ? UIFont(name: "Inter-SemiBold", size: 24) : UIFont(name: "Inter-ExtraLight", size: 24)
            selectedCellImage.isHidden = self.isSelected ? false : true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at indexPath: IndexPath) {
        categoryName.text = foodCatigoriesList[indexPath.row].localized()
    }
    
    private func setupUI() {
        
        backgroundColor = .none
        
        selectedCellImage = UIImageView(image: UIImage(named: "SelectedCell"))
        selectedCellImage.translatesAutoresizingMaskIntoConstraints = false
        selectedCellImage.isHidden = true
        addSubview(selectedCellImage)
        
        categoryName = UILabel()
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryName.font = UIFont(name: "Inter-ExtraLight", size: 24)
        categoryName.textAlignment = .center
        
        if self.isSelected {
            selectedCellImage.addSubview(categoryName)
        } else {
            addSubview(categoryName)
        }
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            categoryName.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryName.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedCellImage.topAnchor.constraint(equalTo: topAnchor),
            selectedCellImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedCellImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedCellImage.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
    }
    
}
