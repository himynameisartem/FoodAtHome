//
//  TabBarViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2022.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    private var isBottom: Bool {
        if #available(iOS 13.0, *), UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    
    private var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        generateTabBar()
        setupConstraints()
        setTabBarAppearance()
    }
}

extension TabBarViewController {

    private func setupUI() {
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)

        if !isBottom {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        }
                
     }
    

    
    private func generateTabBar() {

        let availableFoodVC: MyFoodViewController = MyFoodViewController.loadFromStoryboard()

        let navVC = UINavigationController()
//        navVC.viewControllers = [MyFoodViewController()]
        navVC.viewControllers = [availableFoodVC]
        let shoppingListNavVC = UINavigationController()
        shoppingListNavVC.viewControllers = [ShoppingListViewController()]
        
        viewControllers = [
                           generateViewController(viewController: shoppingListNavVC,
                                                  title: "Shopping List".localized(),
                                                  image: UIImage(systemName: "list.bullet.rectangle.portrait.fill")),
                           generateViewController(viewController: availableFoodVC,
                                                  title: "Food at Home".localized(),
                                                  image: UIImage(systemName: "house.fill")),
                           generateViewController(viewController: UIViewController(),
                                                  title: "Share".localized(),
                                                  image: UIImage(systemName: "square.and.arrow.up"))
        ]
        
        tabBar.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        let xPosition = (view.frame.width / 3) * 2
        let height = tabBar.bounds.height + 28
        let yPosition = -(height - tabBar.frame.height) / 2
        let width = view.frame.width / 3
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPosition),
            shareButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: yPosition),
            shareButton.heightAnchor.constraint(equalToConstant: height),
            shareButton.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    private func generateViewController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
    }
    
    private func setTabBarAppearance() {
        
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 3
        tabBar.itemPositioning = .centered
        
        roundLayer.shadowColor = UIColor.gray.cgColor
        roundLayer.shadowRadius = 8
        roundLayer.shadowOpacity = 0.5
        roundLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        roundLayer.fillColor = UIColor.mainTabBarColor.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}

extension TabBarViewController {
    
    @objc private func shareButtonTapped() {
        
        var text = ""
        
        if tabBar.selectedItem?.title == "Shopping List".localized() {
            text = FoodManager.shared.shareString(listType: .shoppingList)
        } else if tabBar.selectedItem?.title == "Food at Home".localized() {
            text = FoodManager.shared.shareString(listType: .MyFoodList)
        }
        
        let controller = UIActivityViewController(
            activityItems: [text],
          applicationActivities: nil
        )
        controller.popoverPresentationController?.sourceView = shareButton
        present(controller, animated: true, completion: nil)
        
    }
}
