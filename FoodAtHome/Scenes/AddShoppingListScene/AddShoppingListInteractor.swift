//
//  AddShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListBusinessLogic {
    func showSelectedFood(request: AddShoppingListModel.ShowFood.Request)
    func addSelectedFoodToShoppingList(request: AddShoppingListModel.AddFood.Request)
}

protocol AddShoppingListDataStore {
    var food: FoodRealm { get set }
}

class AddShoppingListInteractor: AddShoppingListBusinessLogic, AddShoppingListDataStore {
    
    var presenter: AddShoppingListPresentationLogic?
    var worker: AddShoppingListWorker?
    var food = FoodRealm()
    
    func showSelectedFood(request: AddShoppingListModel.ShowFood.Request) {
        worker = AddShoppingListWorker()
        guard let worker = worker else { return }
        let image = worker.getImage(from: food.name)
        let weight = food.weight
        let unit = food.unit
        let response = AddShoppingListModel.ShowFood.Response(image: image, weight: weight, unit: unit)
        presenter?.presentSelectedFood(response: response)
    }
    
    func addSelectedFoodToShoppingList(request: AddShoppingListModel.AddFood.Request) {
        worker = AddShoppingListWorker()
        guard let worker = worker else { return }
        let food = worker.getFoodForShoppingList(from: food, and: request)
        if request.weight == "" {
            let weightCheckAlertController = UIAlertController(title: "Enter the weight of the product".localized(), message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .default)
            weightCheckAlertController.addAction(okAction)
            let responce = AddShoppingListModel.AddFood.Response(alert: weightCheckAlertController)
            presenter?.presentAlertController(response: responce)
        } else {
            DataManager.shared.writeFood(food)
            let responce = AddShoppingListModel.AddFood.Response(alert: nil)
            presenter?.presentAlertController(response: responce)
        }
    }
    
}
