//
//  ContextualActionViewManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 18.09.2023.
//

import UIKit

class ContextualActionViewManager {
    
    static let shared = ContextualActionViewManager()
    
    func setupAction(action: UIContextualAction, imageName: String) {
        action.backgroundColor = .systemGray5
        action.image = UIImage(named: imageName)

        action.image?.withRenderingMode(.alwaysOriginal)
        let buttonSize = CGSize(width: 50, height: 50)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        action.image = UIGraphicsImageRenderer(size: buttonSize).image { _ in
            UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize), cornerRadius: buttonSize.width / 2).addClip()
            action.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize).inset(by: insets))
        }
    }
    
}
