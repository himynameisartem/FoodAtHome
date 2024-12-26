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
    func presentDeleteFood(response: ShoppingList.DeleteFood.Responce)
    func presentAddtoMyFood(responce: ShoppingList.AddToMyFood.Responce)
    func presentChangeFood(response: ShoppingList.ChangeFood.Responce)
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
    
    func presentAddtoMyFood(responce: ShoppingList.AddToMyFood.Responce) {
        let viewModel = ShoppingList.AddToMyFood.ViewModel(food: responce.food)
        viewController?.addToMyFood(viewModel: viewModel)
    }
    
    func presentChangeFood(response: ShoppingList.ChangeFood.Responce) {
        let viewModel = ShoppingList.ChangeFood.ViewModel(food: response.food)
        viewController?.changeFood(viewModel: viewModel)
    }
    
    func presentDeleteFood(response: ShoppingList.DeleteFood.Responce) {
        viewController?.deleteFood()
    }
}
