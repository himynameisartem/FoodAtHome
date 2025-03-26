//
//  AddShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListPresentationLogic {
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response)
}

class AddShoppingListPresenter: AddShoppingListPresentationLogic {
    weak var viewController: AddShoppingListDisplayLogic?
    
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response) {
        let viewModel = AddShoppingListModel.ShowFood.ViewModel(image: response.image, weight: response.weight, unit: response.unit)
        viewController?.displayData(viewModel: viewModel)
    }
    
}

