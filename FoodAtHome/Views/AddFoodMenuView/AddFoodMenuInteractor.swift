//
//  AddFoodMenuInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.12.2024.
//

import UIKit

protocol AddFoodMenuBusinessLogic {
    func showFood(request: AddFoodMenuModel.ShowFood.Request)
}

protocol AddFoodMenuDataStore {
    var food: FoodRealm { get }
}

class AddFoodMenuInteractor: AddFoodMenuBusinessLogic, AddFoodMenuDataStore {
    
    var food = FoodRealm()
    var presenter: AddFoodMenuPresentationLogic?
    
    func showFood(request: AddFoodMenuModel.ShowFood.Request) {
        
        let responce = AddFoodMenuModel.ShowFood.Responce(food: food)
        presenter?.presentFood(responce: responce)
    }
}
