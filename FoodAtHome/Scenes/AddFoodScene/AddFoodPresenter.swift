//
//  AddFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodPresentationLogic {
    func presentData(response: AddFoodModel.ShowFood.Response)
}

class AddFoodPresenter: AddFoodPresentationLogic {
  weak var viewController: AddFoodDisplayLogic?
    var worker: AddFoodWorker?
  
    func presentData(response: AddFoodModel.ShowFood.Response) {
        worker = AddFoodWorker()
        let foodManager = FoodManager()
        let productionDate = foodManager.getFormattedProductionDate(for: response.food)
        let expirationDate = foodManager.getFormattedExpirationDate(for: response.food)
        let consumeUp = foodManager.getFormattedConsumeUp(for: response.food)
        guard let  image = worker?.getImage(from: response.food.name) else { return }
        let displayedFood = AddFoodModel.ShowFood.ViewModel.DisplayedFood(image: image,
                                                                      weight: response.food.weight,
                                                                      productionDate: productionDate,
                                                                      expirationDate: expirationDate,
                                                                      consumeUp: consumeUp)
        let viewModel = AddFoodModel.ShowFood.ViewModel(displayedFood: displayedFood)
        viewController?.displayData(viewModel: viewModel)
  }
  
}
