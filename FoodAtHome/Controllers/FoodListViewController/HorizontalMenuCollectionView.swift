//
//  HorizontalMenuCollectionView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 09.07.2022.
//

import UIKit

protocol SelectCollectionViewItemProtocol: AnyObject {
    func itemName(name: String)
}

class HorizontalMenuCollectionView: UICollectionView {
    
    private let categoryLayout = UICollectionViewFlowLayout()
    
    weak var cellDelegate: SelectCollectionViewItemProtocol?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryLayout)
        
        configure()
        
        register(HorizontalMenuCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalMenuCell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been emplemented")
    }
    
    private func configure() {
        categoryLayout.minimumInteritemSpacing = 20
        categoryLayout.scrollDirection = .horizontal
        
        showsHorizontalScrollIndicator = false
        
        bounces = false
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        
        delegate = self
        dataSource = self
        selectItem(at: [0,0], animated: true, scrollPosition: [])
        
    }
}

//MARK: - UICollectionViewDataSource

extension HorizontalMenuCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalMenuCell", for: indexPath) as! HorizontalMenuCollectionViewCell
        
        cell.categoryName.text = foodListArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - UICollectionViewDelegate
    
}

extension HorizontalMenuCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        cellDelegate?.itemName(name: foodListArray[indexPath.row])
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalMenuCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let categoryFont = UIFont(name: "Avenir Next", size: 18)
        let categoryAttributes = [NSAttributedString.Key.font : categoryFont as Any]
        let categoryWidth = foodListArray[indexPath.item].size(withAttributes: categoryAttributes).width
        
        return CGSize(width: categoryWidth,
                      height: collectionView.frame.height)
    }
}

//MARK: - CollectionViewCell

class HorizontalMenuCollectionViewCell: UICollectionViewCell {
    
    let categoryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        makeConstraints()
        
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .gray : .none
//            categoryName.textColor = self.isSelected ? .black : .gray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        backgroundColor = .none
        addSubview(categoryName)
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
        
            categoryName.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryName.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
    }
    
}