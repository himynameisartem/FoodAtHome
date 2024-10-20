//
//  ShoppingListConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

class OldShoppingListConfigurator: OldShoppingListConfiguratorProtocol {
    func configure(with viewController: OldShoppingListViewController) {
        let presenter = OldShoppingListPresenter(view: viewController)
        let interactor = OldShoppingListInteractor(presenter: presenter)
        let router = OldShoppingListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
