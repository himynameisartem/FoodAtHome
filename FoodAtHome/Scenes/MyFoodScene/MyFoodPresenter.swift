//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodPresentationLogic {
    func presentCategories(responce: MyFoodModel.FetchCategories.Responce)
    func presentMyFood(response: MyFoodModel.FetchFoodList.Response)
    func presentFoodDetails(responce: MyFoodModel.FetchFoodDetails.Responce)
    func presentSharedFood(response: MyFoodModel.FetchSharedFood.Responce)
    func presentFoodItemDeletion(response: MyFoodModel.DeleteFood.Responce)
    func presentAllMyFoodRemoving(response: MyFoodModel.RemoveAllMyFood.Responce)
}

class MyFoodPresenter: MyFoodPresentationLogic {
    
    weak var viewController: MyFoodDisplayLogic?
    var worker: MyFoodWorker?
    var foodManager: FoodManager?
    var dateCalculator: DateCalculatorManager?
    
    func presentCategories(responce: MyFoodModel.FetchCategories.Responce) {
        worker = MyFoodWorker()
        guard let displayedCategories = worker?.prepareCategoriesForDisplay(responce.categories) else { return }
        let viewModel = MyFoodModel.FetchCategories.ViewModel(displayedCategories: displayedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentMyFood(response: MyFoodModel.FetchFoodList.Response) {
        worker = MyFoodWorker()
        guard let displayedMyFood = worker?.prepareFoodForDisplay(response.food) else { return }
        let viewModel = MyFoodModel.FetchFoodList.ViewModel(displayedMyFood: displayedMyFood)
        viewController?.displayFoodList(viewModel: viewModel)
    }
    
    func presentFoodDetails(responce: MyFoodModel.FetchFoodDetails.Responce) {
        worker = MyFoodWorker()
        foodManager = FoodManager()
        dateCalculator = DateCalculatorManager()
        let displayedDetailsFood = MyFoodModel.FetchFoodDetails.ViewModel.DiplayedDetails(
                                    name: responce.foodDetails.name.localized(),
                                    weight: responce.foodDetails.weight,
                                    unit: responce.foodDetails.unit,
                                    productionDate: foodManager?.getFormattedProductionDate(for: responce.foodDetails) ?? "-",
                                    expirationDate: foodManager?.getFormattedExpirationDate(for: responce.foodDetails) ?? "-",
                                    daysLeft: foodManager?.getFormattedDaysLeft(for: responce.foodDetails) ?? "-",
                                    expirationProgress: dateCalculator?.calculateExpirationDistance(
                                        productionDate: responce.foodDetails.productionDate,
                                        expirationDate: responce.foodDetails.expirationDate))
        let viewModel = MyFoodModel.FetchFoodDetails.ViewModel(DiplayedDetails: displayedDetailsFood)
        viewController?.displayFoodDetails(viewModel: viewModel)
    }
    
    func presentFoodItemDeletion(response: MyFoodModel.DeleteFood.Responce) {
        viewController?.didRemoveFoodItem()
    }
    
    func presentAllMyFoodRemoving(response: MyFoodModel.RemoveAllMyFood.Responce) {
        let viewModel = MyFoodModel.RemoveAllMyFood.ViewModel(alertController: response.alertController)
        viewController?.didRemoveAllMyFood(viewModel: viewModel)
    }
    
    func presentSharedFood(response: MyFoodModel.FetchSharedFood.Responce) {
        worker = MyFoodWorker()
        guard let worker = worker else { return }
        let viewModel = MyFoodModel.FetchSharedFood.ViewModel(foodList: worker.formatFoodForSharing(response.sharedFood))
        viewController?.displaySharedFood(viewModel: viewModel)
    }
}
