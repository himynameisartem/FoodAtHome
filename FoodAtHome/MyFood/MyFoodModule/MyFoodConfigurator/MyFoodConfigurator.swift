//
//  MyFoodConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

class MyFoodConfigurator: MyFoodConfiguratorProtocol {
    func configure(with viewController: MyFoodViewController) {
        let presenter = MyFoodPresenter(view: viewController)
        let interactor = MyFoodInteractor(presenter: presenter)
        let router = MyFoodRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
