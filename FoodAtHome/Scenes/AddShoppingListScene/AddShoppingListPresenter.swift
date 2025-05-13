//
//  AddShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListPresentationLogic {
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response)
    func presentCheckWeightField(response: AddShoppingListModel.CheckWeightField.Response)
    func presentCheckDuplicate(response: AddShoppingListModel.CheckDuplicate.Response)
    func presentCheckEditAction(response: AddShoppingListModel.CheckEditAction.Response)
    func presentConfirmAddFood(response: AddShoppingListModel.ConfirmAddFood.Response)
    func presentConfirmChangeFood(response: AddShoppingListModel.ConfirmChangeFood.Response)
    func presentConfirmEditAction(response: AddShoppingListModel.ConfirmEditAction.Response)
}

class AddShoppingListPresenter: AddShoppingListPresentationLogic {
    weak var viewController: AddShoppingListDisplayLogic?
    
    func presentSelectedFood(response: AddShoppingListModel.ShowFood.Response) {
        let viewModel = AddShoppingListModel.ShowFood.ViewModel(image: response.image, weight: response.weight, unit: response.unit)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentCheckWeightField(response: AddShoppingListModel.CheckWeightField.Response) {
        if response.shouldConfirm {
            let viewModel = AddShoppingListModel.CheckWeightField.ViewModel(isValid: true,
                                                                            aletrtTitle: "Enter the weight of the product".localized(),
                                                                            okButtonTitle: "OK".localized())
            viewController?.displayCheckedWeightField(viewModel: viewModel)
        } else {
            let viewModel = AddShoppingListModel.CheckWeightField.ViewModel(isValid: false,
                                                                            aletrtTitle: nil,
                                                                            okButtonTitle: nil)
            viewController?.displayCheckedWeightField(viewModel: viewModel)
        }
    }
    
    func presentCheckEditAction(response: AddShoppingListModel.CheckEditAction.Response) {
        let viewModel = AddShoppingListModel.CheckEditAction.ViewModel(isValid: response.isEditActionValid)
        viewController?.displayCheckedEditAction(viewModel: viewModel)
    }
    
    func presentCheckDuplicate(response: AddShoppingListModel.CheckDuplicate.Response) {
        if response.shouldConfirm {
            let viewModel = AddShoppingListModel.CheckDuplicate.ViewModel(isValid: true,
                                                                          alertTitle: "You already have this product".localized(),
                                                                          alertMessage: "Do you want to replace it?".localized(),
                                                                          confirmActionTitle: "Yes".localized(),
                                                                          cancelActionTitle: "No".localized())
            viewController?.displayCheckedDuplicate(viewModel: viewModel)
        } else {
            let viewModel = AddShoppingListModel.CheckDuplicate.ViewModel(isValid: false,
                                                                          alertTitle: nil,
                                                                          alertMessage: nil,
                                                                          confirmActionTitle: nil,
                                                                          cancelActionTitle: nil)
            viewController?.displayCheckedDuplicate(viewModel: viewModel)
        }
    }
    
    func presentConfirmAddFood(response: AddShoppingListModel.ConfirmAddFood.Response) {
        let viewModel = AddShoppingListModel.ConfirmAddFood.ViewModel()
        viewController?.displayConfirmAddFood(viewModel: viewModel)
    }
    
    func presentConfirmChangeFood(response: AddShoppingListModel.ConfirmChangeFood.Response) {
        let viewModel = AddShoppingListModel.ConfirmChangeFood.ViewModel()
        viewController?.displayConfirmChangeFood(viewModel: viewModel)
    }
    
    func presentConfirmEditAction(response: AddShoppingListModel.ConfirmEditAction.Response) {
        let viewModel = AddShoppingListModel.ConfirmEditAction.ViewModel()
        viewController?.displayConfirmEditAction(viewModel: viewModel)
    }
}

