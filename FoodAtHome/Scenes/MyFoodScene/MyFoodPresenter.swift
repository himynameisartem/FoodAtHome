//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodPresentationLogic {
    func presentCategories(responce: MyFood.ShowCategories.Responce)
    func presentMyFood(response: MyFood.ShowMyFood.Response)
    func presentDetailsFood(responce: MyFood.showDetailFood.Responce)
}

class MyFoodPresenter: MyFoodPresentationLogic {
    
    weak var viewController: MyFoodDisplayLogic?
    var worker: MyFoodWorker?
    
    func presentCategories(responce: MyFood.ShowCategories.Responce) {
        worker = MyFoodWorker()
        guard let displayedCategories = worker?.getDisplayedCategories(from: responce.categories) else { return }
        let viewModel = MyFood.ShowCategories.ViewModel(displayedCategories: displayedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentMyFood(response: MyFood.ShowMyFood.Response) {
        worker = MyFoodWorker()
        guard let displayedMyFood = worker?.getDisplayedMyFood(from: response.food) else { return }
        let viewModel = MyFood.ShowMyFood.ViewModel(displayedMyFood: displayedMyFood)
        viewController?.displayMyFood(viewModel: viewModel)
    }
    
    func presentDetailsFood(responce: MyFood.showDetailFood.Responce) {
        worker = MyFoodWorker()
        let displayedDetailsFood = MyFood.showDetailFood.ViewModel.DiplayedDetails(
                                    name: responce.foodDetails.name.localized(),
                                    weight: responce.foodDetails.weight,
                                    productionDate: responce.foodDetails.productionDateString() ?? "-",
                                    expirationDate: responce.foodDetails.expirationDateString() ?? "-",
                                    consumeUp: responce.foodDetails.consumeUpString() ?? "-",
                                    distaceIndicator: responce.foodDetails.distanceBetweenProductionAndExpiration())
        let viewModel = MyFood.showDetailFood.ViewModel(DiplayedDetails: displayedDetailsFood)
        viewController?.displayFoodDetails(viewModel: viewModel)
    }
}
