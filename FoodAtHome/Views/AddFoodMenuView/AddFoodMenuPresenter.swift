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
        let displayedFood = AddFoodMenuModel.ShowFood.ViewModel.DisplayedFood(
            imageName: responce.food.name,
            weight: responce.food.weight,
            productionDate:  "",
            expirationDate:  "",
            consumeUp:  "")
        let viewModel = AddFoodMenuModel.ShowFood.ViewModel(displayedFood: displayedFood)
        view?.displayFood(viewModel: viewModel)
    }
}
