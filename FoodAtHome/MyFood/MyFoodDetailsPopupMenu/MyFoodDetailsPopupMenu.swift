//
//  FoodDetailsView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.04.2024.
//

import UIKit

class MyFoodDetailsPopupMenu: UIView {
    
    @IBOutlet weak var contentView: UIView!
    private let arrowView = UIImageView()
    private let dimmingView = UIView()
    private let gestureForCloseMenu = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        gestureForCloseMenu.addTarget(self, action: #selector(tapToClose))
    }
}

extension MyFoodDetailsPopupMenu {
    
    func setupPopUpMenu(for view: UIView, with collectionView: UICollectionView, at indexPath: IndexPath) {
        
        dimmingView.frame = view.bounds
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let touchPointInCollectionView = collectionView.panGestureRecognizer.location(in: collectionView)
        let touchPointInCell = collectionView.convert(touchPointInCollectionView, to: cell)
        let positionCellY = cell.frame.height - touchPointInCell.y + 20
        var positionX = touchPointInCollectionView.x  - (touchPointInCell.x - cell.frame.width / 2)
        var positionY = (touchPointInCollectionView.y  - collectionView.contentOffset.y + (view.frame.height - collectionView.frame.height)) + positionCellY
        let arrowPositionX = positionX
        var arrowPositionY = positionY
        if positionX - 110 < 10 {
            positionX = 120
        } else if positionX + 110 > view.frame.width {
            positionX = view.frame.width - 120
        }
        
        //Wheh here will tabBar:
        //        guard let tabBarFrame = tabBarController?.tabBar.frame else { return }
        //        let tabBarBorder = view.frame.height + tabBarFrame
        
        let tabBarBorder = view.frame.height
        if positionY + 110 > tabBarBorder - 10 {
            positionY -= cell.frame.height + 150
            arrowPositionY = positionY + 126
            arrowView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        let width: CGFloat = 220
        let height: CGFloat = 110
        let position = CGRect(x: positionX - width / 2, y: positionY, width: width, height: height)
        
        contentView.frame = frame(forAlignmentRect: position)
        
        let arrowPosition = CGRect(x: arrowPositionX - 10, y: arrowPositionY - 18, width: 20, height: 20)
        arrowView.frame = frame(forAlignmentRect: arrowPosition)
        
        view.addSubview(dimmingView)
        view.addSubview(self)
        view.addSubview(arrowView)
        dimmingView.addGestureRecognizer(gestureForCloseMenu)
    }
    
    private func setupUI() {
        arrowView.image = UIImage(systemName: "arrowtriangle.up.fill")
        arrowView.tintColor = .white
        dimmingView.alpha = 0.5
        dimmingView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        
    }
    
    @objc func tapToClose() {
        dimmingView.removeFromSuperview()
        arrowView.removeFromSuperview()
        removeFromSuperview()
    }
}
