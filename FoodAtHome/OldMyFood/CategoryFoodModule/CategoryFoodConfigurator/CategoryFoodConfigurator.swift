//
//  CategoryFoodConfigurator.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

class CategoryFoodConfigurator: CategoryFoodConfiguratorProtocol {
    func configure(with view: CategoryListViewController, _ food: [FoodRealm], categoryName: String) {
        let presenter = CategoryFoodPresenter(view: view)
        let interactor = CategoryFoodInteractor(presenter: presenter, food: food, categoryName: categoryName)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
