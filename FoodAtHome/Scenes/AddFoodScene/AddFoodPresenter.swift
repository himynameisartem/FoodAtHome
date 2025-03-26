//
//  AddFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodPresentationLogic {
    func presentData(response: AddFoodModel.ShowFood.Response)
    func presentUpdatedDates(response: AddFoodModel.DateUpdate.Response)
    func presentPickerValues(response: AddFoodModel.DatePickerValueUpdate.Response)
    func presentAddSelectedFood(responce: AddFoodModel.AddFood.Response)
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
    
    func presentAddSelectedFood(responce: AddFoodModel.AddFood.Response) {
        let viewModelResponse = AddFoodModel.AddFood.Response(alertController: responce.alertController)
        let viewModel = AddFoodModel.AddFood.ViewModel(alertController: viewModelResponse.alertController)
        viewController?.displayAlert(viewModel: viewModel)
    }
}
