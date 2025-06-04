//
//  TabBarController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var tabBarView: UITabBar!
    
    private var roundLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOriginalTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.safeAreaInsets.bottom == 0.0 {
            tabBar.frame.origin.y -= 20
        }
        updateTabBarDesign()
    }
    
    private func setupOriginalTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        
        roundLayer = CAShapeLayer()
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        selectedIndex = 1
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
    }

    private func updateTabBarDesign() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
                
        let path = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: 77),
            cornerRadius: height / 2
        )
                
        roundLayer.path = path.cgPath
        roundLayer.fillColor = UIColor.backgroundCard.cgColor
        
        roundLayer.shadowColor = UIColor.gray.cgColor
        roundLayer.shadowRadius = 8
        roundLayer.shadowOpacity = 0.5
        roundLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        roundLayer.fillColor = UIColor.backgroundCard.cgColor
    }
    
    //    private let roundLayer = CAShapeLayer()
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        if view.safeAreaInsets.bottom == 0.0 {
    //            tabBar.frame.origin.y -= 20
    //        }
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        setupTabBar()
    //        setTabBarAppearance()
    //    }
    //
    //    private func setupTabBar() {
    //        selectedIndex = 1
    //    }
    //
    //    func setTabBarAppearance() {
    //        let positionOnX: CGFloat = 10
    //        let positionOnY: CGFloat = 14
    //        let width = tabBar.bounds.width - positionOnX * 2
    //        let height = tabBar.bounds.height + positionOnY * 2
    //
    //        let roundLayer = CAShapeLayer()
    //
    //        let bezierPath = UIBezierPath(
    //            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height),
    //            cornerRadius: height / 2
    //        )
    //
    //        roundLayer.path = bezierPath.cgPath
    //
    //        tabBar.layer.insertSublayer(roundLayer, at: 0)
    //        tabBar.itemWidth = width / 3
    //        tabBar.itemPositioning = .fill
    //
    //        roundLayer.shadowColor = UIColor.gray.cgColor
    //        roundLayer.shadowRadius = 8
    //        roundLayer.shadowOpacity = 0.5
    //        roundLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    //
    //        roundLayer.fillColor = UIColor.backgroundCard.cgColor
    //        tabBar.tintColor = .tabBarItemAccent
    //        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.5569999814, green: 0.5569999814, blue: 0.5759999752, alpha: 1)
    //        }
}


