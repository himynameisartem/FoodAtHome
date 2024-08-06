//
//  MyFoodConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

class OldMyFoodConfigurator: OldMyFoodConfiguratorProtocol {
    func configure(with viewController: OldMyFoodViewController) {
        let presenter = OldMyFoodPresenter(view: viewController)
        let interactor = OldMyFoodInteractor(presenter: presenter)
        let router = OldMyFoodRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
