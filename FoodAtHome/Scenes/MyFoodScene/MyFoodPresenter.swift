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
    func presentChangeFoodMenu(response: MyFood.ChangeFood.Responce)
    func presentDeleteFood(response: MyFood.DeleteFood.Responce)
    func presentRemoveAllFood(response: MyFood.RemoveAllFood.Responce)
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
                                    unit: responce.foodDetails.unit,
                                    productionDate: responce.foodDetails.productionDateString() ?? "-",
                                    expirationDate: responce.foodDetails.expirationDateString() ?? "-",
                                    daysLeft: responce.foodDetails.daysLeftString() ?? "-",
                                    distaceIndicator: responce.foodDetails.distanceBetweenProductionAndExpiration())
        let viewModel = MyFood.showDetailFood.ViewModel(DiplayedDetails: displayedDetailsFood)
        viewController?.displayFoodDetails(viewModel: viewModel)
    }
    
    func presentChangeFoodMenu(response: MyFood.ChangeFood.Responce) {
        let food = FoodRealm()
        food.name = response.food.name
        food.type = response.food.type
        food.weight = response.food.weight
        food.unit = response.food.unit
        food.calories = response.food.calories
        food.productionDate = response.food.productionDate
        if response.food.expirationDate != nil {
            food.expirationDate = response.food.expirationDate
        }
        if response.food.consumeUp != nil {
            food.consumeUp = response.food.consumeUp
        }
        let viewModel = MyFood.ChangeFood.ViewModel(food: food)
        viewController?.displayChangeFood(viewModel: viewModel)
    }
    
    func presentDeleteFood(response: MyFood.DeleteFood.Responce) {
        viewController?.deleteFood()
    }
    
    func presentRemoveAllFood(response: MyFood.RemoveAllFood.Responce) {
        self.viewController?.removeAllFood()
    }
}
