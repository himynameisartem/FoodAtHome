//
//  UIView + Extensions.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.04.2024.
//

import UIKit

extension UIView {
    
    enum ColorForAnimation {
        case withColor, withoutColor
    }
    
    func showAnimation(for color: ColorForAnimation, _ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.85, y: 0.85)
            if color == .withColor {
                if let button = self as? UIButton {
                    button.configuration?.background.backgroundColor = .addButtonSelectColor
                } else {
                    self?.backgroundColor = .addButtonSelectColor
                }
            }
        }) {  (done) in
            completionBlock()
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                if color == .withColor {
                    if let button = self as? UIButton {
                        button.configuration?.background.backgroundColor = .backgroundCard
                    } else {
                        self?.backgroundColor = .white
                    }
                }
            }
        }
    }
    
    func makeShadow(opacity: Float) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}
