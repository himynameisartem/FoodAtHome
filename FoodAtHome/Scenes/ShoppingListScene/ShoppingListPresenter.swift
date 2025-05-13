//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListPresentationLogic {
    func presentData(response: ShoppingListModel.FetchShoppingList.Response)
    func presentFoodItemDeletion(response: ShoppingListModel.DeleteFood.Response)
    func presentAddToMyFood(response: ShoppingListModel.AddToMyFood.Response)
    func presentCheckDuplicate(response: ShoppingListModel.CheckDuplicate.Response)
    func presentEditingFood(response: ShoppingListModel.PrepareEditing.Response)
    func presentAllShoppingListRemoved(response: ShoppingListModel.RemoveAllShoppingList.Response)
    func presentSharedShoppingList(response: ShoppingListModel.FetchSharedShoppingList.Response)
    func presentConfirmRemoveAllSharedList(response: ShoppingListModel.ConfirmRemoveAllShoppingList.Response)
    func presentConfirmEditingFood(response: ShoppingListModel.ConfirmEditingFood.Response)
    func presentConfirmAddToMyFood(response: ShoppingListModel.ConfirmAddToMyFood.Response)
    func presentConfirmChangeMyFood(response: ShoppingListModel.ConfirmChangeMyFood.Response)
}

class ShoppingListPresenter: ShoppingListPresentationLogic {
    
    weak var viewController: ShoppingListDisplayLogic?
    
    func presentData(response: ShoppingListModel.FetchShoppingList.Response) {
        let food = response.food.map { food in
            ShoppingListModel.FetchShoppingList.ViewModel.DisplayedFood(name: food.name.localized(),
                                                                        imageName: food.name,
                                                                        calories: food.calories,
                                                                        isShoppingList: food.isShoppingList,
                                                                        weight: food.weight,
                                                                        unit: food.unit.localized())
        }
        let viewModel = ShoppingListModel.FetchShoppingList.ViewModel(displayedFood: food)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentAddToMyFood(response: ShoppingListModel.AddToMyFood.Response) {
        let viewModel = ShoppingListModel.AddToMyFood.ViewModel(alerTitle: "Add an expiration date?".localized(),
                                                                yesActionTitle: "Yes".localized(),
                                                                noActionTitle: "No".localized(),
                                                                indexPath: response.indexPath,
                                                                completion: response.completion
        )
        viewController?.displayAddToMyFood(viewModel: viewModel)
    }
    
    func presentCheckDuplicate(response: ShoppingListModel.CheckDuplicate.Response) {
        if response.shouldConfirm {
            let viewModel = ShoppingListModel.CheckDuplicate.ViewModel(isValid: true,
                                                                       indexPath: response.indexPath,
                                                                       alertTitle: "You already have this product".localized(),
                                                                       alertMessage: "Do you want to replace it?".localized(),
                                                                       confirmActionTitle: "Yes".localized(),
                                                                       cancelActionTitle: "No".localized(),
                                                                       completion: response.completion
            )
            viewController?.displayCheckDuplicate(viewModel: viewModel)
        } else {
            let viewModel = ShoppingListModel.CheckDuplicate.ViewModel(isValid: false,
                                                                       indexPath: response.indexPath,
                                                                       alertTitle: nil,
                                                                       alertMessage: nil,
                                                                       confirmActionTitle: nil,
                                                                       cancelActionTitle: nil,
                                                                       completion: response.completion
            )
            viewController?.displayCheckDuplicate(viewModel: viewModel)
        }
    }
    
    func presentConfirmEditingFood(response: ShoppingListModel.ConfirmEditingFood.Response) {
        let viewModel = ShoppingListModel.ConfirmEditingFood.ViewModel(isSuccess: true)
        viewController?.displayConfirmEditingFood(viewModel: viewModel)
    }
    
    func presentConfirmChangeMyFood(response: ShoppingListModel.ConfirmChangeMyFood.Response) {
        let viewModel = ShoppingListModel.ConfirmChangeMyFood.ViewModel(isSuccess: true)
        viewController?.displayConfirmChangeMyFood(viewModel: viewModel)
    }
    
    func presentConfirmAddToMyFood(response: ShoppingListModel.ConfirmAddToMyFood.Response) {
        let viewModel = ShoppingListModel.ConfirmAddToMyFood.ViewModel(isSuccess: true)
        viewController?.displayConfirmAddToMyFood(viewModel: viewModel)
    }
    
    func presentEditingFood(response: ShoppingListModel.PrepareEditing.Response) {
        let viewModel = ShoppingListModel.PrepareEditing.ViewModel()
        viewController?.displayEditingFood(viewModel: viewModel)
    }
    
    func presentFoodItemDeletion(response: ShoppingListModel.DeleteFood.Response) {
        let viewModel = ShoppingListModel.DeleteFood.ViewModel()
        viewController?.deleteFood(viewModel: viewModel)
    }
    
    func presentAllShoppingListRemoved(response: ShoppingListModel.RemoveAllShoppingList.Response) {
        let viewModel = ShoppingListModel.RemoveAllShoppingList.ViewModel(alertTitle: "Delete All Products?".localized(),
                                                                          alertMessage: "This action will delete all your products, are you sure you want to continue?".localized(),
                                                                          confirmActionTitle: "Yes".localized(),
                                                                          cancelActionTitle: "No".localized())
        viewController?.displayRemoveAllShoppingList(viewModel: viewModel)
    }
    
    func presentSharedShoppingList(response: ShoppingListModel.FetchSharedShoppingList.Response) {
        let formattedShoppingList = response.sharedFood.map { food in
            String("\(food.name.localized()): \(food.weight.localized()) \(food.unit.localized())")
        }.joined(separator: "\n")
        let viewModel = ShoppingListModel.FetchSharedShoppingList.ViewModel(foodList: formattedShoppingList)
        viewController?.displaySharedShoppingList(viewModel: viewModel)
    }
    
    func presentConfirmRemoveAllSharedList(response: ShoppingListModel.ConfirmRemoveAllShoppingList.Response) {
        let viewModel = ShoppingListModel.ConfirmRemoveAllShoppingList.ViewModel(isSuccess: true)
        viewController?.displayConfirmRemoveAllShoppingList(viewModel: viewModel)
    }
}
