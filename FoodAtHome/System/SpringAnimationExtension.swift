//
//  SpringAnimationExtension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 11.08.2023.
//

import UIKit


public extension UIView {
    
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
                self?.backgroundColor = .addButtonSelectColor
            }
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                if color == .withColor {
                    self?.backgroundColor = .white
                }
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
