//
//  UIViewControllerAnimatedTransitioning + Extension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.02.2025.
//

import UIKit

extension UIViewControllerAnimatedTransitioning {
    
    func openAndCloseCustomVC(for viewController: UIViewController, using transitionContext: any UIViewControllerContextTransitioning, and dimmingView: UIVisualEffectView) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view else { return }
        
        let isPresenting = transitionContext.view(forKey: .to) != nil
        let presentingView = isPresenting ? toView : fromView
        
        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }
        
        let screenSize = UIScreen.main.bounds.size
        let heightSize = ((screenSize.width - 40) / 2) + 350
        let size = CGSize(width: screenSize.width - 40,
                          height: heightSize)
        let offScreenFrame = CGRect(origin: CGPoint(x: (screenSize.width / 2) - (size.width / 2),
                                                    y: -screenSize.height), size: size)
        let onScreenFrame = CGRect(origin: CGPoint(x: (screenSize.width / 2) - (size.width / 2) ,
                                                   y: (screenSize.height / 2) - (size.height / 2)), size: size)
        
        presentingView.frame = isPresenting ? offScreenFrame : onScreenFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            UIView.animate(withDuration: 0.3) {
                viewController.navigationController?.tabBarController?.view.addSubview(dimmingView)
                dimmingView.alpha = 1
            } completion: { isDone in
                if isDone {
                    UIView.animate(withDuration: animationDuration) {
                        presentingView.frame = onScreenFrame
                    }
                    transitionContext.completeTransition(isDone)
                }
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                presentingView.removeFromSuperview()
            } completion: { isDone in
                if isDone {
                    UIView.animate(withDuration: 0.3) {
                        dimmingView.alpha = 0
                    } completion: { isDone in
                        dimmingView.removeFromSuperview()
                        transitionContext.completeTransition(isDone)
                    }
                }
            }
        }
    }
}
    
    

