//
//  AddFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodPresentationLogic {
    func presentData(response: AddFoodModel.FetchFood.Response)
    func presentCheckWeightField(response: AddFoodModel.CheckWeightField.Response)
    func presentCheckParent(response: AddFoodModel.CheckParent.Response)
    func presentCheckDuplicateFood(response: AddFoodModel.CheckDuplicateFood.Response)
    func presentAddSelectedFood(responce: AddFoodModel.AddFood.Response)
    func presentChangeSelectedFood(response: AddFoodModel.ChangeFood.Response)
    func presentUpdatedDates(response: AddFoodModel.DateUpdate.Response)
    func presentPickerValues(response: AddFoodModel.DatePickerValueUpdate.Response)
}

class AddFoodPresenter: AddFoodPresentationLogic {
    
    weak var viewController: AddFoodDisplayLogic?
    
    func presentData(response: AddFoodModel.FetchFood.Response) {
        let image = UIImage(named: response.imageName) ?? UIImage()
        let displayedFood = AddFoodModel.FetchFood.ViewModel.DisplayedFood(image: image,
                                                                           weight: response.weight,
                                                                           unit: response.unit,
                                                                           productionDate: response.productionDate,
                                                                           expirationDate: response.expirationDate,
                                                                           consumeUp: response.consumeUp)
        let viewModel = AddFoodModel.FetchFood.ViewModel(displayedFood: displayedFood)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentCheckWeightField(response: AddFoodModel.CheckWeightField.Response) {
        if response.shouldConfirm {
            let viewModel = AddFoodModel.CheckWeightField.ViewModel(isValid: true,
                                                                    alertTitle: "Enter the weight of the product".localized(),
                                                                    confirmActionTitle: "OK".localized())
            viewController?.displayCheckWeightField(viewModel: viewModel)
        } else {
            let viewModel = AddFoodModel.CheckWeightField.ViewModel(isValid: false,
                                                                    alertTitle: nil,
                                                                    confirmActionTitle: nil)
            viewController?.displayCheckWeightField(viewModel: viewModel)
        }
    }
    
    func presentCheckParent(response: AddFoodModel.CheckParent.Response) {
        let viewModel = AddFoodModel.CheckParent.ViewModel(isValid: response.isEditing)
        viewController?.displayCheckParent(viewModel: viewModel)
    }
    
    func presentCheckDuplicateFood(response: AddFoodModel.CheckDuplicateFood.Response) {
        if response.isDuplicate {
            let viewModel = AddFoodModel.CheckDuplicateFood.ViewModel(isValid: true,
                                                                      alertTitle: "You already have this product".localized(),
                                                                      alertMessage: "Do you want to replace it?".localized(),
                                                                      confirmActionTitle: "Yes".localized(),
                                                                      cancelActionTitle: "No".localized())
            viewController?.displayCheckDuplicateFood(viewModel: viewModel)
        } else {
            let viewModel = AddFoodModel.CheckDuplicateFood.ViewModel(isValid: false,
                                                                      alertTitle: nil,
                                                                      alertMessage: nil,
                                                                      confirmActionTitle: nil,
                                                                      cancelActionTitle: nil)
            viewController?.displayCheckDuplicateFood(viewModel: viewModel)
        }
    }
    
    func presentAddSelectedFood(responce: AddFoodModel.AddFood.Response) {
        let viewModel = AddFoodModel.AddFood.ViewModel()
        viewController?.displayAddSelectedFood(viewModel: viewModel)
    }
    
    func presentChangeSelectedFood(response: AddFoodModel.ChangeFood.Response) {
        let viewModel = AddFoodModel.ChangeFood.ViewModel()
        viewController?.displayChangeSelectedFood(viewModel: viewModel)
    }
    
    func presentUpdatedDates(response: AddFoodModel.DateUpdate.Response) {
        let consumeUpText = response.consumeUpMonths != nil && response.consumeUpDays != nil
        ? "\(response.consumeUpMonths!)\("m.".localized()) \(response.consumeUpDays!)\("d.".localized())"
        : nil
        
        let viewModel = AddFoodModel.DateUpdate.ViewModel(
            productionDate: response.productionDate,
            expirationDate: response.expirationDate,
            consumeUpText: consumeUpText
        )
        viewController?.displayUpdatedDates(viewModel: viewModel)
    }
    
    func presentPickerValues(response: AddFoodModel.DatePickerValueUpdate.Response) {
        let response = AddFoodModel.DatePickerValueUpdate.ViewModel.DisplayedValues(pickerCurrentValue: response.pickerCurrentValue ?? Date(),
                                                                                    pickerMinValue: response.pickerMinValue,
                                                                                    pickerMaxValue: response.pickerMaxValue,
                                                                                    currentMonthsPicker: response.consumeUpDate?.months ?? 0,
                                                                                    currentDaysPicker: response.consumeUpDate?.days ?? 0)
        let viewModel = AddFoodModel.DatePickerValueUpdate.ViewModel(displayedValues: response)
        viewController?.displayUpdatePickerValues(viewModel: viewModel)
    }
    
}
