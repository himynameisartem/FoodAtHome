//
//  AddShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListBusinessLogic {
    func showSelectedFood(request: AddShoppingListModel.ShowFood.Request)
    func checkWeightField(request: AddShoppingListModel.CheckWeightField.Request)
    func checkDuplicate(request: AddShoppingListModel.CheckDuplicate.Request)
    func checkEditAction(request: AddShoppingListModel.CheckEditAction.Request)
    func confirmAddItemToShoppingList(request: AddShoppingListModel.ConfirmAddFood.Request)
    func confirmChangeFood(request: AddShoppingListModel.ConfirmChangeFood.Request)
    func confirmEditAction(request: AddShoppingListModel.ConfirmEditAction.Request)
}

protocol AddShoppingListDataStore {
    var food: FoodRealm { get set }
}

class AddShoppingListInteractor: AddShoppingListBusinessLogic, AddShoppingListDataStore {
    
    var presenter: AddShoppingListPresentationLogic?
    var food = FoodRealm()
    private let worker: AddShoppingListWorkerProtocol
    
    init(worker: AddShoppingListWorkerProtocol) {
        self.worker = worker
    }
    
    
    func showSelectedFood(request: AddShoppingListModel.ShowFood.Request) {
        let image = worker.getImage(from: food.name)
        let weight = food.weight
        let unit = food.unit
        let response = AddShoppingListModel.ShowFood.Response(image: image, weight: weight, unit: unit)
        presenter?.presentSelectedFood(response: response)
    }
    
    func checkWeightField(request: AddShoppingListModel.CheckWeightField.Request) {
        if request.weight == "" {
            let response = AddShoppingListModel.CheckWeightField.Response(shouldConfirm: true)
            presenter?.presentCheckWeightField(response: response)
        } else {
            let response = AddShoppingListModel.CheckWeightField.Response(shouldConfirm: false)
            presenter?.presentCheckWeightField(response: response)
        }
    }
    
    func checkEditAction(request: AddShoppingListModel.CheckEditAction.Request) {
        if food.weight != "" {
            let response = AddShoppingListModel.CheckEditAction.Response(isEditActionValid: true)
            presenter?.presentCheckEditAction(response: response)
        } else {
            let response = AddShoppingListModel.CheckEditAction.Response(isEditActionValid: false)
            presenter?.presentCheckEditAction(response: response)
        }
    }
    
    func checkDuplicate(request: AddShoppingListModel.CheckDuplicate.Request) {
            if worker.checkDuplicate(food) {
                let response = AddShoppingListModel.CheckDuplicate.Response(shouldConfirm: true)
                presenter?.presentCheckDuplicate(response: response)
            } else {
                let response = AddShoppingListModel.CheckDuplicate.Response(shouldConfirm: false)
                presenter?.presentCheckDuplicate(response: response)
            }
    }
    
    func confirmAddItemToShoppingList(request: AddShoppingListModel.ConfirmAddFood.Request) {
        worker.addFood(from: food, and: request)
        let response = AddShoppingListModel.ConfirmAddFood.Response()
        presenter?.presentConfirmAddFood(response: response)
    }
    
    func confirmChangeFood(request: AddShoppingListModel.ConfirmChangeFood.Request) {
        worker.changeFood(from: food, and: request)
        let response = AddShoppingListModel.ConfirmChangeFood.Response()
        presenter?.presentConfirmChangeFood(response: response)
    }
    
    func confirmEditAction(request: AddShoppingListModel.ConfirmEditAction.Request) {
        worker.changeFood(from: food, and: request)
        let response = AddShoppingListModel.ConfirmEditAction.Response()
        presenter?.presentConfirmEditAction(response: response)
    }
}
