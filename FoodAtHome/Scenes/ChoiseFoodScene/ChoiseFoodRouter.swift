//
//  ChoiseFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

protocol ChoiseFoodRoutingLogic {
//    func showAddFoodMenu(with viewModel: ChoiseFood.AddFood.ViewModel)
}


class ChoiseFoodRouter: NSObject, ChoiseFoodRoutingLogic {
    
    weak var viewController: ChoiseFoodViewController?
    
//    func showAddFoodMenu(with viewModel: ChoiseFood.AddFood.ViewModel) {
//        guard let viewController = viewController else { return }
//        let addFoodMenu = Bundle.main.loadNibNamed("AddFoodMenu", owner: nil)?.first as! AddFoodMenu
//        addFoodMenu.delegate = viewController
//        viewController.view.addSubview(addFoodMenu)
//        addFoodMenu.showMenu(size: nil)
//    }
}
