//
//  AddFoodMenuPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.12.2024.
//

import UIKit

protocol AddFoodMenuPresentationLogic {
    func presentFood(responce: AddFoodMenuModel.ShowFood.Responce)
}

class AddFoodMenuPresenter: AddFoodMenuPresentationLogic {
    
    weak var view: AddFoodMenu?
    
    func presentFood(responce: AddFoodMenuModel.ShowFood.Responce) {
        let viewModel = AddFoodMenuModel.ShowFood.ViewModel(viewModel: responce.food)
        view?.displayFood(viewModel: viewModel)
    }
}
