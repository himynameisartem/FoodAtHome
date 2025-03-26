//
//  AddShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListBusinessLogic {
    func showSelectedFood(request: AddShoppingListModel.ShowFood.Request)
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
        print(food)
        presenter?.presentSelectedFood(response: response)
    }
    
}
