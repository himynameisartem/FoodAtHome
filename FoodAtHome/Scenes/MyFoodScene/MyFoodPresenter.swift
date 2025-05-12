//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodPresentationLogic {
    func presentCategories(response: MyFoodModel.FetchCategories.Response)
    func presentMyFood(response: MyFoodModel.FetchFoodList.Response)
    func presentEditingFood(response: MyFoodModel.PrepareEditing.Response)
    func presentFoodDetails(response: MyFoodModel.FetchFoodDetails.Response)
    func presentSharedFood(response: MyFoodModel.FetchSharedFood.Response)
    func presentFoodItemDeletion(response: MyFoodModel.DeleteFood.Response)
    func presentAllMyFoodRemoving(response: MyFoodModel.RemoveAllMyFood.Response)
    func presentConfirmRemoveAllMyFood(response: MyFoodModel.ConfirmRemoveAllMyFood.Response)
}

class MyFoodPresenter: MyFoodPresentationLogic {
    
    weak var viewController: MyFoodDisplayLogic?
    private let dateManager: DateManagerProtocol
    
    init (dateManager: DateManagerProtocol) {
        self.dateManager = dateManager
    }
        
    func presentCategories(response: MyFoodModel.FetchCategories.Response) {
        let categories = response.categories.map { category in
            MyFoodModel.FetchCategories.ViewModel.DisplayedCategories(
                name: category.localized(),
                imageName: category)
        }
        let viewModel = MyFoodModel.FetchCategories.ViewModel(displayedCategories: categories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentMyFood(response: MyFoodModel.FetchFoodList.Response) {
        let displayedMyFood = response.food.map { food in
            MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood(name: food.name.localized(),
                                                                imageName: food.name,
                                                                daysLeftIndicator: dateManager.isExpired(food.productionDate,
                                                                                                         food.expirationDate)
            )
        }
        let viewModel = MyFoodModel.FetchFoodList.ViewModel(displayedMyFood: displayedMyFood)
        viewController?.displayFoodList(viewModel: viewModel)
    }
    
    func presentFoodDetails(response: MyFoodModel.FetchFoodDetails.Response) {
        let displayedDetailsFood = MyFoodModel.FetchFoodDetails.ViewModel.DisplayedDetails(
                                    name: response.foodDetails.name.localized(),
                                    weight: response.foodDetails.weight,
                                    unit: response.foodDetails.unit,
                                    productionDate: dateManager.getFormattedProductionDate(for: response.foodDetails) ?? "-",
                                    expirationDate: dateManager.getFormattedExpirationDate(for: response.foodDetails) ?? "-",
                                    daysLeft: dateManager.getFormattedDaysLeft(for: response.foodDetails) ?? "-",
                                    expirationProgress: dateManager.calculateExpirationProgress(response.foodDetails.productionDate,
                                                                                                response.foodDetails.expirationDate))
        let viewModel = MyFoodModel.FetchFoodDetails.ViewModel(displayedDetails: displayedDetailsFood)
        viewController?.displayFoodDetails(viewModel: viewModel)
    }
    
    func presentEditingFood(response: MyFoodModel.PrepareEditing.Response) {
        let viewModel = MyFoodModel.PrepareEditing.ViewModel()
        viewController?.displayEditingFood(viewModel: viewModel)
    }
    
    func presentFoodItemDeletion(response: MyFoodModel.DeleteFood.Response) {
        let viewModel = MyFoodModel.DeleteFood.ViewModel()
        viewController?.didRemoveFoodItem(viewModel: viewModel)
    }
    
    func presentAllMyFoodRemoving(response: MyFoodModel.RemoveAllMyFood.Response) {
        let viewModel = MyFoodModel.RemoveAllMyFood.ViewModel(alertTitle: "Delete All Products?".localized(),
                                                              alertMessage: "This action will delete all your products, are you sure you want to continue?".localized(),
                                                              confirmActionTitle: "Yes".localized(),
                                                              cancelActionTitle: "No".localized())
        viewController?.didRemoveAllMyFood(viewModel: viewModel)
    }
    
    func presentConfirmRemoveAllMyFood(response: MyFoodModel.ConfirmRemoveAllMyFood.Response) {
        let viewModel = MyFoodModel.ConfirmRemoveAllMyFood.ViewModel(isSuccess: true)
        viewController?.displayConfirmRemoveAllMyFood(viewModel: viewModel)
    }
    
    func presentSharedFood(response: MyFoodModel.FetchSharedFood.Response) {
        let formattedFoodList = response.sharedFood.map { food in
            String("\(food.name.localized()): \(food.weight.localized()) \(food.unit.localized())")
        }.joined(separator: "\n")
        let viewModel = MyFoodModel.FetchSharedFood.ViewModel(foodList: formattedFoodList)
        viewController?.displaySharedFood(viewModel: viewModel)
    }
}
