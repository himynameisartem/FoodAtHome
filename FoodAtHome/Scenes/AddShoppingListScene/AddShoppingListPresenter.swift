//
//  AddShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListPresentationLogic {
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response)
    func presentAlertController(response: AddShoppingListModel.AddFood.Response)
}

class AddShoppingListPresenter: AddShoppingListPresentationLogic {
    weak var viewController: AddShoppingListDisplayLogic?
    
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response) {
        let viewModel = AddShoppingListModel.ShowFood.ViewModel(image: response.image, weight: response.weight, unit: response.unit)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentAlertController(response: AddShoppingListModel.AddFood.Response) {
        let viewModel = AddShoppingListModel.AddFood.ViewModel(alert: response.alert)
        viewController?.displayAlertController(viewModel: viewModel)
        
    }
    
}

