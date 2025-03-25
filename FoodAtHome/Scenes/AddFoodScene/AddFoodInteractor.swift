//
//  AddFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodBusinessLogic {
    func showSelectedFood(request: AddFoodModel.ShowFood.Request)
    func addSelectedFood(request: AddFoodModel.ShowFood.Request)
    func updateDates(request: AddFoodModel.DateUpdate.Request)
    func updatePickerValues(request: AddFoodModel.DatePickerValueUpdate.Request)
    func handleCloseRequest()
}

protocol AddFoodDataStore {
    var food: FoodRealm { get set }
}

class AddFoodInteractor: AddFoodBusinessLogic, AddFoodDataStore {
    
    var presenter: AddFoodPresentationLogic?
    var food = FoodRealm()
    var worker: AddFoodWorker?
    
    func showSelectedFood(request: AddFoodModel.ShowFood.Request) {
        let responce = AddFoodModel.ShowFood.Response(food: food)
        presenter?.presentData(response: responce)
    }
    
    func addSelectedFood(request: AddFoodModel.ShowFood.Request) {
        let responce = AddFoodModel.AddFood.Response(food: food)
        presenter?.presentAddSelectedFood(responce: responce)
    }
    
    func updateDates(request: AddFoodModel.DateUpdate.Request) {
        worker = AddFoodWorker()
        guard let worker = worker else { return }
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
        let response = AddFoodModel.DateUpdate.Response(
            productionDate: productionDate,
            expirationDate: expirationDate,
            consumeUpMonths: consumeUpMonths,
            consumeUpDays: consumeUpDays
        )
        
        presenter?.presentUpdatedDates(response: response)
    }
    
    func updatePickerValues(request: AddFoodModel.DatePickerValueUpdate.Request) {
        worker = AddFoodWorker()
        guard let worker = worker else { return }
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
    
    func handleCloseRequest() {
        presenter?.presentCloseAnimation()
    }
    
}
