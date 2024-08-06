//
//  FoodListConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import UIKit

class FoodListConfigurator: FoodListConfiguratorProtocol {
    
    func configure(with viewController: FoodListViewController) {
        let presenter = FoodListPresenter(view: viewController)
        let interactor = FoodListInteractor(presenter: presenter)
        let router = FoodListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
