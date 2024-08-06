//
//  ShoppingListConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

class ShoppingListConfigurator: ShoppingListConfiguratorProtocol {
    func configure(with viewController: ShoppingListViewController) {
        let presenter = ShoppingListPresenter(view: viewController)
        let interactor = ShoppingListInteractor(presenter: presenter)
        let router = ShoppingListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
