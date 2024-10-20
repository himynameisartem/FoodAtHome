//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ShoppingListPresentationLogic {
    func presentData(response: ShoppingList.ShoppingListModel.Response)
}

class ShoppingListPresenter: ShoppingListPresentationLogic {
    weak var viewController: ShoppingListDisplayLogic?
    var worker: ShoppingListWorker?
    
    func presentData(response: ShoppingList.ShoppingListModel.Response) {
        worker = ShoppingListWorker()
        guard let worker = worker else { return }
        let food = worker.prepareShoppingList(from: response.food)
        let viewModel = ShoppingList.ShoppingListModel.ViewModel(displayedFood: food)
        viewController?.displayData(viewModel: viewModel)
    }
}
