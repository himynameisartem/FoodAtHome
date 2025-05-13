//
//  AddFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodBusinessLogic {
    func showSelectedFood(request: AddFoodModel.FetchFood.Request)
    func checkWeigthField(request: AddFoodModel.CheckWeightField.Request)
    func checkParent(request: AddFoodModel.CheckParent.Request)
    func checkDuplicateFood(request: AddFoodModel.CheckDuplicateFood.Request)
    func addSelectedFood(request: AddFoodModel.AddFood.Request)
    func changeSelectedFood(request: AddFoodModel.ChangeFood.Request)
    func updateDates(request: AddFoodModel.DateUpdate.Request)
    func updatePickerValues(request: AddFoodModel.DatePickerValueUpdate.Request)
}

protocol AddFoodDataStore {
    var food: FoodRealm { get set }
}

class AddFoodInteractor: AddFoodBusinessLogic, AddFoodDataStore {
    
    var presenter: AddFoodPresentationLogic?
    var food = FoodRealm()
    var worker: AddFoodWorkerProtocol
    
    init (worker: AddFoodWorkerProtocol) {
        self.worker = worker
    }
    
    func showSelectedFood(request: AddFoodModel.FetchFood.Request) {
        let responce = AddFoodModel.FetchFood.Response(imageName: food.name,
                                                       weight: food.weight,
                                                       unit: (food.unit == "") ? "kg.".localized() : food.unit.localized(),
                                                       productionDate: worker.getProductionDate(food),
                                                       expirationDate: worker.getExpirationDate(food),
                                                       consumeUp: worker.getConsumerUp(food))
        presenter?.presentData(response: responce)
    }
    
    func checkWeigthField(request: AddFoodModel.CheckWeightField.Request) {
        if request.weight == "" {
            presenter?.presentCheckWeightField(response: AddFoodModel.CheckWeightField.Response(shouldConfirm: true))
        } else {
            presenter?.presentCheckWeightField(response: AddFoodModel.CheckWeightField.Response(shouldConfirm: false))
        }
    }
    
    func checkParent(request: AddFoodModel.CheckParent.Request) {
        if worker.isEditingFood(request.view) {
            presenter?.presentCheckParent(response: AddFoodModel.CheckParent.Response(isEditing: true))
        } else {
            presenter?.presentCheckParent(response: AddFoodModel.CheckParent.Response(isEditing: false))
        }
    }
    
    func checkDuplicateFood(request: AddFoodModel.CheckDuplicateFood.Request) {
        if worker.checkFoodListDuplicate(food) {
            let response = AddFoodModel.CheckDuplicateFood.Response(isDuplicate: true)
            presenter?.presentCheckDuplicateFood(response: response)
        } else {
            let response = AddFoodModel.CheckDuplicateFood.Response(isDuplicate: false)
            presenter?.presentCheckDuplicateFood(response: response)
        }
    }
    
    func addSelectedFood(request: AddFoodModel.AddFood.Request) {
        worker.addFoodToMyFoodList(food: worker.fetchFoodForAdding(from: request, and: food))
        let response = AddFoodModel.AddFood.Response(shouldConfirm: true)
        presenter?.presentAddSelectedFood(responce: response)
    }
    
    func changeSelectedFood(request: AddFoodModel.ChangeFood.Request) {
        worker.changeDuplicateFood(food: worker.fetchFoodForAdding(from: request, and: food))
        let response = AddFoodModel.ChangeFood.Response(shouldConfirm: true)
        presenter?.presentChangeSelectedFood(response: response)
    }
    
    func updateDates(request: AddFoodModel.DateUpdate.Request) {
        var productionDate = request.productionDate
        var expirationDate = request.expirationDate
        var consumeUpMonths = request.consumeUpMonths
        var consumeUpDays = request.consumeUpDays
        
        switch request.activeField {
        case .productionDate:
            if let datePickerDate = request.datePickerDate {
                productionDate = datePickerDate.formattedDateString()
                if let prodDate = productionDate, let expDate = expirationDate,
                   !prodDate.isEmpty, !expDate.isEmpty {
                    let consumeUp = worker.calculateConsumeUp(productionDate: prodDate, expirationDate: expDate)
                    consumeUpMonths = consumeUp?.months
                    consumeUpDays = consumeUp?.days
                }
            }
        case .expirationDate:
            if let datePickerDate = request.datePickerDate {
                expirationDate = datePickerDate.formattedDateString()
                if let prodDate = productionDate, let expDate = expirationDate,
                   !prodDate.isEmpty, !expDate.isEmpty {
                    let consumeUp = worker.calculateConsumeUp(productionDate: prodDate, expirationDate: expDate)
                    consumeUpMonths = consumeUp?.months
                    consumeUpDays = consumeUp?.days
                }
            }
        case .consumeUp:
            guard let months = consumeUpMonths, let days = consumeUpDays else { return }
            expirationDate = worker.calculateExpirationDate(
                months: months,
                days: days,
                productionDate: productionDate
            )
        }
        let response = AddFoodModel.DateUpdate.Response(productionDate: productionDate,
                                                        expirationDate: expirationDate,
                                                        consumeUpMonths: consumeUpMonths,
                                                        consumeUpDays: consumeUpDays
        )
        presenter?.presentUpdatedDates(response: response)
    }
    
    func updatePickerValues(request: AddFoodModel.DatePickerValueUpdate.Request) {
        let productionDate = request.productionDate
        let expirationDate = request.expirationDate
        
        var response: AddFoodModel.DatePickerValueUpdate.Response
        
        switch request.activeField {
        case .productionDate:
            let productionDatePickerValues = worker.productionDatePickerValues(productionDate)
            response = AddFoodModel.DatePickerValueUpdate.Response(pickerCurrentValue: productionDatePickerValues.currentDate,
                                                                   pickerMinValue: nil,
                                                                   pickerMaxValue: productionDatePickerValues.maximumDate,
                                                                   consumeUpDate: nil)
        case .expirationDate:
            let expirationDatePickerValues = worker.expirationDatePickerValues(productionDate, expirationDate)
            response = AddFoodModel.DatePickerValueUpdate.Response(pickerCurrentValue: expirationDatePickerValues.currentDate,
                                                                   pickerMinValue: expirationDatePickerValues.minimumDate,
                                                                   pickerMaxValue: nil,
                                                                   consumeUpDate: nil)
            
        case .consumeUp:
            let consumeUpDatePickerValues = worker.calculateConsumeUp(productionDate: productionDate, expirationDate: expirationDate)
            response = AddFoodModel.DatePickerValueUpdate.Response(pickerCurrentValue: nil,
                                                                   pickerMinValue: nil,
                                                                   pickerMaxValue: nil,
                                                                   consumeUpDate: consumeUpDatePickerValues)
        }
        presenter?.presentPickerValues(response: response)
    }
}
