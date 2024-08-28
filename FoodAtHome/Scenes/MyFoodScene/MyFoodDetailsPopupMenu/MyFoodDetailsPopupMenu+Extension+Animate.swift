//
//  MyFoodDetailsPopupMenu+Extension+Animate.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 22.08.2024.
//

import UIKit

extension MyFoodDetailsPopupMenu {
    
    func findPosition(for view: UIView, and arrowView: UIImageView, from collectionView: UICollectionView) -> PopUpMenuPosition? {
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
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
        
        //
        //Wheh here will tabBar:
        //        guard let tabBarFrame = tabBarController?.tabBar.frame else { return }
        //        let tabBarBorder = view.frame.height + tabBarFrame
        //
        
        let tabBarBorder = view.frame.height

        if positionY + 110 > tabBarBorder - 10 {
            positionY -= cell.frame.height + 150
            arrowPositionY = positionY + 126
            arrowView.image = UIImage(systemName: "arrowtriangle.down.fill")
        } else {
            arrowView.image = UIImage(systemName: "arrowtriangle.up.fill")
        }
        
        let width: CGFloat = 220
        let height: CGFloat = 110
        let startPosition = CGRect(x: positionX , y: positionY + height / 2, width: 0, height: 0)
        let intermediatePosition = CGRect(x: positionX - width / 2, y: positionY, width: width + 10, height: height + 10)
        let endPosition = CGRect(x: positionX - width / 2, y: positionY, width: width, height: height)
        let startArrowPosition = CGRect(x: positionX, y: positionY + height / 2, width: 0, height: 0)
        let endArrowPosition = CGRect(x: arrowPositionX - 10, y: arrowPositionY - 18, width: 20, height: 20)
        
        return PopUpMenuPosition(startPostion: startPosition, intermediatePosition: intermediatePosition, endPosition: endPosition, startArrowPosition: startArrowPosition, endArrowPosition: endArrowPosition)
    }
}
