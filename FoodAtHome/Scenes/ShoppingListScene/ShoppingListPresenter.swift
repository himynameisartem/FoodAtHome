//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListPresentationLogic {
    func presentData(response: ShoppingListModel.ShowFood.Response)
    func presentDeleteFood(response: ShoppingListModel.DeleteFood.Responce)
    func presentMoveToMyFood(response: ShoppingListModel.AddToMyFood.Responce)
}

class ShoppingListPresenter: ShoppingListPresentationLogic {
    weak var viewController: ShoppingListDisplayLogic?
    var worker: ShoppingListWorker?
    
    func presentData(response: ShoppingListModel.ShowFood.Response) {
        worker = ShoppingListWorker()
        guard let worker = worker else { return }
        let food = worker.prepareShoppingList(from: response.food)
        let viewModel = ShoppingListModel.ShowFood.ViewModel(displayedFood: food)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentDeleteFood(response: ShoppingListModel.DeleteFood.Responce) {
        viewController?.deleteFood()
    }
    
    func presentMoveToMyFood(response: ShoppingListModel.AddToMyFood.Responce) {
        let viewModel = ShoppingListModel.AddToMyFood.ViewModel()
        viewController?.displayMoveToMyFood(viewModel: viewModel)
    }
}
